# IBM Platform Engineering Rules

## 1. IBM Cloud Security Standards
1. **No hardcoded IBM Cloud credentials**: All API keys, CRNs, and service credentials must be stored in IBM Secrets Manager or environment variables.
2. **Image scanning before deployment**: Every container image must pass `ibmcloud cr va` (Vulnerability Advisor) with no critical findings before being deployed to Code Engine or IKS.
3. **IAM least-privilege**: Service IDs must have only the permissions required for their specific function. No `Administrator` roles in production without documented justification.
4. **Audit logging enabled**: IBM Cloud Activity Tracker must be configured for all production environments.

## 2. watsonx.ai Rules
1. **Model ID from environment**: Never hardcode watsonx.ai model IDs — use `WATSONX_MODEL_ID` environment variable to allow model swapping without code changes.
2. **Token budgeting**: Always set `MAX_NEW_TOKENS` and log actual token usage per call. Never send unbounded requests.
3. **Prompt injection defense**: User-provided input must be sanitized and clearly delimited from system instructions in all prompts.
4. **Pydantic validation on output**: All LLM-generated structured data must be validated with Pydantic before use in downstream logic.

## 3. IBM Event Streams (Kafka) Rules
1. **Version consumer group IDs**: Always suffix consumer group IDs with a version (`my-consumer-v1`). This allows safe offset resets during deployments.
2. **Manual commit after processing**: Never use auto-commit. Commit offsets only after successful message processing to prevent message loss.
3. **Dead-letter topics**: Every consumer must have a dead-letter topic for poison pill messages that fail repeatedly.
4. **Entity ID as message key**: Use entity IDs (order ID, user ID) as Kafka message keys to guarantee ordering within a partition.

## 4. Db2 Rules
1. **Parameterized queries only**: Never concatenate SQL strings. Use parameterized queries or a query builder.
2. **REORGCHK before production DDL**: Run `CALL SYSPROC.REORGCHK_TB_STATS` before any major DDL on production tables.
3. **EXPLAIN before deployment**: All new queries must have EXPLAIN plans reviewed for table scans before deploying to production.
