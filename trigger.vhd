-- GRBalpha trigger algorithm
-- Written by Gergely Dálya
-- dalyag@caesar.elte.hu

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity TrigCircuit is
    port (
        -- we need to figure out what will be the possible values for EMIN, EMAX, PH and K
        EMIN_CHOOSE         : in std_logic_vector (11 downto 0);  
        -- it will enable us to choose between pre-defined EMIN values
        EMAX_CHOOSE         : in std_logic_vector (11 downto 0);
        T_CHOOSE            : in std_logic_vector (3 downto 0);
        -- T is the integration time of the counter before the stack
        K_CHOOSE            : in std_logic_vector (7 downto 0);
        -- K is the multiplicator for the background i.e. we compare (S-B)^2 to K*B
        PH                  : in std_logic_vector (11 downto 0);
        -- The output of the gamma detector is 12 bit ADC data
        CLK                 : in std_logic;
        CLEAR               : in std_logic := '0';
        -- if CLEAR='1', it clears the GRB flag output (i.e. TRIGGER)
        
        TRIGGER             : out std_logic;
        -- either '1': there is a GRB, or '0': there is no GRB
        WHICH_ACTIVE        : out std_logic_vector (11 downto 0)
        -- Ohno-san: "It would be good if the output signal which tells which trigger block(s) is activated. We can prepare multiple trigger judgement blocks in parallel. But it should be discussed which kind of trigger judgement conditions should be considered as the parallel processing."
        -- What are the important parameters to write out at a trigger? EMIN, EMAX, T and K?
    );
end TrigCircuit;



architecture TrigArch of TrigCircuit is

type shift_register is array (0 to 15) of unsigned;  -- how large should the stack be?

constant CLK_TIME_MS    : integer := 10; -- what is the clock frequency for our FPGA?
constant CLK_FREQ_MHZ   : integer := 1/CLK_TIME_MS;

-- signal EMIN : std_logic_vector (...);
-- signal EMAX : std_logic_vector (...);
-- signal K : std_logic_vector (...);
signal T            : std_logic_vector (15 downto 0);
signal ticks        : unsigned;
signal millisecs    : unsigned;
signal counter      : unsigned;  -- what count numbers do we realistically expect?

signal stack : shift_register := others => 0;

variable accumulated_signal         : integer;
variable accumulated_background     : integer;

signal comp1        : std_logic := '0'
signal comp2        : std_logic := '0'

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
           counter <= counter + unsigned(PH)
           
           if ticks = CLK_TIME_MHZ - 1 then  -- count the milliseconds based on clk frequency
               ticks <= 0;
               millisecs <= millisecs + 1;
           end if;   
            
           if millisecs = T then
               -- reset millisecs
               millisecs <= 0;
               -- reset counter
               counter <= 0;
           end if;    
             
       end if;
    end process Clk_Proc;
     
     
    Stepping : process (millisecs) is
    begin
       if millisecs = T then
           stack    <=  shift_right(stack, 1); -- shift to the right by one bit
           stack(0) <=  counter;
       end if;            
    end process Stepping;
     
     
    S_And_B_Accumulation : process (millisecs) is
    begin
       if millisecs = T then
           if stack(15) /= 0:  -- should have a more clever way to check whether the stack is full
               accumulated_signal := accumulated_signal + stack(0) - stack(3)
               accumulated_background := accumulated_background + stack(4) - stack(15)
               -- how large should be the register for the signal and the noise?
           end if;
       end if;
    end process S_And_B_Accumulation;
     
     
    Comparison1 : process (millisecs) is
       variable S, B, SmBsq : integer;
    begin
       if millisecs = T then
           S = accumulated_signal / 4;
           B = accumulated_background / 12;
           SmBsq = (S - B) ** 2;
            
           if SmBsq > K*B then
               comp1 <= '1';
           else
               comp1 <= '0';
           end if;
            
       end if;
    end process Comparison1;       
     
     
    Comparison2 : process (millisecs) is
       variable S, B : integer;
    begin
        S = accumulated_signal / 4;
        B = accumulated_signal / 12;
        
        if S > B then
            comp2 <= '1';
        else
            comp2 <= '0';
        end if;
    end process Comparison2;
    
    
    Triggering : process (millisecs) is -- should have a more clever way to check whether the stack is full
        if (comp1 = '1' and comp2 = '1' and CLEAR = '0' and stack(15) /= 0) then
            TRIGGER <= '1'
        else
            TRIGGER <= '0'
        end if;
    end process Triggering;



end TrigArch;
        

