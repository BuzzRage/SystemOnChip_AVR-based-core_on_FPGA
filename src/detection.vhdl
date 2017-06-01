----------------------------------------------------------------------------------
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity detection is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           entree : in  STD_LOGIC;
           tc : out  STD_LOGIC);
end detection;

architecture Behavioral of detection is

type T_etat is(idle,edge,one);
signal next_etat, reg_etat: T_etat;


begin

	registre_etat: process(clk)
	begin
		if rising_edge(clk) then
			if rst='1' then
				reg_etat <= idle;
			else
				reg_etat <= next_etat;
			end if;
		end if;
	end process registre_etat;
	
	tc<='1' when reg_etat = edge else '0';
	
	etat_suivant: process(reg_etat,entree)
	begin
		next_etat <= reg_etat;
		case reg_etat is
			when idle =>	
				if entree = '1' then
					next_etat <= edge;
				end if;								
			when edge =>
				next_etat <= one;
			when one =>
				if entree='0' then
					next_etat <= idle;
				end if;
		end case;
	end process etat_suivant;
	
end Behavioral;

