Components
1. Top
Generics:

n: Width of the input and output signals (default is 8).
Ports:

x, y: Input signals (STD_LOGIC_VECTOR of width n).
clk, rst, ena: Control signals (STD_LOGIC).
ALUFN_i: Operation control signal (STD_LOGIC_VECTOR of width 5).
ALUout_o: Output signal (STD_LOGIC_VECTOR of width n).
Nflag_o, Cflag_o, Zflag_o, Vflag_o, Pwm_out: Output flags (STD_LOGIC).
Description:
This component serves as the top-level module, integrating various submodules and managing the overall operation.

2. FA (Full Adder)
Ports:

xi, yi, cin: Input signals (STD_LOGIC).
s, cout: Output signals (STD_LOGIC).
Description:
Performs a single-bit addition operation, outputting the sum (s) and carry-out (cout).

3. Shifter
Generics:

n: Width of the input and output signals (default is 8).
k: Number of shift control bits (default is 3).
Ports:

Y, X: Input signals (STD_LOGIC_VECTOR of width n).
dir: Direction control signal (STD_LOGIC_VECTOR of width 3).
res: Output signal (STD_LOGIC_VECTOR of width n).
cout: Carry-out signal (STD_LOGIC).
Description:
Performs bitwise shifting operations on the input signal X, producing the shifted result res.

4. Logic
Generics:

n: Width of the input and output signals (default is 8).
Ports:

x, y: Input signals (STD_LOGIC_VECTOR of width n).
fn: Function control signal (STD_LOGIC_VECTOR of width 3).
res: Output signal (STD_LOGIC_VECTOR of width n).
Description:
Executes various logical operations (e.g., AND, OR, XOR) based on the fn control signal.

5. AdderSub
Generics:

n: Width of the input and output signals (default is 8).
Ports:

sub_cont: Subtraction control signal (STD_LOGIC_VECTOR of width 3).
x, y: Input signals (STD_LOGIC_VECTOR of width n).
cout: Carry-out signal (STD_LOGIC).
res: Output signal (STD_LOGIC_VECTOR of width n).
Description:
Performs addition or subtraction based on the sub_cont control signal, outputting the result res and carry-out cout.

6. Pwm
Generics:

n: Width of the input signals (default is 8).
Ports:

x, y: Input signals (STD_LOGIC_VECTOR of width n).
fn, rst, clk, ena: Control signals (STD_LOGIC).
pwm_out: PWM output signal (STD_LOGIC).
Description:
Generates a Pulse Width Modulation (PWM) signal based on the input signals and control signals.

7. Down_Entity
Generics:

n: Width of the input and output signals (default is 8).
Ports:

x, y: Input signals (STD_LOGIC_VECTOR of width n).
ALUFN_i: Operation control signal (STD_LOGIC_VECTOR of width 5).
pwm_o: PWM output signal (STD_LOGIC).
clk, rst, ena: Control signals (STD_LOGIC).
Description:
Performs operations and outputs a PWM signal based on the input and control signals.

8. ALU
Generics:

n: Width of the input and output signals (default is 8).
k: Number of shift control bits (default is 3).
m: Additional parameter (default is 4).
Ports:

Y_i, X_i: Input signals (STD_LOGIC_VECTOR of width n).
ALUFN_i: Operation control signal (STD_LOGIC_VECTOR of width 5).
ALUout_o: Output signal (STD_LOGIC_VECTOR of width n).
Nflag_o, Cflag_o, Zflag_o, Vflag_o: Output flags (STD_LOGIC).
Description:
Performs arithmetic and logical operations, outputting the result and status flags.

9. SevenSegDecoder
Generics:

n: Width of the input signal (default is 4).
SegmentSize: Number of segments in the display (default is 7).
Ports:

data: Input signal (STD_LOGIC_VECTOR of width n).
seg: Output signal (STD_LOGIC_VECTOR of width SegmentSize).
Description:
Decodes the input data to drive a seven-segment display.

10. PLL
Ports:

areset: Asynchronous reset signal (STD_LOGIC).
inclk0: Input clock signal (STD_LOGIC).
c0: Output clock signal (STD_LOGIC).
locked: Lock status signal (STD_LOGIC).
Description:
Phase-Locked Loop component for clock management.

11. Counter
Ports:

clk, enable: Control signals (STD_LOGIC).
q: Output signal (STD_LOGIC).
Description:
Simple counter component, incrementing the output q based on the clock and enable signals.

12. Clk_Div
Ports:

clk, ena, rst: Control signals (STD_LOGIC).
q: Output signal (STD_LOGIC).
Description:
Clock divider component, dividing the input clock signal and outputting the result.

13. CounterEnvelope
Ports:

Clk, En: Control signals (STD_LOGIC).
Qout: Output signal (STD_LOGIC).
Description:
Counter component, producing an output Qout based on the clock and enable signals.