LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
-------------------------------------
ENTITY ALU IS  -- Define the ALU entity
  GENERIC (
    n : INTEGER := 8;  -- Bit width of operands
    k : integer := 3;  -- Likely function code width for sub-modules
    m : integer := 4   -- Additional generic (not used in this code)
  ); 
  PORT (
    Y_i, X_i: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);  -- Operand inputs
    ALUFN_i : IN STD_LOGIC_VECTOR(4 DOWNTO 0);    -- ALU function selector (5-bit)
    ALUout_o: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0); -- ALU result output
    Nflag_o, Cflag_o, Zflag_o, Vflag_o: OUT STD_LOGIC  -- Flags: Negative, Carry, Zero, Overflow
  ); 
END ALU;

------------- complete the top Architecture code --------------
ARCHITECTURE struct OF ALU IS 

  -- Internal signal declarations for intermediate results
  SIGNAL ALUOUT, zeros, y_add, x_add, x_logic, y_logic, x_shifter, y_shifter : std_logic_vector(n-1 DOWNTO 0);
  SIGNAL res_adder, res_logic, res_shifter : std_logic_vector(n-1 DOWNTO 0);  -- Results of subcomponents
  SIGNAL cout_adder, cout_shifter : std_logic;  -- Carry-out flags for adder and shifter
  SIGNAL highz : std_logic_vector(n-1 DOWNTO 0) := (others => 'Z');  -- High impedance 
  SIGNAL ALUFN_ADDER, ALUFN_LOGIC, ALUFN_SHIFTER, ALUFN_TEMP : STD_LOGIC_VECTOR(2 DOWNTO 0);  -- Function selectors for submodules

BEGIN

  -- Extract lower 3 bits of ALUFN for submodules
  ALUFN_TEMP <= ALUFN_i(2 DOWNTO 0);

  -- All-zero vector for Z comparison and default output
  zeros <= (not X_i) and X_i;

  -- Multiplexing inputs and control based on ALUFN_i MSBs
  y_add <= Y_i when ALUFN_i(4 DOWNTO 3) = "01" else highz;
  x_add <= Y_i when ALUFN_i(4 DOWNTO 3) = "01" else highz;
  ALUFN_ADDER <= ALUFN_i(2 DOWNTO 0) when ALUFN_i(4 DOWNTO 3) = "01" else "ZZZ";

  y_logic <= Y_i when ALUFN_i(4 DOWNTO 3) = "11" else highz;
  x_logic <= Y_i when ALUFN_i(4 DOWNTO 3) = "11" else highz;
  ALUFN_LOGIC <= ALUFN_i(2 DOWNTO 0) when ALUFN_i(4 DOWNTO 3) = "11" else "ZZZ";

  y_shifter <= Y_i when ALUFN_i(4 DOWNTO 3) = "10" else highz;
  x_shifter <= Y_i when ALUFN_i(4 DOWNTO 3) = "10" else highz;
  ALUFN_SHIFTER <= ALUFN_i(2 DOWNTO 0) when ALUFN_i(4 DOWNTO 3) = "10" else "ZZZ";

  ---------------------------------------------------------------------------------------------------------

  -- Instantiate Adder/Subtractor module
  Adder : AdderSub generic map(n) 
         port map(ALUFN_TEMP, X_i, Y_i, cout_adder, res_adder);

  -- Instantiate Logic module
  logicpart : Logic generic map(n) 
         port map(X_i, Y_i, ALUFN_i(2 DOWNTO 0), res_logic);

  -- Instantiate Shifter module
  shifterpart : Shifter generic map(n) 
         port map(Y_i, X_i, ALUFN_i(2 DOWNTO 0), res_shifter, cout_shifter);

  ---------------------------------------------------------------------------------------------------------

  -- Mux final ALU output based on ALUFN category
  ALUOUT <= res_adder   when ALUFN_i(4 DOWNTO 3) = "01" else
            res_logic   when ALUFN_i(4 DOWNTO 3) = "11" else
            res_shifter when ALUFN_i(4 DOWNTO 3) = "10" else
            zeros;

  -- Zero flag: 1 if result equals zero vector
  Zflag_o <= '1' when ALUOUT = zeros else '0';

  -- Negative flag: copy MSB of result
  Nflag_o <= '1' when ALUOUT(n-1) = '1' else '0';

  -- Carry flag: from adder or shifter depending on operation type
  Cflag_o <= cout_adder  when ALUFN_i(4 DOWNTO 3) = "01" else
             cout_shifter when ALUFN_i(4 DOWNTO 3) = "10" else
             '0';

  -- Assign ALU result to output port
  ALUout_o <= ALUOUT;

  -- Overflow flag: calculated based on signed overflow rules for addition/subtraction
  Vflag_o <= ((X_i(n-1) and Y_i(n-1) and (not ALUOUT(n-1))) or 
              ((not X_i(n-1)) and (not Y_i(n-1)) and ALUOUT(n-1))) when ALUFN_i = "01000" else
             ((X_i(n-1) and (not Y_i(n-1)) and  ALUOUT(n-1)) or 
              ((not X_i(n-1)) and Y_i(n-1) and (not ALUOUT(n-1)))) when ALUFN_i = "01001" else
             '0';

END struct;