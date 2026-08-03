# LC3 Fetch Unit Verification Plan

## 1. Purpose

This document defines the verification strategy for the LC3 fetch unit.

## 2. DUT Overview

The fetch unit is responsible for computing the next instruction address and supplying the control signals needed to fetch the next instruction from memory.

## 3. Interface Summary

### Inputs

- `taddr`: Branch target address.
- `br_taken`: Indicates whether a branch is being taken.
- `reset`: Active reset signal.
- `clock`: Synchronous clock.
- `state`: Fetch-state indicator. The design uses `state` to distinguish fetch behavior from other memory-control states.

### Outputs

- `npc`: Next program counter value. This may be `PC + 4` or a branch target.
- `pc`: Program counter value used to read the next instruction.
- `rd`: Memory read request.

## 4. Verification Objectives


## 5. Assumptions And Constraints

## 6. Expected Behavior


## 7. Test Scenarios


## 8. Coverage Plan


## 9. Checkers And Scoreboard

## 10. Exit Criteria


## 11. Open Items



## 12. Notes
