-- GRBalpha trigger algorithm
-- Written by Gergely Dálya
-- dalyag@caesar.elte.hu

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity TrigCircuit is
    port (
        -- we need to figure out what will be the possible values for EMIN, EMAX, PH and K
        EMIN_CHOOSE         : in std_logic_vector (3 downto 0);  
        -- it will enable us to choose between pre-defined EMIN values
        EMAX_CHOOSE         : in std_logic_vector (3 downto 0);
        T_CHOOSE            : in std_logic_vector (3 downto 0);
        -- T is the integration time of the counter before the stack
        K_CHOOSE            : in std_logic_vector (3 downto 0);
        -- K is the multiplicator for the background i.e. we compare (S-B)^2 to K*B
        PH                  : in std_logic_vector (7 downto 0);
        -- what will be the exact output of the gamma detector?
        CLK                 : in std_logic;
        TRIGGER             : out std_logic
        -- either '1': there is a GRB, or '0': there is no GRB
    );
end TrigCircuit;



architecture TrigArch of TrigCircuit is

constant CLK_TIME_MS : integer := 10; -- what is the clock frequency for our FPGA?
constant CLK_FREQ_MHZ : integer := 1/CLK_TIME_MS;

-- signal EMIN : std_logic_vector (...);
-- signal EMAX : std_logic_vector (...);
-- signal K : std_logic_vector (...);
signal T            : std_logic_vector (15 downto 0);
signal ticks        : integer;
signal millisecs    : integer;
signal counter      : std_logic_vector (15 downto 0);  -- what count numbers do we realistically expect?

begin

    with T_CHOOSE select 
        T <= 32     when "0000",
             64     when "0001",
             128    when "0010",
             256    when "0011",
             512    when "0100",
             1024   when "0101",
             2048   when "0110",
             4096   when "0111",
             8196   when "1000",
             16384  when "1001",
             32768  when "1010",
             65536  when "1011",
             65536  when others;
        
 -- with K_CHOOSE select
     -- K <= ... 
     
 -- with EMIN_CHOOSE select
     -- EMIN <= ... 
     
 -- with EMAX_CHOOSE select
     -- EMAX <= ... 
     
     Clk_Proc : process (CLK) is
     begin
        if rising_edge (CLK) then
            ticks <= ticks + 1;
            
            if ticks = CLK_TIME_MHZ - 1 then  -- count the milliseconds based on clk frequency
                ticks <= 0;
                millisecs <= millisecs + 1;
            end if;   
            
            if millisecs = T then
                -- step everything in the counter
                -- ...
                -- reset millisecs
                millisecs <= 0;
                -- reset counter
                counter <= '0';
            end if;    
             
        end if;
     end process Clk_Proc;



end TrigArch;
        

