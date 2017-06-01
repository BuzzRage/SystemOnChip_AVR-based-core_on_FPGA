----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:57:18 11/01/2016 
-- Design Name: 
-- Module Name:    uart_rx - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std;


entity uart_rx is
	 Generic ( Nbits : integer := 16);
    Port ( clk_div : in  STD_LOGIC_VECTOR (Nbits-1 downto 0);
           RX : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rx_done : out  STD_LOGIC;
           data : out  STD_LOGIC_VECTOR (7 downto 0));
end uart_rx;

architecture Behavioral of uart_rx is
component diviseurProg is
		 Generic(N : integer := Nbits);
		 Port ( clkdiv : in std_logic_vector(N-1 downto 0);
			phase : in std_logic;
			polarite : in std_logic;
			rst : in std_logic;
			clk : in  std_logic;
			clk_out : out std_logic;
				  tc : out  std_logic);
end component diviseurProg;

type T_etat is(idle,bitstart,bitdata,bitstop);
signal next_etat, reg_etat : T_etat;
signal rxdata,rxdata_next : std_logic_vector(7 downto 0);
signal rxclk,rstrxclk,rxsamplerst,rxsample,rxhalfsample,rxfull,rxfull_next : std_logic;
signal bitcpt,bitcpt_next : std_logic_vector(2 downto 0);

begin
	cirxdiv : diviseurProg generic map (N => 16)
				 port map(clk=>clk,clkdiv=>clk_div,phase => '0', polarite => '0',rst=>rstrxclk,clk_out=>rxclk);
	cirxsample : entity work.diviseurGenFreq
				generic map( clkdiv => 16)
				port map( clk => clk,
							 reset => rxsamplerst,
							 enable => rxclk,
							 tc => rxsample,
							 halftc => rxhalfsample);
							 
	registre_etat_clk : process(clk,rst,rxfull)
	begin
		if rst = '1' then 
			reg_etat <= idle;
			rxfull <= '0';
			bitcpt <= (others => '0');
		elsif rising_edge(clk) then
			reg_etat <= next_etat;
			bitcpt <= bitcpt_next;
			rxdata <= rxdata_next;
			rxfull <= rxfull_next;
		end if;
	end process registre_etat_clk;

	etat_suivant : process(rst,reg_etat,rxclk,bitcpt,rxdata,
								  RX,rxhalfsample, rxsample, rxfull)
	begin
		rxfull_next <= rxfull;
		next_etat <= reg_etat;
		rxdata_next <= rxdata;
		bitcpt_next <= bitcpt;
		rstrxclk <= '0';
		rxsamplerst <= '0';
		case reg_etat is
			when idle =>
				rxsamplerst <= '1';
				rstrxclk <= '1';
				if RX = '0' then
					next_etat <= bitstart;
				end if;
			when bitstart =>
				rxfull_next <= '0';
				if rxclk = '1' then
					if rxhalfsample = '1' then
						next_etat <= bitdata;
						rxsamplerst <= '1';
						bitcpt_next <= (others => '0');
					end if;
				end if;
			when bitdata =>
				rxfull_next <= '0';	
				if rxclk = '1' then
					if rxsample = '1' then
						rxdata_next <= RX & rxdata(7 downto 1);
						if bitcpt = "111" then
							next_etat <= bitstop;
						else 
							bitcpt_next <= bitcpt + 1;
						end if;
					end if;
				end if;					
			when bitstop =>
					if rxclk = '1' then
						if rxsample = '1' then
							rxfull_next <= '1';
							next_etat <= idle;
						end if;
					end if;
		end case;
	end process etat_suivant;
	
	rx_done <= rxfull;
	
	rxregistre : process(clk,reg_etat)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				data <= (others => '0');	
			elsif reg_etat = bitstop then
				data <= rxdata;
			end if;
		end if;
	end process rxregistre;
	
end Behavioral;

