---
name: bob-context-manager
description: >-
  Use when Bob needs to manage context across a long task, the conversation is approaching context limits, the user wants Bob to summarize and compress the current session, or to save and restore task state between sessions.
---

# Bob Context Manager

Manage context efficiently across long tasks and multi-session work.

## Step 1 — Detect Context Pressure
Signs you need context management:
- The task spans more than 50 tool calls
- You have been asked to "remember" something from earlier
- The user says "continue from where we left off"
- You are repeating tool calls you already made

## Step 2 — Create a Task Checkpoint File
Write a compact checkpoint to `.bob/context/checkpoint.md`:
```markdown
# Task Checkpoint — <task title>
**Date**: YYYY-MM-DD HH:MM
**Status**: In Progress

## What Was Accomplished
- [x] Step 1: description of completed work
- [x] Step 2: description of completed work
- [ ] Step 3: next pending action

## Key Decisions Made
- Decision 1: chose X over Y because Z
- Decision 2: the schema uses UUID primary keys

## Files Modified
- `src/auth.ts` — added JWT refresh token rotation
- `tests/auth.test.ts` — added 4 new test cases

## Open Questions
- Question 1 (still unresolved)

## Next Action
Exact next step to take when resuming.
```

## Step 3 — Summarize Current Understanding
Before compressing context, write a summary:
1. What is the overall goal of this task?
2. What has been done so far?
3. What are the 3 most important things to remember?
4. What is the exact next step?

## Step 4 — Resume from a Checkpoint
When resuming a task:
1. Read `.bob/context/checkpoint.md` with `read_file`
2. Run `git log --oneline -5` to see recent commits
3. Run the test suite to confirm current state
4. State: "Resuming from checkpoint. Last completed: X. Next action: Y."

## Step 5 — Progressive Context Strategy
For very long tasks:
- Keep rules and context files minimal (reference, don't repeat)
- Use `grep` to find information rather than `read_file` on large files
- Summarize what you learned instead of quoting verbatim
- Delete outdated checkpoint files once a task is complete

## Verification Checklist
- [ ] Checkpoint file written to `.bob/context/checkpoint.md`
- [ ] Checkpoint captures exact next action (not vague)
- [ ] Modified files listed with description of changes
- [ ] Open questions explicitly listed
