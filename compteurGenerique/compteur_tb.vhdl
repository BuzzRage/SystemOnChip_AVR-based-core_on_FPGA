----------------------------------------------------------------------------------
-- 
-- Date:    12:48:08 09/23/2016 
-- Module Name:  compteur_tb - tb 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.compteur;


entity compteur_tb is
end compteur_tb;

architecture tb of compteur_tb is
  component compteur
    Generic (Nbits: integer := 4; 
	    Nmax : integer := 9);
    Port ( clk : in  STD_LOGIC;
	  reset : in  STD_LOGIC;
	  Q : out  STD_LOGIC_VECTOR(Nbits-1 downto 0));
  end component;

  for cpt_tb: compteur use entity work.compteur;

  -- Constants
  constant Nbits_tb : integer := 4;
  constant Nmax_tb : integer := 9;
  -- Inputs
  signal clk : std_logic := '0';
  signal reset : std_logic :='0';  
  -- Outputs  
  signal Q : std_logic_vector(Nbits_tb-1 downto 0);
  -- Clock period definitions
  constant clk_period : time := 10 ns;

  begin

	  cpt_tb: compteur generic map(Nbits => Nbits_tb, Nmax => Nmax_tb)
	  port map(clk=>clk,reset=>reset,Q=>Q);
	  
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
	      wait;
	  end process;	
	
end tb;
