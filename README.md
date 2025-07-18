# 16-bit ALU (Arithmetic Logic Unit) — Verilog Implementation

## Description
This project implements a **16-bit Arithmetic Logic Unit (ALU)** in Verilog. The ALU supports arithmetic, logic, shift, and comparison operations using modular design, including:

- A 4-bit ALU block
- Carry Lookahead Generator
- 16-bit Multiplier
- 16-bit Comparator
- Modular and hierarchical integration

The project also includes testbenches and is synthesized using **Yosys** with logic optimization.

---

## Features

- **16-bit Arithmetic & Logic Operations**
- Modular Design with reusable 4-bit ALU units
- **Carry Lookahead Adder** for fast addition
- Integrated **Comparator** and **Multiplier**
- **Synthesis with Optimization** using Yosys + ABC
- Comprehensive testbench with 100% pass rate (200 tests)

---

## File Structure

| File | Description |
|------|-------------|
| `alu_4bit.v` | 4-bit ALU block |
| `carry_look_ahead_generator.v` | Fast carry generator |
| `comparator_16bit.v` | 16-bit comparator block |
| `multiplier_16bit.v` | Unsigned 16-bit multiplier |
| `alu_16bit.v` | Top-level ALU module |
| `test16bit.v` | Testbench covering all opcodes |
| `alu_16bit_opt.v` | Synthesized & optimized Verilog |
| `netlist.json` / `.blif` | Gate-level netlist (optional) |

---

## 🧪 Testbench Results

- ✅ **200 Test Cases Passed**
- Testbench checks arithmetic, logic, comparison, and multiplication operations.
- Output and intermediate flags are verified.

---

##  Synthesis Instructions

### 1. Synthesize using Yosys

```bash
yosys -p "
  read_verilog alu_16bit.v alu_4bit.v comparator_4bit.v multiplier_16bit.v carry_look_ahead_generator.v;
  hierarchy -top alu_16bit;
  synth;
  opt;
  abc;
  write_verilog alu_16bit_opt.v;
"
