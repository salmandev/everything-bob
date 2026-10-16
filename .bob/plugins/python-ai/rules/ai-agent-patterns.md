# Python AI Agent Patterns

## 1. LLM Interaction Safety
1. **Validate LLM output**: Never trust raw LLM output as structured data. Parse and validate with Pydantic.
2. **Prompt injection defense**: Never construct prompts by concatenating untrusted user input directly.
3. **Token budget awareness**: Estimate token counts before sending to the API. Log token usage in production.

## 2. Agent Design
1. **Deterministic tools**: Agent tools must be pure functions where possible. Side effects must be logged.
2. **Circuit breakers**: All LLM API calls must have retry logic with exponential backoff and a max retry count.
3. **Observability**: Log the full prompt, response, and latency for every LLM call in development.

## 3. RAG & Retrieval
1. **Chunk size matters**: Benchmark chunk sizes (512, 1024, 2048 tokens) for your specific retrieval task.
2. **Hybrid retrieval**: Combine dense vector search with BM25 sparse retrieval for better recall.
3. **Re-ranking**: Apply a cross-encoder re-ranker to the top-K retrieved chunks before sending to the LLM.
