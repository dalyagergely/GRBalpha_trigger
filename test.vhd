-- Test code for FPGA efficiency
-- Written by Gergely Dálya, 2020
-- dalyag@caesar.elte.hu

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use ieee.math_real.all;

entity TestCircuit is
	port (
		INSIGNAL	: in std_logic_vector (19 downto 0);
		THRESHOLD	: in std_logic_vector (39 downto 0);
		OUTSIGNAL	: out std_logic := '0'
	);
end TestCircuit;


architecture TestArch of TestCircuit is

begin

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

	
	Multip_Proc_B : process (INSIGNAL) is
		variable n	: unsigned (10 downto 0) := 256;
		variable NN : unsigned (10 downto 0) := 1024;
	begin
		if (unsigned(INSIGNAL)*unsigned(INSIGNAL)*NN > unsigned(THRESHOLD)*n) then
			OUTSIGNAL <= '1';
		else
			OUTSIGNAL <= '0';
		end if;
	end process Multip_Proc_B;
	-- Total LUTs: 61


end TestArch;
