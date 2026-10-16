---
name: db2-architect
description: >-
  Use when the user is working with IBM Db2, writing Db2 SQL, designing Db2 schemas, optimizing Db2 queries, writing Db2 stored procedures, configuring Db2 on Cloud, or migrating from another database to Db2.
---

# Db2 Architect

Design and optimize IBM Db2 schemas, queries, and stored procedures with enterprise patterns.

## Step 1 — Db2 Schema Design Essentials
```sql
-- Create table with Db2-native types
CREATE TABLE ORDERS (
    ORDER_ID    BIGINT          NOT NULL GENERATED ALWAYS AS IDENTITY,
    CUSTOMER_ID BIGINT          NOT NULL,
    STATUS      VARCHAR(20)     NOT NULL DEFAULT 'PENDING',
    AMOUNT      DECIMAL(15, 2)  NOT NULL,
    CREATED_AT  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT  TIMESTAMP,
    CONSTRAINT PK_ORDERS PRIMARY KEY (ORDER_ID),
    CONSTRAINT FK_ORDERS_CUSTOMER FOREIGN KEY (CUSTOMER_ID)
        REFERENCES CUSTOMERS(CUSTOMER_ID) ON DELETE RESTRICT,
    CONSTRAINT CHK_STATUS CHECK (STATUS IN ('PENDING','CONFIRMED','SHIPPED','CANCELLED'))
) IN USERSPACE1;

-- Add index for common query patterns
CREATE INDEX IDX_ORDERS_CUSTOMER_STATUS
    ON ORDERS (CUSTOMER_ID, STATUS)
    INCLUDE (AMOUNT, CREATED_AT);
```

## Step 2 — Query Optimization with EXPLAIN
```sql
-- Always EXPLAIN before deploying a slow query
EXPLAIN PLAN FOR
SELECT O.ORDER_ID, C.EMAIL, O.AMOUNT
FROM ORDERS O
JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
WHERE O.STATUS = 'PENDING'
  AND O.CREATED_AT > CURRENT_TIMESTAMP - 7 DAYS;

-- View the access plan
SELECT * FROM EXPLAIN_STATEMENT;

-- Check for table scans (bad) vs index scans (good)
SELECT TABNAME, SCANTYPE FROM EXPLAIN_SCAN;
```

## Step 3 — Stored Procedures
```sql
CREATE OR REPLACE PROCEDURE UPDATE_ORDER_STATUS(
    IN  P_ORDER_ID  BIGINT,
    IN  P_STATUS    VARCHAR(20),
    OUT P_ROWS_UPDATED INT
)
LANGUAGE SQL
BEGIN
    UPDATE ORDERS
    SET STATUS = P_STATUS,
        UPDATED_AT = CURRENT_TIMESTAMP
    WHERE ORDER_ID = P_ORDER_ID;

    GET DIAGNOSTICS P_ROWS_UPDATED = ROW_COUNT;

    IF P_ROWS_UPDATED = 0 THEN
        SIGNAL SQLSTATE '02000'
            SET MESSAGE_TEXT = 'Order not found';
    END IF;
END;
```

## Step 4 — Zero-Downtime Schema Changes
Unlike PostgreSQL, Db2 locks tables during some DDL. Use these safe patterns:

```sql
-- SAFE: Add nullable column (no lock on Db2 11.5+)
ALTER TABLE ORDERS ADD COLUMN NOTES VARCHAR(500);

-- SAFE: Add index online (non-blocking)
CREATE INDEX IDX_ORDERS_NOTES ON ORDERS (NOTES) NOT LOGGED INITIALLY;

-- UNSAFE on large tables: avoid
-- ALTER TABLE ORDERS ALTER COLUMN AMOUNT SET DATA TYPE DECIMAL(18,2); -- full reorg needed
-- Use a new column + backfill + rename approach instead
```

## Step 5 — Connect from Node.js / Python
```bash
# Node.js
npm install ibm_db

# Python
pip install ibm_db ibm_db_sa  # ibm_db_sa for SQLAlchemy support
```

```python
import ibm_db

conn = ibm_db.connect(
    f"DATABASE={os.environ['DB2_DATABASE']};"
    f"HOSTNAME={os.environ['DB2_HOSTNAME']};"
    f"PORT=50000;PROTOCOL=TCPIP;"
    f"UID={os.environ['DB2_USER']};"
    f"PWD={os.environ['DB2_PASSWORD']};",
    "", ""
)
stmt = ibm_db.exec_immediate(conn, "SELECT COUNT(*) FROM ORDERS")
row = ibm_db.fetch_tuple(stmt)
print(row[0])
```

## Step 6 — Db2 on Cloud (IBM Cloud managed Db2)
```bash
ibmcloud resource service-instance-create my-db2 dashdb-for-transactions 100 us-south
ibmcloud resource service-key-create my-db2-key Manager --instance-name my-db2
ibmcloud resource service-key my-db2-key  # shows connection credentials
```

## Verification Checklist
- [ ] All queries have EXPLAIN plans reviewed for table scans
- [ ] Indexes exist for all foreign keys and common WHERE predicates
- [ ] Stored procedures use proper SQLSTATE error signaling
- [ ] DDL changes tested on dev with REORGCHK: `CALL SYSPROC.REORGCHK_TB_STATS('T', 'SCHEMA.TABLE')`
- [ ] Connection strings use environment variables, not hardcoded credentials
