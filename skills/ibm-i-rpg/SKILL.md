---
name: ibm-i-rpg
description: >-
  Use when the user is working on IBM i (AS/400), writing RPG IV (RPGLE) or Free-format RPG programs, writing CL commands, working with ILE service programs, accessing DB2 for i, or modernizing legacy RPG code.
---

# IBM i RPG Development

Write modern Free-Format RPG IV (RPGLE) for IBM i with ILE best practices.

## Step 1 — Modern Free-Format RPG Structure
```rpgle
**FREE
// Modern RPGLE - always use **FREE at top, no column restrictions

Ctl-Opt DftActGrp(*No) ActGrp('MYGRP') Option(*SrcStmt:*NoDebugIO);

Dcl-Pi *N;
    pCustId  Packed(9:0) Const;
End-Pi;

Dcl-Ds CustomerDs Qualified;
    CustName  Char(50);
    Email     Char(100);
    Balance   Packed(11:2);
End-Ds;

Dcl-S wMessage Varchar(256);

// Main logic
Exec SQL
    SELECT CUST_NAME, EMAIL, BALANCE
    INTO :CustomerDs.CustName, :CustomerDs.Email, :CustomerDs.Balance
    FROM CUSTOMERS
    WHERE CUST_ID = :pCustId;

If SqlState = '00000';
    wMessage = 'Found: ' + %Trim(CustomerDs.CustName);
Else;
    wMessage = 'Customer not found: ' + %Char(pCustId);
EndIf;

*InLr = *On;
Return;
```

## Step 2 — Embedded SQL in RPGLE
```rpgle
**FREE
// Always use host variables with : prefix
Dcl-S custId  Packed(9:0);
Dcl-S custNm  Char(50);

custId = 12345;

Exec SQL
    SELECT CUST_NAME INTO :custNm
    FROM CUSTOMERS
    WHERE CUST_ID = :custId
    FETCH FIRST 1 ROW ONLY;

Select;
    When SqlState = '00000';
        // success
    When SqlState = '02000';
        // not found
    Other;
        // error — log SQLERRMC
EndSl;
```

## Step 3 — ILE Service Programs (Reusable Modules)
```rpgle
// Module: CUSTUTIL
**FREE
Ctl-Opt NoMain;

Dcl-Proc GetCustomerName Export;
    Dcl-Pi *N Char(50);
        pId Packed(9:0) Const;
    End-Pi;

    Dcl-S result Char(50);

    Exec SQL SELECT CUST_NAME INTO :result
             FROM CUSTOMERS WHERE CUST_ID = :pId;

    Return result;
End-Proc;
```

## Step 4 — CL Command Wrapper
```cl
PGM PARM(&CUSTID)
DCL VAR(&CUSTID) TYPE(*DEC) LEN(9 0)
DCL VAR(&MSG)    TYPE(*CHAR) LEN(100)

CALL PGM(CUSTUTIL) PARM(&CUSTID)
MONMSG MSGID(CPF0000) EXEC(DO)
    SNDPGMMSG MSG('Error processing customer') TOPGMQ(*EXT)
ENDDO

ENDPGM
```

## Step 5 — Compile and Deploy
```bash
# Via SSH to IBM i using PASE
system "CRTRPGMOD MODULE(MYLIB/CUSTUTIL) SRCFILE(MYLIB/QRPGLESRC) SRCMBR(CUSTUTIL) OPTION(*SRCSTMT)"
system "CRTSRVPGM SRVPGM(MYLIB/CUSTUTIL) MODULE(MYLIB/CUSTUTIL) EXPORT(*ALL)"
system "CRTPGM PGM(MYLIB/CUSTPGM) MODULE(MYLIB/CUSTPGM) BNDSRVPGM(MYLIB/CUSTUTIL)"
```

## Step 6 — Modernization Path
| Legacy Pattern | Modern Replacement |
| --- | --- |
| Fixed-format RPG (col 6-80) | Free-format `**FREE` |
| `CHAIN` opcode | Embedded SQL `SELECT INTO` |
| `EXFMT` subfile | Open Access Handler or web service |
| `*INLR = *ON` main | `Ctl-Opt NoMain` service programs |
| Hardcoded file names | `OVRDBF` or SQL aliases |

## Verification Checklist
- [ ] `Ctl-Opt DftActGrp(*No)` present (avoid default activation group)
- [ ] All SQL statements check `SQLSTATE` after execution
- [ ] No `GOTO` opcodes in new code
- [ ] ILE modules compiled with `OPTION(*SRCSTMT)` for debug
- [ ] Service programs exported only the procedures callers need
