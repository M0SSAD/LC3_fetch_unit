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

- `npc`: Next program counter value. This may be the next sequential address or a branch target.
- `pc`: Program counter value used to read the next instruction.
- `rd`: Memory read request.

## 4. Verification Objectives

- `Reset loads the PC register`: Check that asserting reset causes `pc_reg` to load `'h3000` on the next rising edge.
- `PC advances during fetch`: Check that when `state == CNTRL_UPDATE_PC`, the PC increases by 1 each cycle.
- `Branch target selection`: Check that when `br_taken` is asserted and `state == CNTRL_UPDATE_PC`, the next PC comes from `taddr`.
- `PC rollover`: Check that incrementing `'hFFFF` wraps to `'h0000` on the next cycle.
- `PC holds when not updating`: Check that when `state != CNTRL_UPDATE_PC`, the PC remains unchanged.
- `Tri-state bus behavior`: Check that `pc` and `rd` are driven to `z` when memory is being used by other units.

## 5. Assumptions And Constraints

- The design is verified at the fetch-unit level with a program block testbench and clocking blocks.
- `ADDR_WIDTH` is treated as a project-wide default width for the current environment.
- The current RTL increments the PC by 1 on each update.
- `pc` and `rd` are allowed to go to `z` when memory is owned by another unit.
- `CNTRL_TEST` is treated as a non-update state where the PC must hold its value.

## 6. Expected Behavior

- After reset, the PC loads `'h3000` and `npc` reflects the next sequential address.
- When `state == CNTRL_UPDATE_PC` and `br_taken == 0`, the PC increments normally and `npc = pc + 1`.
- When `state == CNTRL_UPDATE_PC` and `br_taken == 1`, the PC loads `taddr` and `npc` becomes `taddr + 1`.
- When `state != CNTRL_UPDATE_PC`, the PC does not change.
- When the memory-busy states are active, `pc` and `rd` are tri-stated.
- The PC wraps from `'hFFFF` to `'h0000` on the next increment.

## 7. Test Scenarios

- Reset sequence and post-reset check.
- Normal PC increment check for more than one cycle.
- No-branch check with `br_taken == 0` and a non-default `taddr`.
- Branch-taken check with `taddr` selected as the next PC.
- Rollover check from `'hFFFF` to `'h0000`.
- Hold check while `state == CNTRL_TEST`.
- Tri-state check for `CNTRL_READ_MEMORY`, `CNTRL_IND_ADDR_RD`, and `CNTRL_WRITE_MEM`.

## 8. Notes

- The current testbench style is intentionally simple and readable for learning and debugging.
