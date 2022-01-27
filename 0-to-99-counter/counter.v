--By: Soheil
--soh3il.com

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
  port (
    clk : in std_logic;
    seg1,seg0 : out std_logic_vector(6 downto 0) 
  ) ;
end counter;

architecture behavioral of counter is
signal clk_d : std_logic :='0';
signal d0,d1 : integer range 10 downto 0 := 0;
begin
-------------------clock_divider ---------------------
cntr : process( clk,clk_d )
variable cnt : integer range 5_000_000 downto 0:=0;
begin
    if (clk'event AND clk = '1') then 
        cnt := cnt + 1;
		   if cnt = 5_000_000 then
        cnt := 0;
        clk_d <= NOT(clk_d);
    end if;
    end if;
end process;
-------------------clock_divider ---------------------



beshmare : process( clk_d,d0,d1)
begin
	if (clk_d'event AND clk_d = '1') then
        d0 <= d0 + 1;
        if d0 = 9 then
            d1 <= d1 + 1;
            d0 <= 0;
				if d1 = 9 then
            d1 <= 0;
        end if;
        end if;
        
	end if;
end process;
---------------------BCD/SEG-------------------------------
seg0 <= "1111110" when d0=0 else
        "0110000" when d0=1 else
        "1101101" when d0=2 else
        "1111001" when d0=3 else
        "0110011" when d0=4 else
        "1011011" when d0=5 else
        "1011111" when d0=6 else
        "1110000" when d0=7 else
        "1111111" when d0=8 else
        "1111011" when d0=9 else
        "ZZZZZZZ";
		  
seg1 <= "1111110" when d1=0 else
        "0110000" when d1=1 else
        "1101101" when d1=2 else
        "1111001" when d1=3 else
        "0110011" when d1=4 else
        "1011011" when d1=5 else
        "1011111" when d1=6 else
        "1110000" when d1=7 else
        "1111111" when d1=8 else
        "1111011" when d1=9 else
        "ZZZZZZZ";
end behavioral;
