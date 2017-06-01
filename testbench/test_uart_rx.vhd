--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:33:48 11/14/2016
-- Design Name:   
-- Module Name:   /home/uvs/xilinx/UART_RX/test_uart_rx.vhd
-- Project Name:  UART_RX
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: uart_rx
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
 
ENTITY test_uart_rx IS
END test_uart_rx;
 
ARCHITECTURE behavior OF test_uart_rx IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uart_rx
	 Generic ( Nbits : integer := 16);
    Port ( clk_div : in  STD_LOGIC_VECTOR (Nbits-1 downto 0);
         RX : IN  std_logic;
         rst : IN  std_logic;
         clk : IN  std_logic;
         rx_done : OUT  std_logic;
         data : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    
	constant Nbits : integer := 16;
   --Inputs
   signal clk_div : std_logic_vector(Nbits-1 downto 0) := "0000000000000010"; -- := (others => '0');
   signal RX : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal rx_done : std_logic;
   signal data : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uart_rx PORT MAP (
          clk_div => clk_div,
          RX => RX,
          rst => rst,
          clk => clk,
          rx_done => rx_done,
          data => data
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
      rst <= '1';
      wait for clk_period;	
		rst <= '0';
		wait for 100 ns;
		RX <= '0';
		wait for clk_period*32;		
		RX <= '1';
		wait for clk_period*32;
		RX <= '0';
		wait for clk_period*32;
		RX <= '1';
		wait for clk_period*32;
		RX <= '0';
		wait for clk_period*32;
		RX <= '1';
		wait for clk_period*32;
		RX <= '1';
		wait for clk_period*32;
		RX <= '0';
		wait for clk_period*32;
		RX <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
