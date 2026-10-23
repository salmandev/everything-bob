---
name: watsonx-assistant
description: >-
  Use when the user wants to build a virtual assistant with IBM watsonx Assistant, design dialog flows, create intents and entities, integrate watsonx Assistant with a website or application, use the watsonx Assistant API, or migrate from Watson Assistant Classic.
---

# watsonx Assistant

Build enterprise virtual assistants with IBM watsonx Assistant — dialog design, API integration, and deployment.

## Step 1 — Core Concepts
| Concept | Description |
| --- | --- |
| **Action** | A conversational step that gathers info and takes action |
| **Intent** | What the user wants to do (e.g. `book_flight`) |
| **Entity** | Key information extracted from input (e.g. `@city`) |
| **Session** | Stores context variables across turns |
| **Integration** | Channel where assistant is deployed (web, Slack, phone) |

## Step 2 — watsonx Assistant REST API
```typescript
import AssistantV2 from 'ibm-watson/assistant/v2';
import { IamAuthenticator } from 'ibm-watson/auth';

const assistant = new AssistantV2({
  version: '2023-06-15',
  authenticator: new IamAuthenticator({
    apikey: process.env.WATSONX_ASSISTANT_API_KEY!,
  }),
  serviceUrl: process.env.WATSONX_ASSISTANT_URL,
});

// Create a session
const session = await assistant.createSession({
  assistantId: process.env.WATSONX_ASSISTANT_ID!,
});
const sessionId = session.result.session_id;

// Send a message
const response = await assistant.message({
  assistantId: process.env.WATSONX_ASSISTANT_ID!,
  sessionId,
  input: {
    message_type: 'text',
    text: 'I need help with my order',
    options: { return_context: true },
  },
  context: {
    skills: {
      'main skill': {
        user_defined: { account_id: userId },
      },
    },
  },
});

// Extract text response
const replies = response.result.output.generic
  ?.filter(r => r.response_type === 'text')
  .map(r => r.text)
  .join(' ');
```

## Step 3 — Webhook Action Integration
Connect watsonx Assistant to your backend via webhooks:
```typescript
// Express endpoint that watsonx Assistant calls
app.post('/webhook/assistant', async (req, res) => {
  const { input, context } = req.body;
  const userId = context?.skills?.['main skill']?.user_defined?.account_id;

  // Process the action
  const orderStatus = await getOrderStatus(userId);

  // Return structured response
  res.json({
    output: {
      generic: [
        {
          response_type: 'text',
          text: `Your order status is: ${orderStatus}`,
        },
      ],
    },
    context: {
      skills: {
        'main skill': {
          user_defined: { last_checked: new Date().toISOString() },
        },
      },
    },
  });
});
```

## Step 4 — Web Chat Embed
```html
<!-- Embed watsonx Assistant web chat widget -->
<script>
  window.watsonAssistantChatOptions = {
    integrationID: "YOUR_INTEGRATION_ID",
    region: "us-south",
    serviceInstanceID: "YOUR_INSTANCE_ID",
    onLoad: async (instance) => { await instance.render(); },
  };
  setTimeout(function(){
    const t = document.createElement('script');
    t.src = "https://web-chat.global.assistant.watson.appdomain.cloud/" +
            "versions/latest/WatsonAssistantChatEntry.js";
    document.head.appendChild(t);
  });
</script>
```

## Step 5 — Session Management Best Practices
- Sessions expire after 5 minutes of inactivity (configurable up to 7 days)
- Delete sessions explicitly after conversation ends to free resources
- Store `session_id` server-side keyed to user ID, not in the browser
- Use `context.skills.main skill.user_defined` to pass user data

## Verification Checklist
- [ ] API key stored in environment variables (never in client-side code)
- [ ] Sessions deleted when conversation ends: `assistant.deleteSession()`
- [ ] Webhook endpoint validates IBM signature header
- [ ] Response `generic` array handled for all `response_type` values (text, option, image)
- [ ] Context variables used for user personalization, not hardcoded
