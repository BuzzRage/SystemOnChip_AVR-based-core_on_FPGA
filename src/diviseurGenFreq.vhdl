----------------------------------------------------------------------------------
-- Cours:  UTT-SY23
-- Par: Jacques Mahoudeaux et Marius Letourneau 
-- 
-- Create Date:    12:06:41 09/30/2016 
-- Design Name: Diviseur de fréquence générique
-- Module Name:    diviseurGenFreq - Behavioral 
-- Project Name: System On Chip
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std;

entity diviseurGenFreq is
	 Generic (clkdiv: positive := 8); -- 26 pour 1Hz
	 Port ( clk : in  STD_LOGIC;
	     reset: in STD_LOGIC;
	     enable : in STD_LOGIC;
	     clk_out : out STD_LOGIC;
	     tc0 : out  STD_LOGIC;
	     tc1 : out  STD_LOGIC);
end diviseurGenFreq;

architecture Behavioral of diviseurGenFreq is

-- calcul du nombre de bits en fonction de la valeur maximale
function intlog2 (x : natural) return natural is
 variable temp : natural := x;
 variable n : natural := 0;
  begin
    while temp > 1 loop
        temp := temp / 2 ;
        n := n + 1 ;
    end loop;
    return n ;
  end function intlog2;
constant Nbits : natural := intlog2(clkdiv);
signal cpt: STD_LOGIC_VECTOR(Nbits-1 downto 0);

begin
comptage: Process(clk) 
	begin
		if reset ='1' then
			cpt <= (others => '0');
		elsif rising_edge(clk) and enable='1' then
			if cpt < clkdiv-1 then
				cpt <= cpt+1;
			else 
				cpt <= (others => '0') ;
			end if;
		end if;
	end process comptage;
		
sortie: process(cpt)
	begin
	    if cpt=clkdiv-1 then -- tc1 impulsion a N
		  tc1 <= '1';
	    else 
		  tc1 <= '0';
	    end if;
	    if cpt=(clkdiv-1)/2 then -- tc0 impulsion a N/2
		  tc0 <= '1';
	    else 
		  tc0 <= '0';
	    end if;		
	  if cpt >= 0 and cpt <= (clkdiv-1)/2 then -- clk0  = clk/N
	      clk_out <= '0';
	  else
	    clk_out <= '1';
	  end if;		
	end process sortie;
	
end Behavioral;

