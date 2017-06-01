----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:44:50 10/07/2016 
-- Design Name: 
-- Module Name:    UART_TX - Behavioral 
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART_TX is
	 Generic ( Nbits : integer := 28); -- valeur pour le diviseur de fréquence
    Port ( clk_div : in  STD_LOGIC_VECTOR(Nbits-1 downto 0);
           data : in  STD_LOGIC_VECTOR (3 downto 0); -- par concaténation
			  --data : in  STD_LOGIC_VECTOR (7 downto 0);
           start : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           TX : out  STD_LOGIC;
           empty : out  STD_LOGIC);
end UART_TX;

architecture Behavioral of UART_TX is

component diviseurProg is
	 generic ( N: integer := Nbits);
    Port ( clk : in  STD_LOGIC;
           diviseur : in  STD_LOGIC_VECTOR(Nbits-1 downto 0);
           reset : in  STD_LOGIC;
           clk_lent : out  STD_LOGIC);
end component diviseurProg;

type T_etat is(idle,bitstart,bitdata,bitstop);

signal next_etat, reg_etat : T_etat;
signal txclk, txrst : std_logic;  -- txrst est là pour remettre à 0 le diviseur 
											 -- (et synchroniser le "start") 
											 -- pour éviter erreur sur premier bit
signal txdata, txdata_next : std_logic_vector(7 downto 0);
signal bitcpt,bitcpt_next : std_logic_vector(2 downto 0);

begin

-- pour la transmission série, il faut diviser la fréquence de clk par 5208 (clk_div vaut 0x1458)
div: diviseurProg port map(clk=>clk,diviseur=>X"0001458",reset=>txrst,clk_lent=>txclk); --A FINIR

registre_etat : process(clk,rst)
begin
if rising_edge(clk) then
		if rst = '1' then 
			reg_etat <= idle;
			txdata <= X"ff";
			bitcpt <= (others => '0');
		else
			reg_etat <= next_etat;
			bitcpt <= bitcpt_next;
			txdata <= txdata_next;
		end if;
end if;
end process registre_etat;

etat_suivant : process(start,reg_etat,txclk,bitcpt,data,txdata)
begin
	TX <= '1';
	empty <= '1';
	next_etat <= reg_etat;
	txdata_next <= txdata;
	bitcpt_next <= bitcpt;
	txrst <= '1';
	case reg_etat is
		when idle =>
			bitcpt_next <= "000";
			txrst <= '1';
			if start = '1' then
				txdata_next<= X"3" & data; -- par concaténation
				--txdata_next<= data;
				next_etat <= bitstart;
			end if;
		when bitstart =>
			TX <= '0';
			empty <= '0';
			txrst <= '0';
			if txclk = '1' then
				next_etat <= bitdata;
			end if;
		when bitdata =>
			--TX <= data(bitcpt); -- faire décalage
			empty <= '0';		
			txrst <= '0';
			TX<=txdata(0);
			if txclk = '1' then
				txdata_next <= '0' & txdata(7 downto 1);
				if bitcpt = "111" then
					next_etat <= bitstop;
				else 
					bitcpt_next <= bitcpt + 1;
				end if;
			end if;
		when bitstop =>
				TX <= '1';
				empty <= '0';
				txrst <= '0';
				if txclk = '1' then
					next_etat <= idle;
				end if;
	end case;
end process etat_suivant;

	


end Behavioral;
