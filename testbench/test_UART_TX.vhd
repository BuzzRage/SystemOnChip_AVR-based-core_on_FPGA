--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:32:25 11/01/2016
-- Design Name:   
-- Module Name:   /home/uvs/xilinx/TP4/test_UART_TX.vhd
-- Project Name:  TP4
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UART_TX
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_UART_TX IS
END test_UART_TX;
 
ARCHITECTURE behavior OF test_UART_TX IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UART_TX
    PORT(
         clk_div : IN  std_logic_vector(27 downto 0);
         data : IN  std_logic_vector(7 downto 0);
         start : IN  std_logic;
         rst : IN  std_logic;
         clk : IN  std_logic;
         TX : OUT  std_logic;
         empty : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_div : std_logic_vector(27 downto 0) := (others => '0');
   signal data : std_logic_vector(7 downto 0) := X"35";
   signal start : std_logic := '1';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
	
 	--Outputs
   signal TX : std_logic;
   signal empty : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
	-- Instantiate the Unit Under Test (UUT)
   uut: UART_TX PORT MAP (
          clk_div => clk_div,
          data => data,
          start => start,
          rst => rst,
          clk => clk,
          TX => TX,
          empty => empty
        );

   -- Clock process definitions 
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      --wait for 100 ns;	
	clk_div<=X"0001458"; -- valeur pour avoir 9600Hz pour la transmission série
      -- insert stimulus here 

      wait;
   end process;

END;
