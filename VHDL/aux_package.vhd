library IEEE;
use ieee.std_logic_1164.all;

package aux_package is
--------------------------------------------------------
component top IS
  GENERIC (n : INTEGER := 8); 
  PORT 
  (  
	x, y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
	clk, rst, ena : IN STD_LOGIC;
		  ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  ALUout_o: out STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o,Cflag_o,Zflag_o,Vflag_o, Pwm_out: OUT STD_LOGIC
  ); 
end component top;
---------------------------------------------------------  
	component FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	end component FA;
---------------------------------------------------------	
	component shifter is 
	GENERIC (
        n : INTEGER := 8;
        k : INTEGER := 3
   			 );
	port ( Y, X : in STD_LOGIC_VECTOR (n-1 downto 0);
			dir : in STD_LOGIC_VECTOR (2 downto 0);
			res : out STD_LOGIC_VECTOR (n-1 downto 0);
			cout : out STD_LOGIC
			);
	end component shifter;
-------------------------------------------------------------

component logic IS
	GENERIC (n : INTEGER := 8);
	PORT (x, y: IN std_logic_vector (n-1 downto 0);
			fn : IN std_logic_vector (2 downto 0);
			  res : OUT std_logic_vector (n-1 downto 0));
END component logic;	
	
------------------------------------------------------------

component AdderSub IS
  GENERIC (n : INTEGER := 8);
  PORT (     sub_cont: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			 x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
            cout: OUT STD_LOGIC;
               res: OUT STD_LOGIC_VECTOR(n-1 downto 0));
END component AdderSub;	

---------------------------------------------------------------

component Pwm IS
	GENERIC (n : INTEGER := 16);
	PORT (x, y: IN std_logic_vector (n-1 downto 0);
			rst, clk, ena : IN std_logic;
			fn :IN STD_LOGIC_VECTOR(2 downto 0);
			  pwm_out : OUT std_logic);
END component Pwm;

---------------------------------------------------------------

component down_entity IS
  GENERIC (n : INTEGER := 16); 
  PORT 
  (  
	x, y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  pwm_o: out STD_LOGIC;
		  clk, rst, ena: in STD_LOGIC
  ); 
END component down_entity;

-------------------------------------------------------------

component ALU IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   
		   m : integer := 4	); 
  PORT 
  (  
	Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		  ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		  ALUout_o: out STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC
  ); 
end component ALU;

-------------------------------------------------------------

COMPONENT SevenSegDecoder IS
  GENERIC (	n			: INTEGER := 4;
			SegmentSize	: integer := 7);
  PORT (data		: in STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		seg   		: out STD_LOGIC_VECTOR (SegmentSize-1 downto 0));
END COMPONENT SevenSegDecoder;

------------------------------------------------------------

COMPONENT PLL IS
	PORT
	(
		areset		: IN STD_LOGIC  := '0';
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		locked		: OUT STD_LOGIC 
	);
END COMPONENT PLL;

------------------------------------------------------------

COMPONENT counter is port (
	clk,enable : in std_logic;	
	q          : out std_logic
);
end COMPONENT counter;

------------------------------------------------------------

COMPONENT clk_div IS
  PORT (
		  clk, ena, rst  : in std_logic; -- for single tap
		  -- Switch Port
		  q: out std_logic  
  );
end COMPONENT clk_div;

-------------------------------------------------------------

COMPONENT CounterEnvelope is port (
	Clk,En : in std_logic;	
	Qout          : out std_logic); 
end COMPONENT CounterEnvelope;

end aux_package;

