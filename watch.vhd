--digital clock on fpga




library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity watch is
port(clk:in std_logic;
		rst:in std_logic;
	min0,min1,hr0,hr1:out std_logic_vector(6 downto 0));
end watch;

architecture behav of watch is
	signal divider:std_logic_vector(23 downto 0);	--clock divider signal for 1 hz op
begin
	process(clk,rst) 	--process for 1 hz clock
	begin
		if(rst='1') then
			divider<=(others=>'0');
		elsif(rising_edge(clk)) then
			divider<=divider+'1';
		end if;
	end process;

	process(divider(23),rst)	--process with 1 hz clock for 1 sec
	
		variable countsec:natural range 0 to 60:=0;	--second counter 0 to 60
		variable countmin0:natural range 0 to 10:=0;	--min0 counter 0 to 10
		variable countmin1:natural range 0 to 6:=0;	--min1 counter 0 to 6
		variable counthr0:natural range 0 to 10:=0;	--hr0 counter 0 to 10
		variable counthr1:natural range 0 to 1:=0;	--hr1 counter 0 to 1
		
	begin
		if(rst='1') then
			countsec:=0;
			countmin0:=0;
			countmin1:=0;
			counthr0:=0;
			counthr1:=0;
		elsif(rising_edge(divider(23))) then
			countsec:=countsec+1;
			if(countsec=60) then
				countsec:=0;
				countmin0:=countmin0+1;
				if(countmin0=10) then
					countmin0:=0;
					countmin1:=countmin1+1;
					if(countmin1=6) then
						countmin1:=0;
						counthr0:=counthr0+1;
						if(counthr0=10) then
							counthr0:=0;
							counthr1:=counthr1+1;
							if(counthr1=3) then
								countmin0:=0;
								countmin1:=0;
								counthr0:=0;
								counthr1:=0;
							end if;
						end if;
					end if;
				end if;				
			end if;
		end if;
		
--	developed by Ninad Waingankar
	
	--codes for Common anode 7 segment display	abcdefg format
	
	--for min 0
		case countmin0 is 
			when 0=>min0<="0000001";-- shows 0
			when 1=>min0<="1001111";-- shows 1
			when 2=>min0<="0010010";-- shows 2
			when 3=>min0<="0000110";-- shows 3
			when 4=>min0<="1001100";-- shows 4
			when 5=>min0<="0100100";-- shows 5
			when 6=>min0<="0100000";-- shows 6
			when 7=>min0<="0001111";-- shows 7
			when 8=>min0<="0000000";-- shows 8 
			when 9=>min0<="0000100";-- shows 9
			when others=>null;
		end case;
		
		--for min 1
		case countmin1 is 
			when 0=>min1<="0000001";--
			when 1=>min1<="1001111";--
			when 2=>min1<="0010010";--
			when 3=>min1<="0000110";--
			when 4=>min1<="1001100";--
			when 5=>min1<="0100100";--
			when 6=>min1<="0100000";--
			when others=>null;
		end case;
		
		--for hr 0
		case counthr0 is 
			when 0=>hr0<="0000001";--
			when 1=>hr0<="1001111";--
			when 2=>hr0<="0010010";--
			when 3=>hr0<="0000110";--
			when 4=>hr0<="1001100";--
			when 5=>hr0<="0100100";--
			when 6=>hr0<="0100000";--
			when 7=>hr0<="0001111";--
			when 8=>hr0<="0000000";--
			when 9=>hr0<="0000100";--
			when others=>null;
		end case;
		
		
		--for hr 1
		case counthr1 is 
			when 0=>hr1<="0000001";--
			when 1=>hr1<="1001111";--
			when others=>null;
		end case;
		
	end process;	
end behav;
