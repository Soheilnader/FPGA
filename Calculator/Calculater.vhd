
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_signed.all;


entity tst is
PORT(k:in std_logic_vector(3 downto 0);
		clk, reset: in std_logic;
		ans: out integer range -99999 to 99999);
end tst;

architecture Behavioral of tst is
type state is(n1, rst, result, n2, op, w0, w1);
signal pr_state: state := rst;
signal nx_state: state;

-----------------------------------------------
signal dig_s: integer range 0 to 5 := 0;
signal nums_s: integer range 0 to 20 := 0;
signal adad1_s: integer range -99999 to 99999 := 0;
signal adad2_s: integer range -99999 to 99999 := 0;
signal dig1_s: integer range 0 to 9 := 0;
signal dig2_s: integer range 0 to 9 := 0;
-----------------------------------------------
begin
process(clk, reset)
begin
if(reset='1') then pr_state<=rst;
elsif(clk'event and clk = '1') then pr_state<=nx_state;
end if;
end process;

process(pr_state,k)
variable dig: integer range 0 to 5 := 0;
variable nums: integer range 0 to 20 := 0;
variable adad1: integer range -99999 to 99999 := 0;
variable adad2: integer range -99999 to 99999 := 0;
variable dig1: integer range 0 to 9 := 0;
variable dig2: integer range 0 to 9 := 0;

begin
case pr_state is
----------------------------------------------------------------------------------
when n1 => 
if(conv_integer(k) >=0 and conv_integer(k)<10 and dig/=5) then 
nx_state <= n2;
elsif(conv_integer(k) >=10 and conv_integer(k)<14 and dig/=0) then 
nx_state <= op;
elsif(k="1110") then 
nx_state <= result;
else nx_state <= n1;
end if;
----------------------------------------------------------------------------------
when n2 => 
dig:=dig+1;
dig2:=conv_integer(k);
dig1:=dig1*10+dig2;
nx_state <=w0;
----------------------------------------------------------------------------------
when op => 
dig:=0;
nums:=nums+1;
adad2:=dig1;
adad1:=adad1+adad2;
dig1:=0;
dig2:=0;
nx_state <= w1;
----------------------------------------------------------------------------------
when result => adad1:=adad1+adad2;

----------------------------------------------------------------------------------
when rst => adad1:=adad1+adad2;
dig := 0;
nums := 0;
adad1 := 0;
adad2 :=0;
dig1 := 0;
dig2 := 0;
nx_state <= n1;
----------------------------------------------------------------------------------
when w0 => 
if(k="1111") then nx_state <= n1;
else nx_state <= w0;
end if;
----------------------------------------------------------------------------------
when w1 => 
if(k="1111") then nx_state <= n1;
else nx_state <= w1;
end if;
----------------------------------------------------------------------------------
end case;


 dig_s <= dig;
 nums_s <= nums;
 adad1_s <=adad1;
 adad2_s <=adad2;
 dig1_s <=dig1;
 dig2_s <=dig2;

ans <= adad1;
end process;
end Behavioral;

