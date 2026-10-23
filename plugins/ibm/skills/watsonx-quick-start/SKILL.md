---
name: watsonx-quick-start
description: >-
  Use when the user wants to quickly get started with IBM watsonx.ai, needs a minimal working example of watsonx text generation, or wants to verify their watsonx credentials and connection before building a full integration.
---

# watsonx Quick Start

Get a working watsonx.ai call running in under 5 minutes.

## Step 1 — Install the SDK
```bash
pip install ibm-watsonx-ai
```

## Step 2 — Set Environment Variables
```bash
export WATSONX_API_KEY="your-ibm-cloud-api-key"
export WATSONX_PROJECT_ID="your-watsonx-project-id"
export WATSONX_URL="https://us-south.ml.cloud.ibm.com"
```

## Step 3 — Run a Minimal Test
```python
from ibm_watsonx_ai import APIClient, Credentials
from ibm_watsonx_ai.foundation_models import ModelInference
import os

credentials = Credentials(
    url=os.environ["WATSONX_URL"],
    api_key=os.environ["WATSONX_API_KEY"],
)

model = ModelInference(
    model_id="ibm/granite-13b-chat-v2",
    credentials=credentials,
    project_id=os.environ["WATSONX_PROJECT_ID"],
)

response = model.generate_text(prompt="What is IBM watsonx.ai in one sentence?")
print(response)
```

## Step 4 — Verify It Works
Expected output: a short paragraph about watsonx.ai.
If you see an authentication error:
- Verify `WATSONX_API_KEY` is an IBM Cloud API key (not a watsonx-specific key)
- Verify `WATSONX_PROJECT_ID` is the project GUID from watsonx.ai → Manage → General

## Verification Checklist
- [ ] Response prints successfully without errors
- [ ] No credentials hardcoded in source files
- [ ] `WATSONX_PROJECT_ID` is confirmed in watsonx.ai project settings
