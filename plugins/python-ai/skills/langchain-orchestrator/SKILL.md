---
name: langchain-orchestrator
description: >-
  Use when the user wants to build a LangChain agent, chain LLM calls, implement a RAG pipeline with LangChain, use LangGraph for multi-agent orchestration, or debug a LangChain chain.
---

# LangChain Orchestrator

Build production LangChain pipelines with proper error handling, observability, and type safety.

## Step 1 — Set Up the LLM
```python
from langchain_openai import ChatOpenAI
from langchain_core.messages import HumanMessage, SystemMessage

llm = ChatOpenAI(model="gpt-4o", temperature=0)
```

## Step 2 — Define Tools with Type Safety
```python
from langchain_core.tools import tool
from pydantic import BaseModel

class SearchInput(BaseModel):
    query: str

@tool(args_schema=SearchInput)
def search(query: str) -> str:
    """Search the web for information."""
    # implementation
    return f"Results for: {query}"
```

## Step 3 — Build a ReAct Agent
```python
from langgraph.prebuilt import create_react_agent

agent = create_react_agent(llm, tools=[search])
result = agent.invoke({"messages": [HumanMessage(content="What is the weather in NYC?")]})
```

## Step 4 — Add LangSmith Observability
```python
import os
os.environ["LANGCHAIN_TRACING_V2"] = "true"
os.environ["LANGCHAIN_API_KEY"] = os.getenv("LANGSMITH_API_KEY")
```

## Step 5 — Validate Output with Pydantic
```python
from langchain_core.output_parsers import PydanticOutputParser

class Answer(BaseModel):
    answer: str
    confidence: float

parser = PydanticOutputParser(pydantic_object=Answer)
```

## Verification Checklist
- [ ] LLM calls have retry logic
- [ ] All tool outputs are validated
- [ ] LangSmith tracing enabled in development
- [ ] Token usage logged
