# Single-Stage Pipeline Register with Valid-Ready Handshake

## 1. Problem Statement

Design a single-stage pipeline register using SystemVerilog that follows the
valid-ready handshake protocol.

The module should:
- Accept input data only when `in_valid` and `in_ready` are asserted
- Hold data until the downstream asserts `out_ready`
- Support backpressure without data loss
- Be fully synthesizable
- Reset to an empty state

This design models a common hardware pipeline buffer used in RTL designs
such as AXI-stream style interfaces.

---

## 2. Module Overview

The module implements a **1-deep pipeline register** with flow control.

### Key Features
- One data storage register
- Valid flag to track occupancy
- Backpressure handling
- No combinational loops
- Clean reset behavior

### Interface Signals

| Signal | Direction | Description |
|------|----------|-------------|
| `clk` | Input | Clock |
| `rst_n` | Input | Active-low reset |
| `in_valid` | Input | Input data valid |
| `in_ready` | Output | Ready to accept data |
| `in_data` | Input | Input data |
| `out_valid` | Output | Output data valid |
| `out_ready` | Input | Downstream ready |
| `out_data` | Output | Output data |

### Handshake Rule
- Data transfer occurs when:
