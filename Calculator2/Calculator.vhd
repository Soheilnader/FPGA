--By:Soheil Nadernezhad

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_signed.all;


entity calculator is
PORT(k:in std_logic_vector(3 downto 0);
		clk, reset: in std_logic;
		seg4, seg3, seg2, seg1, seg0: out std_logic_vector(6 downto 0);
		minus: out std_logic);
end calculator;

architecture Behavioral of calculator is
type state is(rst,st0, st1, w1, st2, w2, st3, w3, st4, w4, st5, w5, result, wr1, wr2);
type segments is array (0 to 9) of std_logic_vector(6 downto 0);
constant seven_seg: segments :=("1111110", "0110000","1101101","1111001","0110011",
										 "1011011","1011111","1110000","1111111", "1111011");
signal pr_state: state := rst;
signal nx_state: state;
signal seg4_s, seg3_s, seg2_s, seg1_s, seg0_s: integer range 0 to 9;

-----------------------------------------------
begin
process(clk, reset)
begin
if(reset='1') then pr_state<=rst;
elsif(clk'event and clk = '1') then pr_state<=nx_state;
end if;
end process;

process(pr_state,k)
variable num: integer range 0 to 99999 := 0;
variable num1: integer range 0 to 99999 := 0;
variable num2: integer range 0 to 99999 := 0;
variable answer: integer range -99999 to 99999 := 0;
variable flag: integer range 0 to 5 := 0;

begin
case pr_state is
----------------------------------------------------------------------------------
when st0 => 
minus <= '0';
if(conv_integer('0' & k) >=0 and conv_integer('0' & k)<10) then 
nx_state <= st1;			
elsif(k="1010") then 	-- +
nx_state <= st2;			 
elsif(k="1011") then 	-- -
nx_state <= st3;			
elsif(k="1100") then 	-- *
nx_state <= st4;		
elsif(k="1101") then 	-- /
nx_state <= st5;			
elsif(k="1110") then 	-- =
nx_state <= result;
else nx_state <= st0;
end if;
seg4_s <= (num / 10000) mod 10;
seg3_s <= (num / 1000) mod 10;
seg2_s <= (num / 100) mod 10;
seg1_s <= (num / 10) mod 10;
seg0_s <= (num / 1) mod 10;
----------------------------------------------------------------------------------
when st1 => 
num := num * 10;
num := num + conv_integer('0' & k);
nx_state <= w1;
----------------------------------------------------------------------------------
when w1 => 
if(k="1111") then nx_state <= st0;
else nx_state <= w1;
end if;
----------------------------------------------------------------------------------
when st2 => 
num1 := num;
num:=0;
flag :=1;
nx_state <= w2;
----------------------------------------------------------------------------------
when w2 => 
if(k="1111") then nx_state <= st0;
else nx_state <= w2;
end if;
----------------------------------------------------------------------------------
when st3 => 
num1 := num;
num:=0;
flag :=2;
nx_state <= w3;
----------------------------------------------------------------------------------
when w3 => 
if(k="1111") then nx_state <= st0;
else nx_state <= w3;
end if;
----------------------------------------------------------------------------------
when st4 => 
num1 := num;
num:=0;
flag :=3;
nx_state <= w2;
----------------------------------------------------------------------------------
when w4 => 
if(k="1111") then nx_state <= st0;
else nx_state <= w4;
end if;
----------------------------------------------------------------------------------
when st5 => 
num1 := num;
num:=0;
flag :=4;
nx_state <= w5;
----------------------------------------------------------------------------------
when w5 => 
if(k="1111") then nx_state <= st0;
else nx_state <= w5;
end if;
----------------------------------------------------------------------------------
when result =>
num2 := num1;
num1 := num;
if(flag=1) then 
answer:= num1 + num2;
elsif(flag=2) then 
answer:= num2 - num1;
elsif(flag=3) then 
answer:= num1 * num2;
elsif(flag=4 and num1/=0) then 
answer:= num2 / num1;
elsif(flag=4 and num1=0) then 
answer:= 99999;
end if;
seg4_s <= (abs(answer) / 10000) mod 10;
seg3_s <= (abs(answer) / 1000) mod 10;
seg2_s <= (abs(answer) / 100) mod 10;
seg1_s <= (abs(answer) / 10) mod 10;
seg0_s <= (abs(answer) / 1) mod 10;
if(answer < 0) then minus <= '1';
else minus <= '0';
end if;
nx_state <= wr1;
----------------------------------------------------------------------------------
when wr1 => 
if(k="1111") then nx_state <= wr2;
else nx_state <= wr1;
end if;
----------------------------------------------------------------------------------
when wr2 => 
if(k/="1111") then nx_state <= rst;
else nx_state <= wr2;
end if;
----------------------------------------------------------------------------------
when rst =>
num:=0;
num1:=0;
num2:=0;
flag:=0;
nx_state <= st0;
----------------------------------------------------------------------------------
end case;


end process;
seg4 <= seven_seg(seg4_s);
seg3 <= seven_seg(seg3_s);
seg2 <= seven_seg(seg2_s);
seg1 <= seven_seg(seg1_s);
seg0 <= seven_seg(seg0_s);

end Behavioral;
