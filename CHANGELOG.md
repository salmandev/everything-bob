# Changelog

All notable changes to everything-bob are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [1.0.0] - 2025-10-16

### Added
- Initial release of everything-bob
- 30 progressive-disclosure skills covering full-stack, DevOps, security, and Bob-native workflows
- 7 lifecycle hook bundles (safety-shield, secret-scrubber, auto-lint-formatter, goal-verifier, context-injector, learned-instincts, bob-shield)
- 8 scoped subagent specifications (planner, code-reviewer, build-repair, browser-qa, security-auditor, architect, database-migrator, performance-tuner)
- 5 custom Bob modes (bob-architect, bob-security-auditor, bob-tdd-enforcer, bob-devops-engineer, bob-docs-writer)
- 4 domain plugins (web-fullstack, python-ai, security-shield, devops)
- 7 curated MCP server blueprints
- Full hierarchical rules system (common, languages, paradigms)
- Zero-dependency Node.js CLI (`everything-bob`)
- Installation profiles: core, developer, full
- GitHub Actions composite action support

## [1.1.0] - 2025-10-16

### Added — 7 New Skills
- `watsonx-integration` — IBM watsonx.ai SDK, Granite model inference, embeddings, streaming, governance
- `ibm-cloud-deploy` — IBM Code Engine, IKS, IBM Container Registry, IAM, Secrets Manager
- `db2-architect` — Db2 schema design, stored procedures, zero-downtime migrations, query optimization
- `ibm-i-rpg` — Modern Free-Format RPG IV, ILE service programs, embedded SQL, CL commands, modernization path
- `zos-jcl` — z/OS JCL authoring, DD statements, condition codes, utilities (IEBGENER, IDCAMS), ABEND debugging
- `langchain-bob` — Use Bob as an ACP tool in LangChain/LangGraph multi-agent pipelines
- `code-review-workflow` — Structured PR reviews with systematic checklists and severity-rated findings

### Added — 5 More Skills
- `monorepo-architect` — Turborepo setup, workspace config, shared packages, remote caching
- `openapi-first` — OpenAPI 3.1 contract-first development, type generation, runtime validation
- `accessibility-auditor` — WCAG 2.1 AA audit, axe-core, keyboard navigation, ARIA patterns
- `feature-flag-workflow` — LaunchDarkly, trunk-based dev, flag lifecycle and cleanup
- `bob-rules-author` — Write actionable BOB.md rule files for workspace conventions

### Added — Infrastructure
- GitHub Actions CI workflow (ubuntu/macos/windows × node 18/20/22 matrix)
- GitHub Actions composite action (`uses: salmandev/everything-bob@v1`)
- `docs/ecc-vs-everything-bob.md` — detailed comparison against ECC and Everything Gemini
- `docs/index.html` — live interactive showcase page
- `.npmignore` — clean npm package
- Bumped to v1.1.0 with `files` field in package.json
