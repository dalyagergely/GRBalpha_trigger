-- Test code for FPGA efficiency
-- Written by Gergely Dálya, 2020
-- dalyag@caesar.elte.hu

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.math_real."log2";
--use ieee.math_real."ceil";


entity TestCircuit is
	port (
		INSIGNAL	: in std_logic_vector (19 downto 0);
		THRESHOLD	: in std_logic_vector (39 downto 0);
		OUTSIGNAL	: out std_logic := '0'
	);
end TestCircuit;


architecture TestArch of TestCircuit is


function Log2( input:unsigned ) return unsigned is
	variable temp:unsigned (19 downto 0);
	variable log:unsigned (19 downto 0);
	begin
		temp := input;
		log := 0;
		while (temp /= 0) loop
			temp := temp/2;
			log := log+1;
		end loop;
	return log;
end function log2;

begin

-- ### MULTIPLICATION / DIVISION TESTING ###

--	Multip_Proc_A : process (INSIGNAL) is
--		variable n	: unsigned (10 downto 0) := 256;
--		variable NN : unsigned (10 downto 0) := 1024;
--	begin
--		if (unsigned(INSIGNAL)*unsigned(INSIGNAL)/n > unsigned(THRESHOLD)/NN) then
--			OUTSIGNAL <= '1';
--		else
--			OUTSIGNAL <= '0';
--		end if;
--	end process Multip_Proc_A;
	-- Total LUTs: 275

	
--	Multip_Proc_B : process (INSIGNAL) is
--		variable n	: unsigned (10 downto 0) := 256;
--		variable NN : unsigned (10 downto 0) := 1024;
--	begin
--		if (unsigned(INSIGNAL)*unsigned(INSIGNAL)*NN > unsigned(THRESHOLD)*n) then
--			OUTSIGNAL <= '1';
--		else
--			OUTSIGNAL <= '0';
--		end if;
--	end process Multip_Proc_B;
	-- Total LUTs: 61


-- ### SQUARING TESTING ###

--	Square_Proc_A : process (INSIGNAL) is
--	begin
--		if (unsigned(INSIGNAL)*unsigned(INSIGNAL) > unsigned(THRESHOLD)) then
--			OUTSIGNAL <= '1';
--		else
--			OUTSIGNAL <= '0';
--		end if;
--	end process Square_Proc_A;


	Square_Proc_log : process (INSIGNAL) is
		variable n : unsigned (39 downto 0) := 0;
	begin
		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), to_integer(Log2(unsigned(INSIGNAL))));
		if n > unsigned(INSIGNAL) then
			OUTSIGNAL <= '1';
		else
			OUTSIGNAL <= '0';
		end if;		
	end process Square_Proc_log;

	

--	Square_Proc_B : process (INSIGNAL) is  -- Cast of incompatible types
--		variable n : unsigned (39 downto 0) := 0;
--	begin
--		if (Log2(unsigned(INSIGNAL)) > 19) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 19);
--		elsif (Log2(unsigned(INSIGNAL)) > 18) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 18);
--		elsif (Log2(unsigned(INSIGNAL)) > 17) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 17);
--		elsif (Log2(unsigned(INSIGNAL)) > 16) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 16);
--		elsif (Log2(unsigned(INSIGNAL)) > 15) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 15);
--		elsif (Log2(unsigned(INSIGNAL)) > 14) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 14);
--		elsif (Log2(unsigned(INSIGNAL)) > 13) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 13);
--		elsif (Log2(unsigned(INSIGNAL)) > 12) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 12);
--		elsif (Log2(unsigned(INSIGNAL)) > 11) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 11);
--		elsif (Log2(unsigned(INSIGNAL)) > 10) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 10);
--		elsif (Log2(unsigned(INSIGNAL)) > 9) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 9);
--		elsif (Log2(unsigned(INSIGNAL)) > 8) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 8);
--		elsif (Log2(unsigned(INSIGNAL)) > 7) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 7);
--		elsif (Log2(unsigned(INSIGNAL)) > 6) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 6);
--		elsif (Log2(unsigned(INSIGNAL)) > 5) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 5);
--		elsif (Log2(unsigned(INSIGNAL)) > 4) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 4);
--		elsif (Log2(unsigned(INSIGNAL)) > 3) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 3);
--		elsif (Log2(unsigned(INSIGNAL)) > 2) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 2);
--		elsif (Log2(unsigned(INSIGNAL)) > 1) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 1);
--		end if;
--		
--		if (n > unsigned(THRESHOLD)) then
--   		OUTSIGNAL <= '1';
--		else
--			OUTSIGNAL <= '0';
--   	end if;
--	end process Square_Proc_B;




--	Square_Proc_C : process (INSIGNAL) is
--		variable n : unsigned (39 downto 0);
--   begin
--    	if (unsigned(INSIGNAL) > 1048575) then
--    		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 20);
--    	elsif (unsigned(INSIGNAL) > 524287) then
--    		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 19);
--    	elsif (unsigned(INSIGNAL) > 262143) then
--    		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 18);
--    	elsif (unsigned(INSIGNAL) > 131071) then
--    		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 17);
--    	elsif (unsigned(INSIGNAL) > 65535) then
--			n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 16);
--    	elsif (unsigned(INSIGNAL) > 32767) then
--    		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 15);
--    	elsif (unsigned(INSIGNAL) > 16383) then
--    		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 14);
--    	elsif (unsigned(INSIGNAL) > 8191) then
--   		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 13);
--    	elsif (unsigned(INSIGNAL) > 4095) then
--    		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 12);
--    	elsif (unsigned(INSIGNAL) > 2047) then
--    		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 11);
--    	elsif (unsigned(INSIGNAL) > 1023) then
--    		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 10);
--    	elsif (unsigned(INSIGNAL) > 511) then
--    		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 9);
--    	elsif (unsigned(INSIGNAL) > 255) then
--    		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 8);
--    	elsif (unsigned(INSIGNAL) > 127) then
--    		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 7);
--    	elsif (unsigned(INSIGNAL) > 63) then
--    		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 6);
--    	elsif (unsigned(INSIGNAL) > 31) then
--    		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 5);
--    	elsif (unsigned(INSIGNAL) > 15) then
--    		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 4);
--    	elsif (unsigned(INSIGNAL) > 7) then
--    		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 3);
--    	elsif (unsigned(INSIGNAL) > 3) then
--    		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 2);
--    	elsif (unsigned(INSIGNAL) > 1) then
--    		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), 1);
--    	else
--    		n := "0000000000000000000000000000000000000010";   	
--    	end if;
--    	
--    	if (n > unsigned(THRESHOLD)) then
--    		OUTSIGNAL <= '1';
--		else
--			OUTSIGNAL <= '0';
--    	end if;
--	end process Square_Proc_C;
	
	
--	Square_Proc_D : process (INSIGNAL) is
--		variable n : unsigned (39 downto 0);
--   begin
--    	if (unsigned(INSIGNAL) > 1048575) then
--    		n := 1099511627776;
--    	elsif (unsigned(INSIGNAL) > 524287) then
--    		n := 274877906944;
--    	elsif (unsigned(INSIGNAL) > 262143) then
--    		n := 68719476736;
--    	elsif (unsigned(INSIGNAL) > 131071) then
--    		n := 17179869184;
--    	elsif (unsigned(INSIGNAL) > 65535) then
--			n := 4294967296;
--    	elsif (unsigned(INSIGNAL) > 32767) then
--    		n := 1073741824;
--    	elsif (unsigned(INSIGNAL) > 16383) then
--    		n := 268435456;
--    	elsif (unsigned(INSIGNAL) > 8191) then
--   			n := 67108864;
--    	elsif (unsigned(INSIGNAL) > 4095) then
--    		n := 16777216;
--    	elsif (unsigned(INSIGNAL) > 2047) then
--    		n := 4194304;
--    	elsif (unsigned(INSIGNAL) > 1023) then
--    		n := 1048576;
--    	elsif (unsigned(INSIGNAL) > 511) then
--    		n := 262144;
--    	elsif (unsigned(INSIGNAL) > 255) then
--    		n := 65536;
--    	elsif (unsigned(INSIGNAL) > 127) then
--    		n := 16384;
--    	elsif (unsigned(INSIGNAL) > 63) then
--    		n := 4096;
--    	elsif (unsigned(INSIGNAL) > 31) then
--    		n := 1024;
--    	elsif (unsigned(INSIGNAL) > 15) then
--    		n := 256;
--    	elsif (unsigned(INSIGNAL) > 7) then
--    		n := 64;
--    	elsif (unsigned(INSIGNAL) > 3) then
--    		n := 16;
--    	elsif (unsigned(INSIGNAL) > 1) then
--    		n := 4;
--    	else
--    		n := 2;   	
--    	end if;
--    	
--    	if (n > unsigned(THRESHOLD)) then
--    		OUTSIGNAL <= '1';
--		else
--			OUTSIGNAL <= '0';
--    	end if;
--	end process Square_Proc_D;



--	Square_Proc_E : process (INSIGNAL) is
--		variable n : unsigned (39 downto 0);
--   begin
--    	if (unsigned(INSIGNAL) > 1048575) then
--    		n := 1099511627776;
--    	elsif (unsigned(INSIGNAL) > 741455) then
--    		n := 549755813888;	
--    	elsif (unsigned(INSIGNAL) > 524287) then
--    		n := 274877906944;
--   	elsif (unsigned(INSIGNAL) > 370727) then
--    		n := 137438953472;
--    	elsif (unsigned(INSIGNAL) > 262143) then
--    		n := 68719476736;
--    	elsif (unsigned(INSIGNAL) > 185363) then
--    		n := 34359738368;
--    	elsif (unsigned(INSIGNAL) > 131071) then
--    		n := 17179869184;
--    	elsif (unsigned(INSIGNAL) > 92681) then
--			n := 8589934592;
--		elsif (unsigned(INSIGNAL) > 65535) then
--			n := 4294967296;
--   	elsif (unsigned(INSIGNAL) > 46340) then
--    		n := 2147483648;
--    	elsif (unsigned(INSIGNAL) > 32767) then
--   		n := 1073741824;
--    	elsif (unsigned(INSIGNAL) > 23170) then
--    		n := 536870912;
--    	elsif (unsigned(INSIGNAL) > 16383) then
--    		n := 268435456;
--    	elsif (unsigned(INSIGNAL) > 11585) then
--    		n := 134217728;
--    	elsif (unsigned(INSIGNAL) > 8191) then
--    		n := 67108864;
--   	elsif (unsigned(INSIGNAL) > 5792) then
--    		n := 33554432;
--    	elsif (unsigned(INSIGNAL) > 4095) then
--    		n := 16777216;
--    	elsif (unsigned(INSIGNAL) > 2896) then
--    		n := 8388608;
--    	elsif (unsigned(INSIGNAL) > 2047) then
--    		n := 4194304;
--    	elsif (unsigned(INSIGNAL) > 1448) then
--    		n := 2097152;
--    	elsif (unsigned(INSIGNAL) > 1023) then
--    		n := 1048576;
--    	elsif (unsigned(INSIGNAL) > 724) then
--    		n := 524288;
--    	elsif (unsigned(INSIGNAL) > 511) then
--   		n := 262144;
--    	elsif (unsigned(INSIGNAL) > 362) then
--    		n := 131072;
--    	elsif (unsigned(INSIGNAL) > 255) then
--   		n := 65536;
--    	elsif (unsigned(INSIGNAL) > 181) then
--    		n := 32768;
--    	elsif (unsigned(INSIGNAL) > 127) then
--    		n := 16384;
--    	elsif (unsigned(INSIGNAL) > 90) then
--    		n := 8192;
--    	elsif (unsigned(INSIGNAL) > 63) then
--   		n := 4096;
--    	elsif (unsigned(INSIGNAL) > 45) then
--    		n := 2048;
--    	elsif (unsigned(INSIGNAL) > 31) then
--    		n := 1024;
--    	elsif (unsigned(INSIGNAL) > 22) then
--    		n := 512;
--    	elsif (unsigned(INSIGNAL) > 15) then
--   		n := 256;
--    	elsif (unsigned(INSIGNAL) > 11) then
--    		n := 128;
--    	elsif (unsigned(INSIGNAL) > 7) then
--    		n := 64;
--    	elsif (unsigned(INSIGNAL) > 5) then
--    		n := 32;
--    	elsif (unsigned(INSIGNAL) > 3) then
--    		n := 16;
--    	elsif (unsigned(INSIGNAL) > 2) then
--    		n := 8;
--    	elsif (unsigned(INSIGNAL) > 1) then
--    		n := 4;
--    	else
--    		n := 2;   	
--    	end if;
--    	
--    	if (n > unsigned(THRESHOLD)) then
--    		OUTSIGNAL <= '1';
--		else
--			OUTSIGNAL <= '0';
--    	end if;
--    end process Square_Proc_E;		

end TestArch;











































