----------------------------------------------------------------------------------
-- 
-- Date:    23:24:43 17 novembre 2016
-- Module Name:  diviseurGenFreq_tb - tb 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.diviseurGenFreq;

entity diviseurGenFreq_tb is
end diviseurGenFreq_tb;

architecture tb of diviseurGenFreq_tb is
  component diviseurGenFreq
    Generic (clkdiv: positive := 8);
    Port ( clk : in  std_logic;
	   reset: in STD_LOGIC;
	   enable : in STD_LOGIC;
	   clk_out : out STD_LOGIC;	   
	   tc0 : out  STD_LOGIC;
	   tc1 : out  STD_LOGIC);
  end component;
  for u_diviseurGenFreq_tb: diviseurGenFreq use entity work.diviseurGenFreq;
  
  -- Constants
  constant clkdiv : positive := 8;  
  -- Inputs
  signal clk : std_logic := '0';
  signal reset : std_logic := '0';  
  signal enable : std_logic;  
  -- Outputs  
  signal clk_out : std_logic;  
  signal tc0 : std_logic;
  signal tc1 : std_logic;  
  -- Clock period definitions
  constant clk_period : time := 10 ns;

  begin
	  u_diviseurGenFreq_tb: diviseurGenFreq generic map(clkdiv=>clkdiv)
	  port map(clk=>clk,reset=>reset,enable=>enable,
		   clk_out=>clk_out,tc0=>tc0,tc1=>tc1);
	  
	  -- Clock process definitions
	  clk_process: process
	  begin
			clk <= '0';
			wait for clk_period/2;
			clk <= '1';
			wait for clk_period/2;
	  end process;

	  -- Stimulus process
	  stim_proc: process
	  begin		
	      reset <= '1' after 0 ns, '0' after 10 ns;
	      enable <= '1' after 20 ns, '0' after 1000 ns;	      
	      wait;
	  end process;	
	
end tb;
