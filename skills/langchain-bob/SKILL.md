---
name: langchain-bob
description: >-
  Use when the user wants to build an AI agent that calls Bob as a tool, use Bob programmatically with LangChain or LangGraph, create a Bob-powered agentic pipeline, invoke Bob via ACP (Agent Client Protocol), or chain Bob with other AI models.
---

# LangChain + Bob Integration

Build multi-agent pipelines that use IBM Bob as a callable tool via ACP.

## Step 1 — Start Bob as an ACP Server
Bob exposes the Agent Client Protocol (ACP) for programmatic integration:
```bash
# Start Bob as an ACP server on port 8001
bob acp --port 8001 --workspace /path/to/project
```

## Step 2 — Connect via ACP Python Client
```python
import httpx
import asyncio

BOB_ACP_URL = "http://localhost:8001"

async def run_bob_task(prompt: str, workspace: str = ".") -> str:
    async with httpx.AsyncClient(timeout=120) as client:
        # Create a task
        response = await client.post(f"{BOB_ACP_URL}/runs", json={
            "agent_id": "bob",
            "input": [{"role": "user", "content": prompt}],
        })
        response.raise_for_status()
        run = response.json()
        run_id = run["run_id"]

        # Poll for completion
        while True:
            status = await client.get(f"{BOB_ACP_URL}/runs/{run_id}")
            data = status.json()
            if data["status"] in ("completed", "failed", "error"):
                return data.get("output", [{}])[-1].get("content", "")
            await asyncio.sleep(1)

# Usage
result = asyncio.run(run_bob_task("Refactor src/auth.ts to use JWT refresh tokens"))
print(result)
```

## Step 3 — Use Bob as a LangGraph Node
```python
from langgraph.graph import StateGraph, END
from typing import TypedDict

class AgentState(TypedDict):
    task: str
    bob_output: str
    final_report: str

async def bob_node(state: AgentState) -> AgentState:
    result = await run_bob_task(state["task"])
    return {**state, "bob_output": result}

async def report_node(state: AgentState) -> AgentState:
    report = f"Bob completed: {state['bob_output'][:200]}..."
    return {**state, "final_report": report}

graph = StateGraph(AgentState)
graph.add_node("bob", bob_node)
graph.add_node("report", report_node)
graph.set_entry_point("bob")
graph.add_edge("bob", "report")
graph.add_edge("report", END)

app = graph.compile()
result = await app.ainvoke({"task": "Write tests for the payment module"})
print(result["final_report"])
```

## Step 4 — Bob as a LangChain Tool
```python
from langchain_core.tools import tool

@tool
async def ask_bob(task: str) -> str:
    """Delegate a coding task to IBM Bob. Bob can read files, write code,
    run tests, and implement features in the current workspace."""
    return await run_bob_task(task)

# Use in a ReAct agent
from langgraph.prebuilt import create_react_agent
from langchain_openai import ChatOpenAI

orchestrator = create_react_agent(
    ChatOpenAI(model="gpt-4o"),
    tools=[ask_bob],
)
```

## Step 5 — Multi-Bob Parallelism
```python
import asyncio

async def run_parallel_tasks(tasks: list[str]) -> list[str]:
    return await asyncio.gather(*[run_bob_task(t) for t in tasks])

results = asyncio.run(run_parallel_tasks([
    "Add unit tests for src/auth.ts",
    "Add unit tests for src/payments.ts",
    "Add unit tests for src/notifications.ts",
]))
```

## Verification Checklist
- [ ] Bob ACP server started before running pipelines
- [ ] Workspace path correctly set in ACP server args
- [ ] Polling loop has a max timeout to prevent infinite waits
- [ ] Tasks are self-contained (Bob has all context it needs in the prompt)
- [ ] Sensitive data not logged from Bob's output
