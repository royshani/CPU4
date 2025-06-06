library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;

entity top_tb is
end top_tb;

architecture rtb of top_tb is

    -- Constants
    constant n : integer := 8;
    constant pwm_n : integer := 16;
    constant HEX_num : integer := 7;
    constant ROWmax : integer := 39;

    -- Instruction memory type
    type mem is array (0 to ROWmax) of std_logic_vector(4 downto 0);
    signal Icache : mem := (
        "00000", "00001", "00010", "01000", "01001", "01010", "01000", "01001", "10000", "10001",
        "10001", "10000", "10001", "11000", "11001", "11010", "11011", "11100", "11101", "11110",
        "00000", "00001", "00010", "01000", "01001", "01010", "01000", "01001", "10000", "10001",
        "10001", "10000", "10001", "11000", "11001", "11010", "11011", "11100", "11101", "11110"
    );

    -- DUT Signals
    signal clk       : std_logic := '0';
    signal SW_i      : std_logic_vector(9 downto 0) := (others => '0');
    signal KEY0      : std_logic := '1';
    signal KEY1      : std_logic := '1';
    signal KEY2      : std_logic := '1';
    signal KEY3      : std_logic := '1';
    signal Pwm_out   : std_logic;
    signal HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : std_logic_vector(HEX_num-1 downto 0);
    signal LEDs      : std_logic_vector(9 downto 0);
 --   signal ALUout_o : std_logic_vector(7 downto 0);
    -- display alu results for simulation
    function alu_ref(x, y: std_logic_vector(7 downto 0); fn: std_logic_vector(4 downto 0)) return std_logic_vector is
            variable result: std_logic_vector(7 downto 0);
        begin
            case fn is
                when "00000" =>  -- ADD
                    result := x + y;
                when "00001" =>  -- SUB
                    result := x - y;
                when "00010" =>  -- AND
                    result := x and y;
                when "00011" =>  -- OR
                    result := x or y;
                when "00100" =>  -- XOR
                    result := x xor y;
                when others =>
                    result := (others => 'X');  -- Undefined
            end case;
            return result;
        end function;

begin

    -- Instantiate the DUT
    mapTop: top
        port map (
            clk      => clk,
            SW_i     => SW_i,
            KEY0     => KEY0,
            KEY1     => KEY1,
            KEY2     => KEY2,
            KEY3     => KEY3,
            Pwm_out  => Pwm_out,
            HEX0     => HEX0,
            HEX1     => HEX1,
            HEX2     => HEX2,
            HEX3     => HEX3,
            HEX4     => HEX4,
            HEX5     => HEX5,
  --          ALUout_o => ALUout_o,
            LEDs     => LEDs
        );

    -- Clock generation
    clk_gen : process
    begin
        while true loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
    end process;

    -- Test logic
    stimulus : process
    variable expected : std_logic_vector(7 downto 0);
    begin
        -- Initial values
        wait for 20 ns;

        -- Load Y = 0x12 (LSB) HEX2
        SW_i(9) <= '0';
        SW_i(7 downto 0) <= "00010010";  -- 0x12
        KEY0 <= '0'; wait for 10 ns; KEY0 <= '1';
        wait for 10 ns;  -- Wait before next key press

        -- Load Y = 0x34 (MSB) HEX3
        SW_i(9) <= '1';
        SW_i(7 downto 0) <= "00110100";  -- 0x34
        KEY0 <= '0'; wait for 10 ns; KEY0 <= '1';
        wait for 10 ns;

        -- Load X = 0x56 (LSB) HEX0
        SW_i(9) <= '0';
        SW_i(7 downto 0) <= "01010110";  -- 0x56
        KEY1 <= '0'; wait for 10 ns; KEY1 <= '1';
        wait for 10 ns;

        -- Load X = 0x78 (MSB) HEX1
        SW_i(9) <= '1';
        SW_i(7 downto 0) <= "01111000";  -- 0x78
        KEY1 <= '0'; wait for 10 ns; KEY1 <= '1';
        wait for 10 ns;

        -- Loop through ALUFN instructions
        for i in 0 to ROWmax loop
            -- Enable calculation
            SW_i(9) <= '0';
            SW_i(8) <= '1';

            -- Set ALUFN
            SW_i(4 downto 0) <= Icache(i);

            -- First KEY2 press
            KEY2 <= '0'; wait for 10 ns; KEY2 <= '1';
            wait for 50 ns;

            -- Optional: reassert ALUFN
            SW_i(4 downto 0) <= Icache(i);

            -- Second KEY2 press
            KEY2 <= '0'; wait for 10 ns; KEY2 <= '1';
            wait for 50 ns;

            -- Compute expected result
            expected := alu_ref("01111000", "00110100", Icache(i));
            wait for 50 ns;
        end loop;

        -- Reset at the end
        KEY3 <= '0'; wait for 10 ns; KEY3 <= '1';

        wait;
    end process;

end rtb;
