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
    	if (unsigned(INSIGNAL) > 999999) then --524288
    		n := 274877906944;
    		
    	 elsif (unsigned(INSIGNAL) > 999035) then
			n := 9913814010;
		 elsif (unsigned(INSIGNAL) > 982851) then
			n := 9871852532;
		 elsif (unsigned(INSIGNAL) > 981482) then
			n := 9804330019;
		 elsif (unsigned(INSIGNAL) > 966424) then
			n := 9611849937;
		 elsif (unsigned(INSIGNAL) > 944351) then
			n := 9537879160;
		 elsif (unsigned(INSIGNAL) > 912953) then
			n := 9461610371;
		 elsif (unsigned(INSIGNAL) > 912688) then
			n := 9410556041;
		 elsif (unsigned(INSIGNAL) > 912196) then
			n := 9379216285;
		 elsif (unsigned(INSIGNAL) > 906135) then
			n := 9286315049;
		 elsif (unsigned(INSIGNAL) > 904892) then
			n := 9253996868;
		 elsif (unsigned(INSIGNAL) > 896952) then
			n := 9250906526;
		 elsif (unsigned(INSIGNAL) > 894552) then
			n := 9235756888;
		 elsif (unsigned(INSIGNAL) > 893886) then
			n := 9179701751;
		 elsif (unsigned(INSIGNAL) > 873653) then
			n := 9054312453;
		 elsif (unsigned(INSIGNAL) > 867541) then
			n := 9018165296;
		 elsif (unsigned(INSIGNAL) > 862289) then
			n := 8910421837;
		 elsif (unsigned(INSIGNAL) > 848557) then
			n := 8894339503;
		 elsif (unsigned(INSIGNAL) > 839061) then
			n := 8751671859;
		 elsif (unsigned(INSIGNAL) > 829441) then
			n := 8725916970;
		 elsif (unsigned(INSIGNAL) > 825724) then
			n := 8578000643;
		 elsif (unsigned(INSIGNAL) > 821129) then
			n := 8562644650;
		 elsif (unsigned(INSIGNAL) > 803513) then
			n := 8317141692;
		 elsif (unsigned(INSIGNAL) > 803476) then
			n := 8055083446;
		 elsif (unsigned(INSIGNAL) > 789926) then
			n := 7982177929;
		 elsif (unsigned(INSIGNAL) > 782348) then
			n := 7928795054;
		 elsif (unsigned(INSIGNAL) > 770704) then
			n := 7657668274;
		 elsif (unsigned(INSIGNAL) > 766928) then
			n := 7256276878;
		 elsif (unsigned(INSIGNAL) > 753978) then
			n := 7222935207;
		 elsif (unsigned(INSIGNAL) > 749670) then
			n := 7086657408;
		 elsif (unsigned(INSIGNAL) > 747894) then
			n := 6995040390;
		 elsif (unsigned(INSIGNAL) > 727960) then
			n := 6928318485;
		 elsif (unsigned(INSIGNAL) > 726375) then
			n := 6896651768;
		 elsif (unsigned(INSIGNAL) > 726125) then
			n := 6822379281;
		 elsif (unsigned(INSIGNAL) > 721242) then
			n := 6778667507;
		 elsif (unsigned(INSIGNAL) > 719833) then
			n := 6742973520;
		 elsif (unsigned(INSIGNAL) > 713975) then
			n := 6541879748;
		 elsif (unsigned(INSIGNAL) > 707644) then
			n := 6539172682;
		 elsif (unsigned(INSIGNAL) > 701577) then
			n := 6442183870;
		 elsif (unsigned(INSIGNAL) > 686666) then
			n := 6381624176;
		 elsif (unsigned(INSIGNAL) > 678485) then
			n := 6256171393;
		 elsif (unsigned(INSIGNAL) > 676938) then
			n := 6183696389;
		 elsif (unsigned(INSIGNAL) > 668754) then
			n := 6056368880;
		 elsif (unsigned(INSIGNAL) > 646702) then
			n := 5985654468;
		 elsif (unsigned(INSIGNAL) > 641628) then
			n := 5849305861;
		 elsif (unsigned(INSIGNAL) > 638640) then
			n := 5583816050;
		 elsif (unsigned(INSIGNAL) > 635770) then
			n := 5438008431;
		 elsif (unsigned(INSIGNAL) > 610752) then
			n := 5315368894;
		 elsif (unsigned(INSIGNAL) > 581970) then
			n := 5110798839;
		 elsif (unsigned(INSIGNAL) > 580367) then
			n := 5096635673;
		 elsif (unsigned(INSIGNAL) > 559044) then
			n := 5093915977;
		 elsif (unsigned(INSIGNAL) > 546044) then
			n := 5017599682;
		 elsif (unsigned(INSIGNAL) > 544976) then
			n := 5011119098;
		 elsif (unsigned(INSIGNAL) > 543370) then
			n := 4890637806;
		 elsif (unsigned(INSIGNAL) > 535302) then
			n := 4866896153;
		 elsif (unsigned(INSIGNAL) > 510787) then
			n := 4843489355;
		 elsif (unsigned(INSIGNAL) > 506129) then
			n := 4827121923;
		 elsif (unsigned(INSIGNAL) > 499708) then
			n := 4807515914;
		 elsif (unsigned(INSIGNAL) > 490747) then
			n := 4742208894;
		 elsif (unsigned(INSIGNAL) > 467562) then
			n := 4587373797;
		 elsif (unsigned(INSIGNAL) > 459463) then
			n := 4543331759;
		 elsif (unsigned(INSIGNAL) > 458978) then
			n := 4465967354;
		 elsif (unsigned(INSIGNAL) > 436400) then
			n := 4374197336;
		 elsif (unsigned(INSIGNAL) > 434714) then
			n := 3708256143;
		 elsif (unsigned(INSIGNAL) > 423881) then
			n := 3435523188;
		 elsif (unsigned(INSIGNAL) > 414119) then
			n := 3300375060;
		 elsif (unsigned(INSIGNAL) > 395922) then
			n := 3232439388;
		 elsif (unsigned(INSIGNAL) > 376472) then
			n := 3128472128;
		 elsif (unsigned(INSIGNAL) > 343788) then
			n := 3100567928;
		 elsif (unsigned(INSIGNAL) > 333473) then
			n := 3048034733;
		 elsif (unsigned(INSIGNAL) > 323370) then
			n := 3040327557;
		 elsif (unsigned(INSIGNAL) > 293618) then
			n := 3034252307;
		 elsif (unsigned(INSIGNAL) > 292437) then
			n := 3028062954;
		 elsif (unsigned(INSIGNAL) > 285463) then
			n := 3014585845;
		 elsif (unsigned(INSIGNAL) > 252189) then
			n := 2945572321;
		 elsif (unsigned(INSIGNAL) > 250928) then
			n := 2752992534;
		 elsif (unsigned(INSIGNAL) > 249020) then
			n := 2742166773;
		 elsif (unsigned(INSIGNAL) > 231888) then
			n := 2712792884;
		 elsif (unsigned(INSIGNAL) > 212992) then
			n := 2436508300;
		 elsif (unsigned(INSIGNAL) > 185493) then
			n := 2243202382;
		 elsif (unsigned(INSIGNAL) > 156539) then
			n := 1947984893;
		 elsif (unsigned(INSIGNAL) > 156479) then
			n := 1680365555;
		 elsif (unsigned(INSIGNAL) > 140597) then
			n := 1588002201;
		 elsif (unsigned(INSIGNAL) > 123925) then
			n := 1584255982;
		 elsif (unsigned(INSIGNAL) > 122320) then
			n := 1563753600;
		 elsif (unsigned(INSIGNAL) > 118502) then
			n := 1511339358;
		 elsif (unsigned(INSIGNAL) > 116592) then
			n := 1437932423;
		 elsif (unsigned(INSIGNAL) > 101124) then
			n := 1281966170;
		 elsif (unsigned(INSIGNAL) > 84475) then
			n := 1249665062;
		 elsif (unsigned(INSIGNAL) > 68460) then
			n := 975335440;
		 elsif (unsigned(INSIGNAL) > 67586) then
			n := 829382579;
		 elsif (unsigned(INSIGNAL) > 58207) then
			n := 733570724;
		 elsif (unsigned(INSIGNAL) > 48191) then
			n := 723104500;
		 elsif (unsigned(INSIGNAL) > 35803) then
			n := 592730128;
		 elsif (unsigned(INSIGNAL) > 19015) then
			n := 543316251;
		 elsif (unsigned(INSIGNAL) > 14372) then
			n := 508675188;
		 elsif (unsigned(INSIGNAL) > 12817) then
			n := 412780979;
		 elsif (unsigned(INSIGNAL) > 11271) then
			n := 337011965;
		 elsif (unsigned(INSIGNAL) > 4813) then
			n := 83651497;


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











































