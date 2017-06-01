----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:38:52 08/26/2014 
-- Design Name: 
-- Module Name:    ioport - ioport_architecture 
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

entity ioport is
	 Generic (BASEA	: integer := 16#19#;
				 BASEB	: integer := 16#16#
	 );
    Port ( clk : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (5 downto 0);
           ioread : out  STD_LOGIC_VECTOR (7 downto 0);
           iowrite : in  STD_LOGIC_VECTOR (7 downto 0);
           rd : in  STD_LOGIC;
           wr : in  STD_LOGIC;			  
			  inport : in  STD_LOGIC_VECTOR (7 downto 0);
           outport :	out  STD_LOGIC_VECTOR (7 downto 0));
end ioport;

architecture ioport_architecture of ioport is

constant PORTA	: integer := BASEA+2;
constant DDRA	: integer := BASEA+1;
constant PORTB	: integer := BASEB+2;
constant DDRB	: integer := BASEB+1;	

signal regddra : STD_LOGIC_VECTOR(7 downto 0);		
signal regddrb : STD_LOGIC_VECTOR(7 downto 0);
signal regpinA : STD_LOGIC_VECTOR(7 downto 0);

begin

	im : process (clk)
			variable a_int : natural;		
			variable rdwr : std_logic_vector(1 downto 0);
			begin
				if (clk'event and clk='1') then
					a_int := CONV_INTEGER(addr);
					if a_int = PORTA then
						rdwr := rd & wr;
						ioread <= (others => '0');
						case rdwr is
							when "10" => -- rd
									ioread <= inport;
							when "01" => -- wr
								for i in 0 to 7 loop
									if regddra(i) = '1' then
										outport(i) <= iowrite(i); 
									end if;
								end loop;
							when others => NULL; 
						end case;								
					elsif a_int = DDRA then
						regddra <= iowrite;					
						ioread <= regddra;
					elsif a_int = BASEA then
						if rd = '1' then
							ioread <= inport;
						end if;	
						
					elsif a_int = PORTB then
						rdwr := rd & wr;
						ioread <= (others => '0');
						case rdwr is
							when "10" => -- rd
								for i in 0 to 7 loop
									if regddrb(i) = '1' then
										ioread(i) <= inport(i);
									end if;
								end loop;
							when "01" => -- wr
									outport <= iowrite;
							when others => NULL; 
						end case;	
					elsif a_int = DDRB then
						ioread <= regddrb;
						regddrb <= iowrite;
					end if;					
				end if;
			end process im;
end ioport_architecture;

