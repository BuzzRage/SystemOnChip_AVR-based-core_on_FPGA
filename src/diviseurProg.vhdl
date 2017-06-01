library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity diviseurProg is
    Generic(N : integer := 16);
    Port ( clkdiv : in std_logic_vector(N-1 downto 0);
	   phase : in std_logic;
	   polarite : in std_logic;
	   rst : in std_logic;
	   clk : in  std_logic;
	   clk_out : out std_logic;
           tc : out  std_logic);
end diviseurProg;

architecture Behavioral of diviseurProg is
signal cpt1 : std_logic_vector(N-1 downto 0);
signal cpt2 : std_logic_vector(N-1 downto 0);
signal cpt : std_logic_vector(N-1 downto 0);
signal half_clkdiv : std_logic_vector(N-1 downto 0);
begin
 half_clkdiv <= '0' & clkdiv(N-1 downto 1); -- Division par deux par décalage à droite

cpt_phase0: process(clk)
 begin
	if rst='1' then
		cpt1 <= (others => '0');
	elsif (rising_edge(clk) and phase='0') then
		if cpt1 < clkdiv-1 then
			cpt1 <= cpt1 + 1;
		else
			cpt1 <= (others => '0');
		end if;
	end if;
end process cpt_phase0;

cpt_phase1: process(clk)
 begin
	if rst='1' then
		cpt2 <= (others => '0');
	elsif (falling_edge(clk) and phase='1') then
		if cpt2 < clkdiv-1 then
			cpt2 <= cpt2 + 1;
		else
			cpt2 <= (others => '0');
		end if;
	end if;
	
end process cpt_phase1;

with phase select
	cpt <= cpt1 when '0',
	       cpt2 when '1',
	       cpt1 when others;
   
sortie:process(cpt)
begin
	if cpt=clkdiv-1 then
		tc<='1';
	else
		tc<='0';
	end if;
	--if clkdiv=std_logic_vector(N-2 downto 0)&'1' then --pq quel cas ?
	--	clk_out <= clk xor polarite;
	if cpt < half_clkdiv then 	
	    clk_out <= '0' xor polarite; 
	else
	    clk_out <= '1' xor polarite; 
	end if;
end process sortie;
end Behavioral;

