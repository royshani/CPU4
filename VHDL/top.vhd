LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

------------------------------------------------------------
ENTITY top IS
  GENERIC (	HEX_num : integer := 7;
			n : INTEGER := 8;
			pwm_n: INTEGER := 16
			); 
  PORT (
		  clk  : in std_logic; -- for single tap
		  -- Switch Port
		  SW_i : in std_logic_vector(9 downto 0);
		  -- Keys Ports
		  KEY0, KEY1, KEY2, KEY3 : in std_logic;
		  Pwm_out : OUT std_logic;
		  -- 7 segment Ports
		  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector(HEX_num-1 downto 0);
		  -- Leds Port
		  LEDs: out std_logic_vector(9 downto 0)  
  );
END top;

-------------------------------------------------------------------------
ARCHITECTURE roman OF top IS 
	
	signal ALUout_o, X, Y : std_logic_vector(n-1 downto 0);
	signal X_pwm, Y_pwm :  std_logic_vector(pwm_n-1 downto 0);
	signal ref_clk, Nflag_o, Cflag_o, Zflag_o, Vflag_o, rst, ena: STD_LOGIC;
	signal ALUFN_i: std_logic_vector(4 downto 0);
	signal X_nibble0, X_nibble1 : std_logic_vector(3 downto 0);
	signal Y_nibble0, Y_nibble1 : std_logic_vector(3 downto 0);
	signal ALU_nibble0, ALU_nibble1 : std_logic_vector(3 downto 0);

	
BEGIN

	---------------------------------------------------------------------------------------------------------
	--process (clk)
    --begin
        --if (rst = '1') then
            --Nflag_o <= '0';
			--Vflag_o <= '0';
			--Zflag_o <= '0';
			--Cflag_o <= '0';
			--X <= "00000000";
			--Y <= "00000000";
			--ALUFN_i <= "00000";
            --Pwm_out <= '0';
        --elsif rising_edge(clk) then
            --if ena = '1' then
				
            --end if; 
       -- end if;
    --end process;
	
	clk_div_part : CounterEnvelope  port map(clk, ena, ref_clk);
	
	ALU_part : ALU generic map(n) port map( Y, X, ALUFN_i , ALUout_o, Nflag_o, Cflag_o, Zflag_o, Vflag_o);
	
	down_entity_part : down_entity generic map(pwm_n) port map( X_pwm, Y_pwm, ALUFN_i, Pwm_out, clk, rst, ena);
	
	---------------------------------------------------------------------------------------------------------
	---------------------7 Segment Decoder-----------------------------
	-- X display in HEX
	DecoderModuleXHex0: SevenSegDecoder port map(X_nibble0, HEX0);
	DecoderModuleXHex1: SevenSegDecoder port map(X_nibble1, HEX1);
	-- Y display in HEX
	DecoderModuleYHex2: SevenSegDecoder port map(Y_nibble0, HEX2);
	DecoderModuleYHex3: SevenSegDecoder port map(Y_nibble1, HEX3);
	-- ALU output display in HEX
	DecoderModuleOutHex4: SevenSegDecoder port map(ALU_nibble0, HEX4);
	DecoderModuleOutHex5: SevenSegDecoder port map(ALU_nibble1, HEX5);

	--------------------LEDS Binding-------------------------
	LEDs(0) <= Vflag_o;
	LEDs(1) <= Zflag_o;
	LEDs(2) <= Nflag_o;
	LEDs(3) <= Cflag_o;
	LEDs(9 downto 5) <= ALUFN_i;
	
	-------------------Keys Binding--------------------------
	registerAssignment: process(KEY0, KEY1, KEY2, SW_i(9)) 
	begin
	--	if rising_edge(clk) then
			if KEY0 = '0' and SW_i(9) = '0' then
				Y <= SW_i(n-1 downto 0);
				Y_pwm(7 downto 0) <= SW_i(n-1 downto 0);
			elsif KEY0 = '0' and SW_i(9) = '1' then
				Y_pwm(15 downto 8) <= SW_i(n-1 downto 0);
			elsif KEY1 = '0' and SW_i(9) = '0' then
				X <= SW_i(n-1 downto 0);
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
	--	end if;
	end process registerAssignment;
	
	NibbleSelector : process(SW_i, X, Y, ALUout_o)
	begin
		if SW_i(9) = '1' then
			X_nibble0 <= X(3 downto 0);
			X_nibble1 <= X(7 downto 4);

			Y_nibble0 <= Y(3 downto 0);
			Y_nibble1 <= Y(7 downto 4);

			ALU_nibble0 <= ALUout_o(3 downto 0);
			ALU_nibble1 <= ALUout_o(7 downto 4);
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