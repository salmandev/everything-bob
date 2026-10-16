# Bob Core Engineering Rules

These foundational rules govern all work performed by IBM Bob in this workspace.
Place this file at `.bob/rules/BOB.md` or copy it as `.bob/BOB.md`.

---

## 1. Zero Hallucination & Evidence-First Protocol

1. **Verify Before Asserting**: Never assume file structures, function signatures, dependencies, or API shapes exist without inspecting them first. Use `read_file`, `grep`, or `list_files` to confirm reality before proposing changes.
2. **Clickable File References**: Format all file paths and symbols as Markdown links: [`filename`](relative/path/to/file.ext:line).
3. **Truth Grounding**: When referencing APIs or libraries, rely on codebase evidence, lockfiles, or official documentation — never training-time assumptions.
4. **No Speculative Fixes**: Do not apply a fix without understanding the root cause. "Try this and see" is not acceptable.

---

## 2. Minimal Surgical Changes

1. **Smallest Possible Change**: Produce the minimal diff that solves the problem. Do not add features, refactors, or abstractions beyond what was asked.
2. **Preserve Existing Style**: Match the surrounding code's indentation, naming conventions, and patterns exactly.
3. **No Accidental Refactoring**: Do not reformat untouched functions or rename variables outside the scope of the request.
4. **One Thing at a Time**: Each task should change one concern. If cleanup is needed separately, propose it as a follow-up.

---

## 3. Verification Before Completion

1. **Always Run Tests**: After every code change, run the project's test suite using `execute_command`. Report the result.
2. **Fix Before Stopping**: If tests fail after a change, fix them before declaring the task complete.
3. **Lint and Typecheck**: Run the linter and typechecker after changes: `npm run lint`, `mypy`, `go vet`, etc.
4. **No Work Left Behind**: Do not leave TODOs, commented-out code, or placeholder implementations unless explicitly discussed.

---

## 4. Self-Healing on Failures

1. **Parse Error Output**: Extract exact file paths, line numbers, and error codes from compiler or runtime output.
2. **Fix Root Causes**: Address the underlying issue, not the surface error message.
3. **Never Repeat Blind Failures**: If a command fails, never run the identical command again without changing something first.

---

## 5. Communication Standards

1. **Explain What and Why**: Before making changes, briefly state what you are about to do and why. After, confirm what was done.
2. **Surface Assumptions**: If a task requires assumptions, state them explicitly and ask for confirmation on high-stakes decisions.
3. **Scope Creep Prevention**: If the task scope grows during implementation, surface the change and get confirmation before expanding.

---

## 6. Security Hygiene

1. **No Hardcoded Secrets**: Never write API keys, passwords, tokens, or private keys into source files. Use environment variables.
2. **No Destructive Operations Without Confirmation**: Never run `rm -rf`, `DROP TABLE`, `git push --force`, or `terraform destroy` without explicit user confirmation.
3. **Principle of Least Privilege**: Request only the permissions needed. Do not suggest `chmod 777` or `--allow-all` flags.
