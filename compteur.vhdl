----------------------------------------------------------------------------------
-- 
-- Date:    12:48:08 09/23/2016 
-- Module Name:  compteur - Behavioral 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity compteur is
	 Generic (Nbits: integer := 4; 
		  Nmax : integer := 9);
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR(Nbits-1 downto 0));
end compteur;

architecture Behavioral of compteur is
signal cpt: STD_LOGIC_VECTOR(Nbits-1 downto 0);
begin
    Q <= cpt;
    comptage: process(clk,reset)
    begin
	    if reset ='1' then
		    cpt <= (others => '0');
	    elsif rising_edge(clk) then
		    if cpt < Nmax then
			    cpt <= cpt + 1 ;
		    else 
			    cpt <= (others => '0');
		    end if;
	    end if;
    end process comptage;	
end Behavioral;

