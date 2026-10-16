---
name: zos-jcl
description: >-
  Use when the user is writing z/OS JCL, submitting batch jobs, configuring DD statements, using JCL procedures, working with VSAM datasets, debugging JCL errors, or automating z/OS batch workflows.
---

# z/OS JCL Authoring

Write correct, efficient JCL for z/OS batch job submission and automation.

## Step 1 — JCL Structure
Every JCL job has three required statement types:
```jcl
//MYJOB    JOB  (ACCT),'My Job Description',CLASS=A,
//             MSGCLASS=X,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//*
//* Step 1: Compile the program
//*
//COMPILE  EXEC PGM=IGYCRCTL,REGION=0M,
//             PARM='APOST,OBJECT,NODECK,LIST'
//STEPLIB  DD   DSN=SYS1.SIGYCOMP,DISP=SHR
//SYSIN    DD   DSN=MY.COBOL.SRC(MYPGM),DISP=SHR
//SYSLIN   DD   DSN=&&LOADSET,UNIT=SYSDA,
//             DISP=(NEW,PASS),SPACE=(TRK,(10,5))
//SYSPRINT DD   SYSOUT=*
//SYSUT1   DD   UNIT=SYSDA,SPACE=(TRK,(10,5))
//
//* Step 2: Link-edit
//
//LKED     EXEC PGM=IEWL,COND=(8,LT,COMPILE),REGION=0M
//SYSLIN   DD   DSN=&&LOADSET,DISP=(OLD,DELETE)
//SYSLMOD  DD   DSN=MY.LOADLIB(MYPGM),DISP=SHR
//SYSPRINT DD   SYSOUT=*
//SYSUT1   DD   UNIT=SYSDA,SPACE=(TRK,(10,5))
```

## Step 2 — DD Statement Patterns
```jcl
//* Existing dataset (read)
//INPUT    DD   DSN=MY.INPUT.FILE,DISP=SHR

//* New dataset (create and keep)
//OUTPUT   DD   DSN=MY.OUTPUT.FILE,
//             DISP=(NEW,CATLG,DELETE),
//             UNIT=SYSDA,
//             SPACE=(CYL,(5,2),RLSE),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=27920)

//* Temporary dataset (deleted at job end)
//TEMP     DD   DSN=&&TEMPFILE,
//             DISP=(NEW,PASS),
//             UNIT=SYSDA,
//             SPACE=(TRK,(5,2))

//* Inline data
//SYSIN    DD   *
  OPTION COPY
/*

//* SYSOUT
//SYSPRINT DD   SYSOUT=*
```

## Step 3 — Condition Code Checking
```jcl
//* Only run STEP2 if STEP1 completed with RC <= 4
//STEP2    EXEC PGM=MYPGM,COND=(4,LT,STEP1)

//* Run if ALL previous steps had RC = 0
//STEP3    EXEC PGM=MYPGM,COND=EVEN

//* Always run (e.g. cleanup step)
//CLEANUP  EXEC PGM=IDCAMS,COND=EVEN
```

## Step 4 — Common Utilities
```jcl
//* IEBGENER — copy a sequential file
//COPY     EXEC PGM=IEBGENER
//SYSUT1   DD   DSN=MY.INPUT,DISP=SHR
//SYSUT2   DD   DSN=MY.OUTPUT,DISP=(NEW,CATLG,DELETE),
//             UNIT=SYSDA,SPACE=(TRK,(5,2))
//SYSIN    DD   DUMMY
//SYSPRINT DD   SYSOUT=*

//* IDCAMS — VSAM catalog operations
//VSAM     EXEC PGM=IDCAMS
//SYSPRINT DD   SYSOUT=*
//SYSIN    DD   *
  DEFINE CLUSTER (NAME(MY.VSAM.CLUSTER) -
                  INDEXED -
                  KEYS(10 0) -
                  RECORDSIZE(100 200) -
                  TRACKS(5 2)) -
         DATA (NAME(MY.VSAM.DATA)) -
         INDEX (NAME(MY.VSAM.INDEX))
/*
```

## Step 5 — Debug JCL Errors
| ABEND Code | Meaning | Common Fix |
| --- | --- | --- |
| `S0C7` | Data exception (bad numeric data) | Check input data format |
| `S0C4` | Protection exception (bad address) | Check pointer initialization |
| `S322` | Time limit exceeded | Increase `TIME=` or fix infinite loop |
| `S806` | Program not found | Check `STEPLIB`/`JOBLIB` concatenation |
| `S913` | Authorization failure | Check dataset RACF permissions |

## Verification Checklist
- [ ] JOB card has `NOTIFY=&SYSUID` for completion messages
- [ ] All NEW datasets have `SPACE=` specified
- [ ] Condition code logic tested for all RC scenarios
- [ ] Temporary datasets use `&&` prefix and `PASS`/`DELETE` disposition
- [ ] `REGION=0M` on memory-intensive steps
