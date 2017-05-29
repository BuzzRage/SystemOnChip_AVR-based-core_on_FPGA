----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity detection_tb is
end detection_tb;

architecture tb of detection_tb is

type T_etat is(idle,edge,one);
signal next_etat, reg_etat: T_etat;

component detection
  Port ( clk : in  STD_LOGIC;
	 rst : in  STD_LOGIC;
	 entree : in STD_LOGIC;
	 tc : out  STD_LOGIC);
end component;

for detect_tb: detection use entity work.detection;

-- Inputs
signal clk : std_logic := '0';
signal rst : std_logic :='0';
signal entree : std_logic :='1';
-- Outputs
signal tc : std_logic;
-- Clock period definitions
constant clk_period : time := 10 ns;

begin

	detect_tb: detection port map(clk=>clk,rst=>rst,entree=>entree,tc=>tc);
	
	-- Clock process definitions
	clk_process: process
	begin
		      clk <= '0';
		      wait for clk_period/2;
		      clk <= '1';
		      wait for clk_period/2;
	end process;
	
	-- Input process definitions
	input_process: process
	begin
		      entree <= '0';
		      wait for 2*clk_period;
		      entree <= '1';
		      wait for 2*clk_period;
	end process;	

	-- Stimulus process
	stim_proc: process
	begin		
	    rst <= '1' after 0 ns, '0' after 10 ns;
	    wait;
	end process;	
	      
	
end tb;
