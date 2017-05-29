----------------------------------------------------------------------------------
-- 
-- Date:    13:12:25 17 novembre 2016
-- Module Name:  diviseurProg_tb - tb 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.diviseurProg;


entity diviseurProg_tb is
end diviseurProg_tb;

architecture tb of diviseurProg_tb is
  component diviseurProg
    Generic(N : integer := 16);
    Port ( clkdiv : in std_logic_vector(N-1 downto 0);
	   phase : in std_logic;
	   polarite : in std_logic;
	   rst : in std_logic;
	   clk : in  std_logic;
	   clk_out : out std_logic;
           tc : out  std_logic);
  end component;

  for u_diviseurProg_tb: diviseurProg use entity work.diviseurProg;

  -- Constants
  constant N : integer := 16;
  -- Inputs
  signal clkdiv : std_logic_vector(N-1 downto 0) := X"0008";
  signal phase : std_logic := '0';
  signal polarite : std_logic := '0';  
  signal rst : std_logic := '0'; 
  signal clk : std_logic := '0';  
  -- Outputs  
  signal clk_out : std_logic;
  signal tc : std_logic;
  -- Clock period definitions
  constant clk_period : time := 10 ns;

  begin
	  u_diviseurProg_tb: diviseurProg generic map(N => N)
	  port map(clkdiv=>clkdiv,phase=>phase,polarite=>polarite,rst=>rst,clk=>clk,clk_out=>clk_out,tc=>tc);
	  
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
	      rst <= '1' after 0 ns, '0' after 10 ns;
	      polarite <= '0' after 0 ns, '1' after 500 ns;
	      phase <= '0' after 0 ns, '1' after 250 ns,'0' after 500 ns,'1' after 750 ns;	      
	      wait;
	  end process;	
end tb;
