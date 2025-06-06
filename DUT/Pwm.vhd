library IEEE;
use    IEEE.std_logic_1164.all;
use    IEEE.std_logic_arith.all;
use    IEEE.std_logic_unsigned.all;
use    work.aux_package.all;

entity Pwm is
  generic ( n : integer := 16 );
  port (
    x, y     : in  std_logic_vector(n-1 downto 0);
    rst, clk,
    ena       : in  std_logic;
    fn        : in  std_logic_vector(2 downto 0);
    pwm_out   : out std_logic
  );
end entity Pwm;

architecture Hord of Pwm is
  signal q_int   : std_logic_vector(n-1 downto 0) := (others => '0');
  signal pwm_reg : std_logic := '0';
begin

  -- drive the output from the internal register
  pwm_out <= pwm_reg;

  process(clk, rst)
  begin
    if rst = '1' then
      -- asynchronous reset
      q_int   <= (others => '0');
      if fn = "000" then
        pwm_reg <= '0';
      else
        pwm_reg <= '1';
      end if;

    elsif rising_edge(clk) then
      if ena = '1' then
        -- free-running counter
        q_int <= q_int + 1;

        -- PWM modes
        if fn = "000" then
          if q_int > x then
            pwm_reg <= '1';
          else
            pwm_reg <= '0';
          end if;

        elsif fn = "001" then
          if q_int > x then
            pwm_reg <= '0';
          else
            pwm_reg <= '1';
          end if;

        elsif fn = "010" then
          if q_int = x then
            pwm_reg <= not pwm_reg;
          else
            pwm_reg <= pwm_reg;
          end if;

        else
          -- other fn codes: hold last value
          pwm_reg <= pwm_reg;
        end if;

        -- counter wrap-around
        if q_int = y then
          q_int <= (others => '0');
        end if;
      end if;
    end if;
  end process;

end architecture Hord;
