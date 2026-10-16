---
name: watsonx-integration
description: >-
  Use when the user wants to integrate IBM watsonx.ai, deploy a foundation model, write prompts for watsonx, use the watsonx Python SDK, set up watsonx.governance, evaluate model outputs, or connect watsonx to an application.
---

# watsonx.ai Integration

Build production integrations with IBM watsonx.ai — the enterprise AI platform.

## Step 1 — Set Up the watsonx Python SDK
```bash
pip install ibm-watsonx-ai
```

```python
from ibm_watsonx_ai import APIClient, Credentials
import os

credentials = Credentials(
    url="https://us-south.ml.cloud.ibm.com",
    api_key=os.environ["WATSONX_API_KEY"],
)
client = APIClient(credentials=credentials, project_id=os.environ["WATSONX_PROJECT_ID"])
```

## Step 2 — Generate Text with a Foundation Model
```python
from ibm_watsonx_ai.foundation_models import ModelInference
from ibm_watsonx_ai.metanames import GenTextParamsMetaNames as GenParams

model = ModelInference(
    model_id="ibm/granite-13b-chat-v2",
    credentials=credentials,
    project_id=os.environ["WATSONX_PROJECT_ID"],
    params={
        GenParams.MAX_NEW_TOKENS: 512,
        GenParams.TEMPERATURE: 0.7,
        GenParams.STOP_SEQUENCES: ["\n\n"],
    },
)

response = model.generate_text(prompt="Summarize the following contract: ...")
print(response)
```

## Step 3 — Stream Responses
```python
for chunk in model.generate_text_stream(prompt="Explain quantum computing:"):
    print(chunk, end="", flush=True)
```

## Step 4 — Use Embeddings for RAG
```python
from ibm_watsonx_ai.foundation_models import Embeddings

embeddings = Embeddings(
    model_id="ibm/slate-30m-english-rtrvr",
    credentials=credentials,
    project_id=os.environ["WATSONX_PROJECT_ID"],
)
vectors = embeddings.embed_documents(texts=["text one", "text two"])
```

## Step 5 — Prompt Engineering for IBM Granite Models
Use structured prompts for best Granite results:
```
<|system|>
You are a helpful IBM enterprise assistant. Be concise and cite sources.
<|user|>
{user_input}
<|assistant|>
```

Available IBM Granite model IDs:
- `ibm/granite-13b-chat-v2` — general chat
- `ibm/granite-34b-code-instruct` — code generation
- `ibm/granite-13b-instruct-v2` — instruction following
- `ibm/granite-7b-lab` — lightweight lab model

## Step 6 — Deploy to watsonx.ai Online Deployment
```python
meta_props = {
    client.deployments.ConfigurationMetaNames.NAME: "my-deployment",
    client.deployments.ConfigurationMetaNames.ONLINE: {},
}
deployment = client.deployments.create(asset_id=model_id, meta_props=meta_props)
```

## Step 7 — Evaluate with watsonx.governance
```python
from ibm_watsonx_ai.foundation_models.utils.enums import DecodingMethods
# Log predictions to OpenScale/Watson OpenPages for governance tracking
```

## Verification Checklist
- [ ] API key and project ID in environment variables (never hardcoded)
- [ ] Model ID confirmed valid for the target region
- [ ] Token usage logged for cost tracking
- [ ] Prompt injection defenses in place for user-controlled input
- [ ] Responses validated with Pydantic before use in downstream logic
