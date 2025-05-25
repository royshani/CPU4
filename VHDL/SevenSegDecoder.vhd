library ieee;
use    ieee.std_logic_1164.all;

entity SevenSegDecoder is
  generic (
    n           : integer := 4;
    SegmentSize : integer := 7
  );
  port (
    data : in  std_logic_vector(n-1 downto 0);
    seg  : out std_logic_vector(SegmentSize-1 downto 0)
  );
end entity SevenSegDecoder;

architecture dfl of SevenSegDecoder is
begin
  process(data)
  begin
    if data = "0000" then
      seg <= "1000000";  -- 0
    elsif data = "0001" then
      seg <= "1111001";  -- 1
    elsif data = "0010" then
      seg <= "0100100";  -- 2
    elsif data = "0011" then
      seg <= "0110000";  -- 3
    elsif data = "0100" then
      seg <= "0011001";  -- 4
    elsif data = "0101" then
      seg <= "0010010";  -- 5
    elsif data = "0110" then
      seg <= "0000010";  -- 6
    elsif data = "0111" then
      seg <= "1111000";  -- 7
    elsif data = "1000" then
      seg <= "0000000";  -- 8
    elsif data = "1001" then
      seg <= "0010000";  -- 9
    elsif data = "1010" then
      seg <= "0001000";  -- A
    elsif data = "1011" then
      seg <= "0000011";  -- B
    elsif data = "1100" then
      seg <= "1000110";  -- C
    elsif data = "1101" then
      seg <= "0100001";  -- D
    elsif data = "1110" then
      seg <= "0000110";  -- E
    elsif data = "1111" then
      seg <= "0001110";  -- F
    else
      seg <= "1111111";  -- blank
    end if;
  end process;
end architecture dfl;
