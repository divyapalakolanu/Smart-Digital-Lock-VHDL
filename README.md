# Smart Digital Lock System (VHDL)

Designed and implemented by Divya Palakolanu.

## 📌 Project Overview
This project presents a secure **Smart Digital Lock** system implemented using **VHDL** on the **Xilinx Artix-7 FPGA** (xc7a35tcpg236-1). The system utilizes a Finite State Machine (FSM) to handle multi-digit password validation, providing a high-security solution for digital access control.

### Key Features:
* **Password Validation:** Requires a specific sequence (**1-2-3**) to unlock.
* **Security Alarm:** Any incorrect entry immediately triggers a persistent Alarm state.
* **State Feedback:** Uses a 7-segment display decoder to show status: 
  * `L` for Locked (IDLE)
  * `U` for Unlocked
  * `A` for Alarm
* **Resource Optimization:** Extremely efficient design using minimal hardware resources.

---

## 🛠️ Technical Implementation

### 1. State Machine Logic
The heart of the design is a Moore Finite State Machine (FSM) consisting of five states: `IDLE`, `DIGIT1`, `DIGIT2`, `UNLOCKED`, and `ALARM`. The system only transitions forward when the correct `keypad_in` value is present during an `enter_btn` pulse.



### 2. I/O Pin Planning
Mapped via XDC constraints to interface with physical hardware:
* **Inputs:** `clk` (System Clock), `reset` (Master Reset), `keypad_in[3:0]` (4-bit password input), `enter_btn` (Submission button).
* **Outputs:** `lock_out` (LED), `alarm_out` (Security Siren/LED), `seg_out[6:0]` (7-Segment Cathodes).

---

## 🔍 Visual Evidence & Verification

### I. Behavioral Simulation (Verification)
The simulation verifies that the lock ignores incorrect sequences and only transitions to `lock_out = '1'` when the digits **1, 2, and 3** are entered in order. 
<img width="1919" height="1142" alt="Screenshot 2026-02-01 162625" src="https://github.com/user-attachments/assets/5fbff41f-7edb-4166-91ba-05b71f9f43d9" />


### II. Hardware Implementation Success
This screenshot confirms that the VHDL code has been successfully synthesized and implemented, and the bitstream has been generated without errors.
<img width="1919" height="1130" alt="Screenshot 2026-02-01 162858" src="https://github.com/user-attachments/assets/1c064d1c-f424-41fa-b6e6-c6a4eff87a65" />

### III. Resource Utilization Report
A summary of the hardware resources used. The design is highly optimized, requiring only:
* **Slice LUTs:** 7
* **Slice Registers:** 5
<img width="1919" height="1141" alt="Screenshot 2026-02-01 163014" src="https://github.com/user-attachments/assets/568120fb-9df4-4638-94d4-b3b3f9775217" />


### IV. Gate-Level Schematic
The physical mapping of the VHDL logic into hardware gates, showing the interconnection between inputs, logic cells, and outputs.
<img width="1919" height="1140" alt="Screenshot 2026-02-01 162403" src="https://github.com/user-attachments/assets/62bcf4ae-64bb-4830-86c7-bb8fa137581b" />


---

## 📁 File Structure
* `digital_lock_top.vhd`: The core VHDL source code containing the FSM logic and segment decoder.
* `tb_digital_lock.vhd`: The automated testbench used for functional verification.
* `pins.xdc`: The constraints file used for physical pin mapping on the Artix-7.

---

## 🚀 How to Run the Project
1. Open **Xilinx Vivado 2025.2**.
2. Create a new project targeting the **Artix-7 xc7a35tcpg236-1**.
3. Import the source files and constraints.
4. Run **Behavioral Simulation** to see the waveform results.
5. Run **Synthesis** and **Implementation**.
6. Generate the **Bitstream** to program the FPGA.

---
**Tools Used:** VHDL, Xilinx Vivado, Artix-7 FPGA.
