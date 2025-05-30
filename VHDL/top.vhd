LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;

------------------------------------------------------------
ENTITY top IS
  GENERIC (
    HEX_num : integer := 7;
    n       : INTEGER := 8;
    pwm_n   : INTEGER := 16
  ); 
  PORT (
    clk       : in  std_logic;
    SW_i      : in  std_logic_vector(9 downto 0);
    KEY0, KEY1, KEY2, KEY3 : in  std_logic;
    Pwm_out   : out std_logic;
    HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out std_logic_vector(HEX_num-1 downto 0);
    LEDs      : out std_logic_vector(9 downto 0)
  );
END top;

------------------------------------------------------------
ARCHITECTURE roman OF top IS
	
  signal ALUout_o : std_logic_vector(n-1 downto 0);
  signal X_pwm, Y_pwm : std_logic_vector(pwm_n-1 downto 0);
  signal ref_clk, Nflag_o, Cflag_o, Zflag_o, Vflag_o : std_logic;
  signal rst, ena : std_logic := '0';
  signal ALUFN_i : std_logic_vector(4 downto 0);
  signal X_nibble0, X_nibble1 : std_logic_vector(3 downto 0);
  signal Y_nibble0, Y_nibble1 : std_logic_vector(3 downto 0);
  signal ALU_nibble0, ALU_nibble1 : std_logic_vector(3 downto 0);
  signal X_reg, Y_reg, ALU_result_reg : std_logic_vector(n-1 downto 0);

BEGIN

  clk_div_part : CounterEnvelope port map(clk, ena, ref_clk);

  ALU_part : ALU
    generic map(n)
    port map( 
      Y_i => Y_reg,
      X_i => X_reg,
      ALUFN_i => ALUFN_i,
      ALUout_o => ALUout_o,
      Nflag_o => Nflag_o,
      Cflag_o => Cflag_o,
      Zflag_o => Zflag_o,
      Vflag_o => Vflag_o
    );

  down_entity_part : down_entity
    generic map(pwm_n)
    port map(X_pwm, Y_pwm, ALUFN_i, Pwm_out, clk, rst, ena);

  --------------------- 7 Segment Decoder -----------------------------
  DecoderModuleXHex0: SevenSegDecoder port map(X_nibble0, HEX0);
  DecoderModuleXHex1: SevenSegDecoder port map(X_nibble1, HEX1);
  DecoderModuleYHex2: SevenSegDecoder port map(Y_nibble0, HEX2);
  DecoderModuleYHex3: SevenSegDecoder port map(Y_nibble1, HEX3);
  DecoderModuleOutHex4: SevenSegDecoder port map(ALU_result_reg(3 downto 0), HEX4);
  DecoderModuleOutHex5: SevenSegDecoder port map(ALU_result_reg(7 downto 4), HEX5);

  -------------------- LEDs Binding -------------------------
  LEDs(0) <= Vflag_o;
  LEDs(1) <= Zflag_o;
  LEDs(2) <= Nflag_o;
  LEDs(3) <= Cflag_o;
  LEDs(9 downto 5) <= ALUFN_i;

  ------------------- Keys Binding --------------------------
  registerAssignment : process(clk)
  begin
    if rising_edge(clk) then
      if KEY0 = '0' and SW_i(9) = '0' then
        Y_reg <= SW_i(n-1 downto 0);
        Y_pwm(7 downto 0) <= SW_i(n-1 downto 0);
      elsif KEY0 = '0' and SW_i(9) = '1' then
        Y_pwm(15 downto 8) <= SW_i(n-1 downto 0);
      elsif KEY1 = '0' and SW_i(9) = '0' then
        X_reg <= SW_i(n-1 downto 0);
        X_pwm(7 downto 0) <= SW_i(n-1 downto 0);
      elsif KEY1 = '0' and SW_i(9) = '1' then
        X_pwm(15 downto 8) <= SW_i(n-1 downto 0);
      elsif KEY2 = '0' then
        ALUFN_i <= SW_i(4 downto 0);
      elsif KEY3 = '0' then
        rst <= '1';
      elsif SW_i(8) = '1' then
        ena <= '1';
      end if;

      -- Register ALU result on clock edge
      ALU_result_reg <= ALUout_o;
    end if;
  end process registerAssignment;

  ------------------ Nibble Selector for HEX display ------------------
  NibbleSelector : process(SW_i, X_reg, Y_reg, ALU_result_reg)
  begin
    if SW_i(9) = '1' then
      X_nibble0 <= X_reg(3 downto 0);
      X_nibble1 <= X_reg(7 downto 4);
      Y_nibble0 <= Y_reg(3 downto 0);
      Y_nibble1 <= Y_reg(7 downto 4);
      ALU_nibble0 <= ALU_result_reg(3 downto 0);
      ALU_nibble1 <= ALU_result_reg(7 downto 4);
    else
      X_nibble0 <= "1111";
      X_nibble1 <= "1111";
      Y_nibble0 <= "1111";
      Y_nibble1 <= "1111";
      ALU_nibble0 <= "1111";
      ALU_nibble1 <= "1111";
    end if;
  end process NibbleSelector;

END roman;
