library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity spi_read is
	Generic(N : integer := 8);
	Port ( clk : in STD_LOGIC;
		rst : in STD_LOGIC;
	        spi_start : in std_logic;
		spi_miso : in std_logic;
		data_out : out std_logic_vector(N-1 downto 0);
		spi_cs : out std_logic;
		spi_sck : out std_logic);
end spi_read;

architecture arch_spi_read of spi_read is
	
component diviseurGenFreq is
	Generic(clkdiv : positive := 8);
    Port ( clk : in  STD_LOGIC;
    	   reset : in STD_LOGIC;
    	   enable : in STD_LOGIC;
	  clk_out : out STD_LOGIC;
           tc0 : out  STD_LOGIC;
           tc1 : out  STD_LOGIC);
end component;

component compteur is
	Generic(Nbits : integer := 4; 
		Nmax : integer := 9);
	Port ( clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		Q : out STD_LOGIC_VECTOR(Nbits-1 downto 0));
end component;   

type T_etat is (idle,bitsdata);

signal next_etat,reg_etat : T_etat;
signal next_spi_cs : std_logic;
signal next_data_out : std_logic_vector(N-1 downto 0);
signal next_spi_sck : std_logic;
signal data_cnt_en : std_logic;
signal data_cnt : std_logic_vector(7 downto 0);
signal spi_cs_tmp : std_logic;
signal data_out_tmp : std_logic_vector(N-1 downto 0);
signal spi_sck_tmp : std_logic;

begin

div_spi_read : diviseurGenFreq port map (
	clk => clk,
	reset => rst,
	clk_out => spi_sck_tmp
);

compt_spi : compteur generic map ( Nbits => 8, Nmax => N )
	port map (
	  clk => clk,
	  reset => data_cnt_en,
	  Q => data_cnt
); 

registre_etat: process(clk)
begin
if rising_edge(clk) then
	if rst = '1' then
		reg_etat <= idle;
	else
		reg_etat <= next_etat;
	end if;
end if;
end process registre_etat;

reception: process(clk)
begin
if rst = '1' then
		spi_cs_tmp <= '1';
		data_out_tmp <= (others => '0');
elsif rising_edge(clk) then
		spi_cs_tmp <= next_spi_cs;
		data_out_tmp <= next_data_out;
end if;

end process reception;

spi_cs <= spi_cs_tmp;
data_out <= data_out_tmp;
spi_sck <= spi_sck_tmp when spi_cs_tmp='0' else '0'; --on doit transmettre directement l'horloge (pas de gestion d'état)
etat_suivant: process(reg_etat,spi_start,clk)
begin
case reg_etat is
	when idle=>
		if spi_start='1' then
			next_etat<=bitsdata;
		end if;
		next_spi_cs <= '1';
		next_data_out <= (others => '0');
		data_cnt_en <= '1';
	when bitsdata =>
		if data_cnt=conv_std_logic_vector(N-1,8) then
			next_etat <= idle;
		else
			if spi_sck_tmp='1' then
				next_data_out <= spi_miso & data_out_tmp(N-1 downto 1);
			end if;
		end if;
		next_spi_cs <= '0';
		data_cnt_en <= '0';
end case;

end process etat_suivant;

end arch_spi_read;
