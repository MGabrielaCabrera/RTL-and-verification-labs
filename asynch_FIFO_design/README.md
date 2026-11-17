# Exercise: Asynchronous FIFO Design in SystemVerilog

## 1. Objective

Design and verify an Asynchronous FIFO in SystemVerilog to transfer data safely between two independent clock domains.

The FIFO must allow a producer operating in one clock domain to write data and a consumer operating in another clock domain to read data, without assuming any phase or frequency relationship between the two clocks.

The main goal is to implement a reliable CDC architecture using Gray-coded pointers and synchronizer registers.

## 2. Design Specifications

Implement a parameterizable asynchronous FIFO with the following parameters:

| Parameter | Description | Default |
|---|---|---|
| `DATA_WIDTH` | Data width in bits | 8 |
| `ADDR_WIDTH` | Address width (FIFO depth = 2^ADDR_WIDTH) | 4 |
| `DEPTH` | FIFO depth | 16 |

### Interface

| Signal | Direction | Description |
|---|---|---|
| `wr_clk` | Input | Write clock |
| `rd_clk` | Input | Read clock |
| `rst_n` | Input | Active-low reset |
| `wr_en` | Input | Write enable |
| `wr_data` | Input | Input data |
| `full` | Output | FIFO full flag |
| `rd_en` | Input | Read enable |
| `rd_data` | Output | Output data |
| `empty` | Output | FIFO empty flag |

## 3. Functional Requirements

### Write Logic
- Accept new data when `wr_en` is asserted and `full` is deasserted.
- Update the write pointer only after a successful write.
- Store data in the FIFO memory using the write clock.
- Prevent writes when the FIFO is full.

### Read Logic
- Read data when `rd_en` is asserted and `empty` is deasserted.
- Update the read pointer only after a successful read.
- Prevent reads when the FIFO is empty.

### Clock Domain Crossing
- Use binary pointers for memory addressing.
- Convert binary pointers to Gray code before synchronizing them across clock domains.
- Synchronize the Gray-coded write pointer into the read clock domain.
- Synchronize the Gray-coded read pointer into the write clock domain.
- Use two-stage synchronizer registers for each pointer crossing.

### Status Flags
- Generate the `empty` flag in the read clock domain.
- Generate the `full` flag in the write clock domain.
- Use synchronized pointers to determine FIFO status.

## 4. Implementation Constraints

1. Use separate `always_ff` blocks for write and read logic.
2. Use non-blocking assignments (`<=`) for sequential logic.
3. Use independent clocked processes for each clock domain.
4. Implement binary-to-Gray conversion using:

   `gray = binary ^ (binary >> 1)`

5. Implement Gray-to-binary conversion if needed.
6. Ensure pointer synchronizers are correctly reset.
7. Avoid directly synchronizing multi-bit binary pointers.
