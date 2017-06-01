--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:05:40 11/23/2016
-- Design Name:   
-- Module Name:   /home/uvs/xilinx/avrtiny861/microcontroleur_tb.vhd
-- Project Name:  avrtiny861
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: microcontroleur
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
 
ENTITY microcontroleur_tb IS
END microcontroleur_tb;
 
ARCHITECTURE behavior OF microcontroleur_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT microcontroleur
    PORT(
         clk : IN  std_logic;
         Rst : IN  std_logic;
			  --PORTA : inout STD_LOGIC_VECTOR (7 downto 0);
			  LED : out STD_LOGIC_VECTOR (3 downto 0);
			  BTN : in STD_LOGIC_VECTOR (3 downto 0);
         PORTB : INOUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal Rst : std_logic := '0';

	--BiDirs
  --signal PORTA : STD_LOGIC_VECTOR (7 downto 0);
   signal LED : STD_LOGIC_VECTOR (3 downto 0);
   signal BTN : STD_LOGIC_VECTOR (3 downto 0);
   signal PORTB : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: microcontroleur PORT MAP (
          clk => clk,
          Rst => Rst,
          --PORTA => PORTA,
			 LED => LED,
			 BTN => BTN,
          PORTB => PORTB
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
	
		Rst <= '0';
		wait for 100 ns;
		Rst <= '1';
		wait for 100 ns;
		Rst <= '0';
		wait for 1850 ns;
		BTN <= "0001" after 50 ns, "0010" after 100 ns, "0100" after 150 ns;
      wait;
   end process;

END;
