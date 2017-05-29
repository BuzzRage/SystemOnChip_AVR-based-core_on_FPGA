----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity main_machineEtat is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           entree : in  STD_LOGIC;
          -- tc : out  STD_LOGIC;
			  d : out std_logic_vector(3 downto 0));
end main_machineEtat;

architecture Behavioral of main_machineEtat is

component diviseurGenFreq is
	 Generic (Nbits: integer := 26); -- 26 pour 1Hz
    Port ( clk : in  STD_LOGIC;
			  reset: in STD_LOGIC;
           clk_lent : out  STD_LOGIC);
end component diviseurGenFreq;

component detection is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           entree : in  STD_LOGIC;
           tc : out  STD_LOGIC);
end component detection;

component compteur is
	 Generic (Nbits: integer := 4; 
				Nmax : integer := 9);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR(Nbits-1 downto 0));
end component;

signal clk_lent: std_logic;
signal sortie: std_logic;

begin

	detect: detection port map(clk=>clk,rst=>rst,entree=>entree,tc=>sortie);
	div:diviseurGenFreq 
			generic map(Nbits=>26)
			port map(clk=>clk,reset=>rst,clk_lent=>clk_lent);	
	cpt: compteur generic map (Nbits => 4, Nmax => 16)
		port map(clk => sortie, reset => rst,Q => d);				

end Behavioral;

