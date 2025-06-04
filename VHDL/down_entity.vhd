LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all; 
-------------------------------------
ENTITY down_entity IS
GENERIC (n : INTEGER := 16); -- Generic parameter 'n' for data width, defaults to 16
PORT 
(x, y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0); -- Input data vectors x and y
ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0); -- ALU Function input for control
pwm_o: out STD_LOGIC; -- PWM output signal
clk, rst, ena: in STD_LOGIC -- Clock, reset, and enable signals
); 
END down_entity;
------------- completeArchitecture code --------------
ARCHITECTURE struct OF down_entity IS 

SIGNAL y_pwm, x_pwm : std_logic_vector(n-1 DOWNTO 0); -- Internal signals for PWM inputs
SIGNAL highz : std_logic_vector(n-1 DOWNTO 0) := (others => 'Z'); -- High-impedance signal for tri-state
SIGNAL pwm_mode : STD_LOGIC_VECTOR (2 DOWNTO 0); -- Internal signal for PWM mode selection

BEGIN
-- Assign y to y_pwm if ALUFN_i bits 4 and 3 are "00", otherwise assign high-impedance
y_pwm <= y when ALUFN_i(4 DOWNTO 3) = "00" else highz;
-- Assign x to x_pwm if ALUFN_i bits 4 and 3 are "00", otherwise assign high-impedance
x_pwm <= x when ALUFN_i(4 DOWNTO 3) = "00" else highz;
-- Assign ALUFN_i bits 2 down to 0 to pwm_mode if ALUFN_i bits 4 and 3 are "00", otherwise assign high-impedance
pwm_mode <= ALUFN_i (2 DOWNTO 0) when  ALUFN_i(4 DOWNTO 3) = "00" else (others => 'Z');
 
---------------------------------------------------------------------------------------------------------
-- Instantiate the Pwm component
pwm_part : Pwm
generic map (
n => n -- Map the generic 'n' from down_entity to Pwm
)
port map (
x => x_pwm, -- Connect x_pwm to the Pwm component's x input
y => y_pwm, -- Connect y_pwm to the Pwm component's y input
rst => rst,  -- Connect reset signal
clk => clk, -- Connect clock signal
ena => ena,-- Connect enable signal
fn => pwm_mode, -- Connect pwm_mode to the Pwm component's fn input
pwm_out => pwm_o -- Connect the Pwm component's pwm_out to the entity's pwm_o
);
 ---------------------------------------------------------------------------------------------------------
END struct;