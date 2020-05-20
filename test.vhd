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


--function Log2( input:unsigned ) return unsigned is
--	variable temp:unsigned (19 downto 0);
--	variable log:unsigned (19 downto 0);
--	begin
--		temp := input;
--		log := 0;
--		while (temp /= 0) loop
--			temp := temp/2;
--			log := log+1;
--		end loop;
--	return log;
--end function Log2;

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


--	Square_Proc_log : process (INSIGNAL) is
--		variable n : unsigned (39 downto 0) := 0;
--	begin
--		n := shift_left(unsigned("00000000000000000000" & INSIGNAL), to_integer(Log2(unsigned(INSIGNAL))));
--		if n > unsigned(INSIGNAL) then
--			OUTSIGNAL <= '1';
--		else
--			OUTSIGNAL <= '0';
--		end if;		
--	end process Square_Proc_log;

	

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


	Square_Proc_F : process (INSIGNAL) is
		variable n : unsigned (39 downto 0);
	begin
    	if (unsigned(INSIGNAL) > 524288) then
    		n := 274877906944;

		 elsif (unsigned(INSIGNAL) > 458982) then
			n := 210665281602;
		 elsif (unsigned(INSIGNAL) > 401812) then
			n := 161452993315;
		 elsif (unsigned(INSIGNAL) > 351762) then
			n := 123736900795;
		 elsif (unsigned(INSIGNAL) > 307947) then
			n := 94831444769;
		 elsif (unsigned(INSIGNAL) > 269589) then
			n := 72678423810;
		 elsif (unsigned(INSIGNAL) > 236009) then
			n := 55700440928;
		 elsif (unsigned(INSIGNAL) > 206612) then
			n := 42688585649;
		 elsif (unsigned(INSIGNAL) > 180876) then
			n := 32716354024;
		 elsif (unsigned(INSIGNAL) > 158346) then
			n := 25073677292;
		 elsif (unsigned(INSIGNAL) > 138623) then
			n := 19216361715;
		 elsif (unsigned(INSIGNAL) > 121356) then
			n := 14727339484;
		 elsif (unsigned(INSIGNAL) > 106240) then
			n := 11286971565;
		 elsif (unsigned(INSIGNAL) > 93006) then
			n := 8650287939;
		 elsif (unsigned(INSIGNAL) > 81422) then
			n := 6629544603;
		 elsif (unsigned(INSIGNAL) > 71280) then
			n := 5080855338;
		 elsif (unsigned(INSIGNAL) > 62401) then
			n := 3893946343;
		 elsif (unsigned(INSIGNAL) > 54628) then
			n := 2984304239;
		 elsif (unsigned(INSIGNAL) > 47824) then
			n := 2287158324;
		 elsif (unsigned(INSIGNAL) > 41867) then
			n := 1752868601;
		 elsif (unsigned(INSIGNAL) > 36652) then
			n := 1343391186;
		 elsif (unsigned(INSIGNAL) > 32086) then
			n := 1029569403;
		 elsif (unsigned(INSIGNAL) > 28090) then
			n := 789057697;
		 elsif (unsigned(INSIGNAL) > 24591) then
			n := 604730528;
		 elsif (unsigned(INSIGNAL) > 21528) then
			n := 463462955;
		 elsif (unsigned(INSIGNAL) > 18846) then
			n := 355196076;
		 elsif (unsigned(INSIGNAL) > 16499) then
			n := 272220791;
		 elsif (unsigned(INSIGNAL) > 14443) then
			n := 208628879;
		 elsif (unsigned(INSIGNAL) > 12644) then
			n := 159892303;
		 elsif (unsigned(INSIGNAL) > 11069) then
			n := 122540794;
		 elsif (unsigned(INSIGNAL) > 9690) then
			n := 93914753;
		 elsif (unsigned(INSIGNAL) > 8483) then
			n := 71975875;
		 elsif (unsigned(INSIGNAL) > 7427) then
			n := 55162010;
		 elsif (unsigned(INSIGNAL) > 6501) then
			n := 42275935;
		 elsif (unsigned(INSIGNAL) > 5692) then
			n := 32400100;
		 elsif (unsigned(INSIGNAL) > 4983) then
			n := 24831301;
		 elsif (unsigned(INSIGNAL) > 4362) then
			n := 19030606;
		 elsif (unsigned(INSIGNAL) > 3819) then
			n := 14584977;
		 elsif (unsigned(INSIGNAL) > 3343) then
			n := 11177865;
		 elsif (unsigned(INSIGNAL) > 2926) then
			n := 8566669;
		 elsif (unsigned(INSIGNAL) > 2562) then
			n := 6565459;
		 elsif (unsigned(INSIGNAL) > 2243) then
			n := 5031741;
		 elsif (unsigned(INSIGNAL) > 1963) then
			n := 3856305;
		 elsif (unsigned(INSIGNAL) > 1719) then
			n := 2955456;
		 elsif (unsigned(INSIGNAL) > 1505) then
			n := 2265049;
		 elsif (unsigned(INSIGNAL) > 1317) then
			n := 1735924;
		 elsif (unsigned(INSIGNAL) > 1153) then
			n := 1330405;
		 elsif (unsigned(INSIGNAL) > 1009) then
			n := 1019617;
		 elsif (unsigned(INSIGNAL) > 883) then
			n := 781430;
		 elsif (unsigned(INSIGNAL) > 773) then
			n := 598884;
		 elsif (unsigned(INSIGNAL) > 677) then
			n := 458982;
		 elsif (unsigned(INSIGNAL) > 593) then
			n := 351762;
		 elsif (unsigned(INSIGNAL) > 519) then
			n := 269589;
		 elsif (unsigned(INSIGNAL) > 454) then
			n := 206612;
		 elsif (unsigned(INSIGNAL) > 397) then
			n := 158346;
		 elsif (unsigned(INSIGNAL) > 348) then
			n := 121356;
		 elsif (unsigned(INSIGNAL) > 304) then
			n := 93006;
		 elsif (unsigned(INSIGNAL) > 266) then
			n := 71280;
		 elsif (unsigned(INSIGNAL) > 233) then
			n := 54628;
		 elsif (unsigned(INSIGNAL) > 204) then
			n := 41867;
		 elsif (unsigned(INSIGNAL) > 179) then
			n := 32086;
		 elsif (unsigned(INSIGNAL) > 156) then
			n := 24591;
		 elsif (unsigned(INSIGNAL) > 137) then
			n := 18846;
		 elsif (unsigned(INSIGNAL) > 120) then
			n := 14443;
		 elsif (unsigned(INSIGNAL) > 105) then
			n := 11069;
		 elsif (unsigned(INSIGNAL) > 92) then
			n := 8483;
		 elsif (unsigned(INSIGNAL) > 80) then
			n := 6501;
		 elsif (unsigned(INSIGNAL) > 70) then
			n := 4983;
		 elsif (unsigned(INSIGNAL) > 61) then
			n := 3819;
		 elsif (unsigned(INSIGNAL) > 54) then
			n := 2926;
		 elsif (unsigned(INSIGNAL) > 47) then
			n := 2243;
		 elsif (unsigned(INSIGNAL) > 41) then
			n := 1719;
		 elsif (unsigned(INSIGNAL) > 36) then
			n := 1317;
		 elsif (unsigned(INSIGNAL) > 31) then
			n := 1009;
		 elsif (unsigned(INSIGNAL) > 27) then
			n := 773;
		 elsif (unsigned(INSIGNAL) > 24) then
			n := 593;
		 elsif (unsigned(INSIGNAL) > 21) then
			n := 454;
		 elsif (unsigned(INSIGNAL) > 18) then
			n := 348;
		 elsif (unsigned(INSIGNAL) > 16) then
			n := 266;
		 elsif (unsigned(INSIGNAL) > 14) then
			n := 204;
		 elsif (unsigned(INSIGNAL) > 12) then
			n := 156;
		 elsif (unsigned(INSIGNAL) > 10) then
			n := 120;
		 elsif (unsigned(INSIGNAL) > 9) then
			n := 92;
		 elsif (unsigned(INSIGNAL) > 8) then
			n := 70;
		 elsif (unsigned(INSIGNAL) > 7) then
			n := 54;
		 elsif (unsigned(INSIGNAL) > 6) then
			n := 41;
		 elsif (unsigned(INSIGNAL) > 5) then
			n := 31;
		 elsif (unsigned(INSIGNAL) > 4) then
			n := 24;
		 elsif (unsigned(INSIGNAL) > 4) then
			n := 18;
		 elsif (unsigned(INSIGNAL) > 3) then
			n := 14;
		 elsif (unsigned(INSIGNAL) > 3) then
			n := 10;
		 elsif (unsigned(INSIGNAL) > 2) then
			n := 8;
		 elsif (unsigned(INSIGNAL) > 2) then
			n := 6;
		 elsif (unsigned(INSIGNAL) > 2) then
			n := 4;
		 elsif (unsigned(INSIGNAL) > 1) then
			n := 3;
		 elsif (unsigned(INSIGNAL) > 1) then
			n := 2;
		 elsif (unsigned(INSIGNAL) > 1) then
			n := 2;
		 elsif (unsigned(INSIGNAL) > 1) then
			n := 1;
		 elsif (unsigned(INSIGNAL) > 1) then
			n := 1;

    	else
    		n := 2;   	
    	end if;
    	
    	if (n > unsigned(THRESHOLD)) then
    		OUTSIGNAL <= '1';
		else
			OUTSIGNAL <= '0';
    	end if;
    end process Square_Proc_F;		

end TestArch;











































