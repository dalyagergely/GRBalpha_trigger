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
        EMIN_CHOOSE         : in std_logic_vector (7 downto 0);  
        -- it will enable us to choose between pre-defined EMIN values
        EMAX_CHOOSE         : in std_logic_vector (7 downto 0);
        T_CHOOSE            : in std_logic_vector (2 downto 0);
        -- T is the integration time of the counter before the stack
        K_CHOOSE            : in std_logic_vector (7 downto 0);
        -- K is the multiplicator for the background i.e. we compare (S-B)^2 to K*B
        WIN_CHOOSE          : in std_logic_vector (3 downto 0);
        -- Choose the time window for signal and background accumulation
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

type shift_register is array (0 to 4095) of unsigned;

constant CLK_TIME_MS    : integer := 10; -- what is the clock frequency for our FPGA?
constant CLK_FREQ_MHZ   : integer := 1/CLK_TIME_MS;

signal EMIN         : std_logic_vector (15 downto 0);
signal EMAX         : std_logic_vector (15 downto 0);
signal K            : std_logic_vector (15 downto 0);
signal T            : std_logic_vector (9 downto 0);
signal SIGWIN       : std_logic_vector (15 downto 0);
signal BGWIN        : std_logic_vector (15 downto 0);
signal ticks        : unsigned;
signal millisecs    : unsigned;
signal counter      : unsigned;

signal stack : shift_register := others => 0;

variable accumulated_signal         : unsigned;
variable accumulated_background     : unsigned;
variable n                          : unsigned;
variable N                          : unsigned;
variable step_counter               : unsigned := 0;

signal stackfull    : std_logic := '0';
signal comp1        : std_logic := '0';
signal comp2        : std_logic := '0';

begin

    with T_CHOOSE select 
        T <= 32     when "000",
             64     when "001",
             128    when "010",
             256    when "011",
             512    when "100",
             1024   when "101",
             1024   when others;
             
    with WIN_CHOOSE select  -- signal windows in ms
        SIGWIN <= 32    when "0000",
                  64    when "0001",
                  128   when "0010",
                  256   when "0011",
                  512   when "0100",
                  1024  when "0101",
                  2048  when "0110",
                  4096  when "0111",
                  8196  when "1000",
                  16384 when "1001",
                  32768 when "1010",
                  65536 when "1011",
                  65536 when others;
                  
    with WIN_CHOOSE select  -- background windows in ms
        BGWIN <= 16384  when "0000" | "0001" | "0010" | "0011" | "0100",
                 32768  when "0101" | "0110" | "0111",
                 65536  when "1000" | "1001" | "1010" | "1011",
                 65536  when others;

-- So we have integration time options of 32-1024 ms, signal time windows of 32-65536 ms and 
-- background time windows of 16384-65536 ms. In this case the possible values of n are between 
-- 1-2048 and the possible values of N are 16-2048. Since we can not dynamically change the hardware 
-- of the stack, we should impement a stack with the maximal size, i.e. 2*2048=4096, and then 
-- dynamically change which parts are added to / subtracted from it.

              
    with K_CHOOSE select
        K <= ... 
     
    with EMIN_CHOOSE select
        EMIN <= ... 
     
    with EMAX_CHOOSE select
        EMAX <= ... 
        
        
-- I think that whenever we change one of the inputs of [EMIN_CHOOSE, EMAX_CHOOSE, T_CHOOSE, K_CHOOSE, WIN_CHOOSE], the stack should reset, to avoid some strange unwanted behaviour due to leftover count numbers somewhere, so:

    Reset_After_Change : process (EMIN_CHOOSE, EMAX_CHOOSE, T_CHOOSE, K_CHOOSE, WIN_CHOOSE) is
    begin
        counter := 0;
        stack := others => 0;
        stackfull <= '0';
        step_counter := 0;
        accumulated_signal := 0;
        accumulated_background := 0;
    end process Reset_After_Change;
        
        
    n := SIGWIN / T;
    N := BGWIN / T;
        
     
    Clk_Proc : process (CLK) is
    begin
       if rising_edge (CLK) then
           ticks <= ticks + 1;
           
           if EMIN < PH and EMAX > PH then  -- filter based on the energy
               counter <= counter + 1;
           end if;
           
           if ticks = CLK_FREQ_MHZ - 1 then  -- count the milliseconds based on clk frequency
               ticks <= 0;
               millisecs <= millisecs + 1;
           end if;   
            
           if millisecs = T then
               millisecs <= 0;  -- reset millisecs
               counter <= 0;  -- reset counter
           end if;    
             
       end if;
    end process Clk_Proc;
     
     
    Stepping : process (millisecs) is
    begin
       if millisecs = T then
           stack    <=  shift_right(stack, 1); -- shift to the right by one bit
           stack(0) <=  counter;
           step_counter := step_counter + 1;
       end if;            
    end process Stepping;
    
    
    Stack_Full_Check : process (step_counter) is
    begin
        if step_counter = n+N:
            stackfull <= '1';
        end if;
    end process Stack_Full_Check;
    
     
    S_And_B_Accumulation : process (step_counter) is
    begin
       accumulated_signal := accumulated_signal + stack(0) - stack(n-1)
       accumulated_background := accumulated_background + stack(n) - stack(n+N-1)
    end process S_And_B_Accumulation;
     
     
    Comparison1 : process (step_counter) is
       variable S, B, SmBsq : unsigned;
    begin
       S = accumulated_signal / n;
       B = accumulated_background / N;
       SmBsq = (S - B) ** 2;
            
       if SmBsq > K*B then
           comp1 <= '1';
       else
           comp1 <= '0';
       end if;            
    end process Comparison1;       
     
     
    Comparison2 : process (step_counter) is
       variable S, B : unsigned;
    begin
        S = accumulated_signal / n;
        B = accumulated_signal / N;
        
        if S > B then
            comp2 <= '1';
        else
            comp2 <= '0';
        end if;
    end process Comparison2;
    
    
    Triggering : process (step_counter) is
        if (comp1 = '1' and comp2 = '1' and CLEAR = '0' and stackfull = '1') then
            TRIGGER <= '1';
            -- reset the stack, the counter indicating whether the stack is full, accumulated_signal and accumulated_background
            counter := 0;
            stack := others => 0;
            stackfull <= '0';
            step_counter := 0;
            accumulated_signal := 0;
            accumulated_background := 0;
        else
            TRIGGER <= '0';
        end if;
    end process Triggering;



end TrigArch;
        

