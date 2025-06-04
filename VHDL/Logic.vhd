LIBRARY ieee; 
USE ieee.std_logic_1164.all; 
--------------------------------------------------------
ENTITY logic IS  
	GENERIC (n : INTEGER := 8);  -- default 8 bits
	PORT (
        x, y: IN std_logic_vector (n-1 downto 0);  -- Input vectors x and y, each n bits wide
		fn : IN std_logic_vector (2 downto 0);     -- 3-bit function selector input
		res : OUT std_logic_vector (n-1 downto 0)   -- Output vector res, n bits wide
    );
END logic;
--------------------------------------------------------
ARCHITECTURE dataflow1 OF logic IS  

signal zeros : std_logic_vector(n-1 DOWNTO 0);  -- Internal signal initialized to all 0s, same width as x and y

BEGIN
	zeros <= (not X) and X;  -- Set all bits to '0' using logical identity: X AND (NOT X) = 0

	-- Select result based on fn code:
	res <= not y when fn = "000" else       -- Bitwise NOT of y
	       y or x when fn = "001" else      -- Bitwise OR of y and x
		   y and x when fn = "010" else     -- Bitwise AND of y and x
		   y xor x when fn = "011" else     -- Bitwise XOR of y and x
		   y nor x when fn = "100" else     -- Bitwise NOR (not (y or x))
		   y nand x when fn = "101" else    -- Bitwise NAND (not (y and x))
		   y xnor x when fn = "111" else    -- Bitwise XNOR of y and x
		   zeros;                           -- Default case: output all zeros
end dataflow1;  
