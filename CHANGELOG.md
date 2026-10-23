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

## [1.3.1] - 2026-10-22

### Updated by salmandev

#### `cve-mitigator` skill — Oct 21–22 2026 NVD-verified CVEs

Live-queried from `nvd.nist.gov` NVD API. All 18 CRITICAL + 86 HIGH CVEs for Oct 21–22 2026 reviewed;
highest-impact entries affecting widely-deployed software documented with exact version pins and fix commands.

**CVSS 10.0**
- `CVE-2026-83938` — Azure Kubernetes Configuration Service: unauthenticated privilege escalation (Microsoft-patched)
- `CVE-2026-97785` — Microsoft Entra App Proxy: improper auth → priv escalation (Microsoft-patched)

**CVSS 9.9**
- `CVE-2026-115375` / `CVE-2026-115377` — Incus path traversal + arbitrary file write (fix: 7.0.2+ / 7.5.0+)
- `CVE-2026-115384` — Wasmtime 39.0–48.0.3 stack buffer overflow via malicious WASM guest (fix: 48.0.4+ / 49.0.2+)

**CVSS 9.8 — PHP Runtime (affects ALL PHP apps)**
- `CVE-2026-109618` — longjmp() OOM leaves request memory uninitialized → UAF/potential RCE
- `CVE-2026-109619` — Global state not reset after request memory freed → memory corruption
  _Fix: upgrade PHP runtime via package manager or rebuild Docker base image_

**CVSS 8.8**
- `CVE-2026-114109` — uv < 0.11.15 path traversal via wheel entry points (fix: `uv self update`)
- `CVE-2026-114094/096/098` — dulwich < 1.2.9 arbitrary file write + path traversal (fix: `pip install -U dulwich`)
- `CVE-2026-114053` — vLLM 0.7.3–0.30.x RCE via client-controlled `code_revision` (fix: 0.31.0+)

**CVSS 8.1 cluster — Trigger.dev < 4.7.0 (self-hosted)**
- SQLi in ClickHouse TSQL compiler and ElectricSQL `tags` param
- Path traversal in packets endpoints, auth bypass, CSRF in CLI auth flow

**CVSS 7.5 / 7.4**
- `CVE-2026-114063` — SvelteKit 2.10.0–2.x Windows path traversal in vite preview (fix: 3.0.0+)
- `CVE-2026-89035` — MikroTik RouterOS ≤ 7.24.5 WebFig session token replay (fix: firmware upgrade)

Skill also adds Step 1: live NVD API query template so users can pull any date range on demand.

---

## [1.3.0] - 2025-10-18

### Added by salmandev

#### New Skill: `cve-mitigator`
- Cross-stack CVE triage and remediation skill covering **Node.js, PHP, Nginx, Java, Python, and Go**
- Curated CVE tables with exact affected versions and one-line fixes for the most impactful recent CVEs:
  - Node.js: `cross-spawn`, `nanoid`, `path-to-regexp`, `micromatch`, `optionator`
  - PHP: PHP-FPM RCE/log injection (8.1.31/8.2.26/8.3.14), glibc iconv buffer overflow
  - Nginx: `ngx_http_mp4_module` worker crash, TLS session ticket auth bypass
  - Java: Log4Shell, Text4Shell, Spring Framework path traversal (CVE-2024-38816/38819), Logback RCE
  - Python: `idna` DoS, `setuptools` RCE, `requests` credential leak
  - Go: `govulncheck` integration
- Universal scanner step using **Grype** (multi-ecosystem: images, filesystems, SBOMs, lock files)
- Structured finding report template (CVE ID, CVSS, affected version, fix, status)
- Post-fix verification checklist

#### New Mode: `bob-cve-responder`
- Dedicated CVE triage and remediation mode
- Runs only audit tools (npm audit, composer audit, govulncheck, OWASP Dependency-Check)
- Structured CVE finding reports with CVSS score and concrete one-line fix per finding
- Re-runs audit tool after fix to confirm remediation

#### Enhanced: `security-audit` skill
- Expanded Step 4 to cover PHP (composer audit), Java (OWASP dependency-check), Go (govulncheck), and Grype
- Added Step 4b: Recent CVE spot-checks with quick single-command version checks for Node, Java, PHP, Nginx

---

## [1.2.0] - 2025-10-17

### Added by salmandev

#### 9 New Skills (44 → 53)
- `bob-context-manager` — Checkpoint files, task state management, context compression across long sessions
- `observability-engineer` — Structured logging (Pino/structlog), OpenTelemetry tracing, Prometheus metrics, SLO alerts
- `prisma-architect` — Prisma schema design, migrations, N+1 prevention, production singleton pattern
- `react-native-architect` — Expo Router, Zustand + AsyncStorage, FlatList performance, native module patterns
- `websocket-realtime` — Socket.io server/client, SSE, Redis adapter for multi-instance scaling
- `oauth2-oidc-flows` — PKCE flow, JWT validation with JWKS, client credentials, token storage security
- `error-boundary-patterns` — React error boundaries, react-error-boundary, Sentry integration, Result type
- `watsonx-assistant` — IBM watsonx Assistant REST API, webhook actions, web chat embed, session management
- `ibm-event-streams` — IBM Event Streams (Kafka), KafkaJS producer/consumer, topic design, dead-letter pattern

#### Infrastructure
- New hook: `test-guardian` — Stop hook that blocks Bob from stopping if tests fail or TypeScript has errors
- New modes: `bob-ibm-cloud-engineer`, `bob-pair-programmer` (7 modes total)
- New agent: `documentation-writer` (9 agents total)
- New plugin: `ibm` — IBM platform rules (IBM Cloud security, watsonx, Event Streams, Db2) + watsonx-quick-start skill
- CLI enhanced: full `diff`, `export`, `update` commands + `--workspace` flag
- CONTRIBUTORS.md added crediting salmandev
- All commits by salmandev
