
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_signed.all;


entity ttt is
PORT(k:in std_logic_vector(3 downto 0);
		clk, reset: in std_logic;
		ans: out integer range -99999 to 99999);
end ttt;

architecture Behavioral of ttt is
type state is(rst,st0, st1, w1, st2, w2, st3, w3, st4, w4, st5, w5, result, wr1, wr2);
signal pr_state: state := rst;
signal nx_state: state;

-----------------------------------------------
signal num_s: integer range 0 to 99999 := 0;
signal num1_s: integer range -99999 to 99999 := 0;
signal num2_s: integer range -99999 to 99999 := 0;
signal a_s: integer range -99999 to 99999 := 0;

signal flag_s: integer range 0 to 5 := 0;

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
variable num1: integer range -99999 to 99999 := 0;
variable num2: integer range -99999 to 99999 := 0;
variable flag: integer range 0 to 5 := 0;
variable a: integer range -99999 to 99999 := 0;


begin
case pr_state is
----------------------------------------------------------------------------------
when st0 => 
if(conv_integer(k) >=0 and conv_integer(k)<10) then 
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
----------------------------------------------------------------------------------
when st1 => 
num := num * 10;
num := num + conv_integer(k);
nx_state <= w1;
----------------------------------------------------------------------------------
when w1 => 
if(k="1111") then nx_state <= st0;
else nx_state <= w1;
end if;
----------------------------------------------------------------------------------
when st2 => 
--num2 := num1;
num1 := num;

if(flag=1) then 
num2:= num1 + num2;
elsif(flag=2) then 
num2:= num2 - num1;
elsif(flag=3) then 
num2:= num1 * num2;
elsif(flag=4) then 
num2:= num2 / num1;
end if;
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
--num2 := num1;
num1 := num;

if(flag=1) then 
num2:= num1 + num2;
elsif(flag=2) then 
num2:= num2 - num1;
elsif(flag=3) then 
num2:= num1 * num2;
elsif(flag=4) then 
num2:= num2 / num1;
end if;
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
--num2 := num1;
num1 := num;

if(flag=1) then 
num2:= num1 + num2;
elsif(flag=2) then 
num2:= num2 - num1;
elsif(flag=3) then 
num2:= num1 * num2;
elsif(flag=4) then 
num2:= num2 / num1;
end if;
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
--num2 := num1;
num1 := num;

if(flag=1) then 
num2:= num1 + num2;
elsif(flag=2) then 
num2:= num2 - num1;
elsif(flag=3) then 
num2:= num1 * num2;
elsif(flag=4) then 
num2:= num2 / num1;
end if;
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
num2:= num1 + num2;
elsif(flag=2) then 
num2:= num2 - num1;
elsif(flag=3) then 
num2:= num1 * num2;
elsif(flag=4) then 
num2:= num2 / num1;
end if;
nx_state <= wr1;
----------------------------------------------------------------------------------
when wr1 => 
if(k/="1111") then nx_state <= wr2;
else nx_state <= wr1;
end if;
----------------------------------------------------------------------------------
when wr2 => 
if(k="1111") then nx_state <= rst;
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


num_s <= num;
 num1_s <= num1;
 num2_s <= num2;
 flag_s <=flag;


end process;
end Behavioral;
