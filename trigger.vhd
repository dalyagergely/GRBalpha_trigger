-- GRBalpha trigger algorithm
-- Written by Gergely Dálya, 2020
-- dalyag@caesar.elte.hu

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity TrigCircuit is
    port (
        EMIN_CHOOSE         : in std_logic_vector (7 downto 0);  
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
        EMIN_OUT            : out std_logic_vector (7 downto 0);
        EMAX_OUT            : out std_logic_vector (7 downto 0);
        T_OUT               : out std_logic_vector (2 downto 0);
        K_OUT               : out std_logic_vector (7 downto 0);
        WIN_OUT             : out std_logic_vector (3 downto 0)
    );
end TrigCircuit;



architecture TrigArch of TrigCircuit is

type shift_register is array (0 to 4096) of unsigned (13 downto 0); -- array size is the max possible value of n+N+1. Each element have to have the same size as counter.

constant CLK_TIME_MS    : integer := 10; -- what is the clock frequency for our FPGA?
constant CLK_FREQ_MHZ   : integer := 1/CLK_TIME_MS;

signal EMIN         : std_logic_vector (15 downto 0);
signal EMAX         : std_logic_vector (15 downto 0);
signal T            : unsigned (9 downto 0);
signal SIGWIN       : unsigned (15 downto 0);
signal BGWIN        : unsigned (15 downto 0);
signal K            : unsigned (7 downto 0);
signal counter      : unsigned (13 downto 0);

signal stack : shift_register := (others => 0);

-- variables cannot be declared here, also the compiler isn't case sensitive, so I changed N to NN  - fg
--signal accumulated_signal         : unsigned (19 downto 0);
--signal accumulated_background     : unsigned (19 downto 0);
--signal n                          : unsigned (10 downto 0);  -- max value: 2048
--signal NN                         : unsigned (10 downto 0);  -- max value: 2048
--signal step_counter               : unsigned (11 downto 0) := 0;  -- have to have size>=n+N
signal S            : unsigned (19 downto 0);
signal B            : unsigned (19 downto 0);

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
                  8192  when "1000",
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


-- took these out to check synthesis - fg
     
--    with EMIN_CHOOSE select  -- Energy range ~ 10-10.000 keV
--        EMIN <= ...
     
--    with EMAX_CHOOSE select
--        EMAX <= ... 
        
    K <= unsigned(K_CHOOSE);
    
    EMIN_OUT <= EMIN_CHOOSE;
    EMAX_OUT <= EMAX_CHOOSE;
    K_OUT    <= K_CHOOSE;
    T_OUT    <= T_CHOOSE;
    WIN_OUT  <= WIN_CHOOSE;
        
        
-- I think that whenever we change one of the inputs of [EMIN_CHOOSE, EMAX_CHOOSE, T_CHOOSE, K_CHOOSE, WIN_CHOOSE], the stack should reset, to avoid some strange unwanted behaviour due to leftover count numbers somewhere, so:

--    Reset_After_Change : process (EMIN_CHOOSE, EMAX_CHOOSE, T_CHOOSE, K_CHOOSE, WIN_CHOOSE) is
--    begin
--        counter <= 0;
--        stack <= (others => 0);  
--        stackfull <= '0';
--        step_counter <= 0;
--        accumulated_signal <= 0;
--        accumulated_background <= 0;
--    end process Reset_After_Change;
        
        
--    n  <= to_unsigned(to_integer(SIGWIN) / to_integer(T), 11);  -- had problems with "=" operator - fg
--    NN <= to_unsigned(to_integer(BGWIN) / to_integer(T), 11);
        
     
    Clk_Proc : process (CLK, EMIN, EMAX, SIGWIN, BGWIN, T, K) is
        variable ticks          : unsigned (7 downto 0);  -- for size we should know CLK_FREQ_MHZ
        variable millisecs      : unsigned (9 downto 0);  -- have to have at least the same size as T
        variable step_counter   : unsigned (11 downto 0) := 0;  -- have to have size>=n+N
    begin
    
        if EMIN'event or EMAX'event or SIGWIN'event or BGWIN'event or T'event or K'event or TRIGGER = '1' then
            ticks := 0;
            millisecs := 0;
            step_counter := 0;
            stackfull <= '0';
            stack <= (others => 0);
        end if;
    
        if rising_edge (CLK) then
            ticks := ticks + 1;
           
            if EMIN < PH and EMAX > PH then  -- filter based on the energy
                counter <= counter + 1;
            end if;
           
            if ticks = CLK_FREQ_MHZ - 1 then  -- count the milliseconds based on clk frequency
                ticks := 0;
                millisecs := millisecs + 1;
            end if;   
            
            if millisecs = T then
                stack(0) <=  counter;
                for i in 4096 downto 1 loop -- shift_right does not work here, it's for unsigned values - fg
	                stack(i) <= stack(i-1);
                end loop;
                step_counter := step_counter + 1;
                millisecs := 0;
                counter <= 0;
            end if;   
            
            if step_counter = (SIGWIN/T) + (BGWIN/T) then   -- Stack full check: step_counter = n+NN
                stackfull <= '1';
            end if;
             
        end if;
    end process Clk_Proc;
     
     

    
     
    S_And_B_Accumulation : process (stack) is
        Variable n, NN      : unsigned (10 downto 0);
        Variable accumulated_signal, accumulated_background : unsigned (19 downto 0);
    begin
        n := SIGWIN / T;
        NN := BGWIN / T;
        accumulated_signal <= accumulated_signal + stack(0) - stack(n);  
        accumulated_background <= accumulated_background + stack(n) - stack(n+NN);
        S <= accumulated_signal / n;
        B <= accumulated_background / NN;
    end process S_And_B_Accumulation;
     
     
    Comparison1 : process (S, B, K) is
       variable SmBsq       : unsigned (19 downto 0);
    begin
       SmBsq := to_unsigned(to_integer(S - B) * to_integer(S - B), 20); -- problems with "**" operator - fg
            
       if SmBsq > K*B then
           comp1 <= '1';
       else
           comp1 <= '0';
       end if;            
    end process Comparison1;       
     
     
    Comparison2 : process (S, B) is
    begin 
        if S > B then
            comp2 <= '1';
        else
            comp2 <= '0';
        end if;
    end process Comparison2;
    
    
    Triggering : process (comp1, comp2, stackfull, CLEAR) is
    begin
        if (comp1 = '1' and comp2 = '1' and CLEAR = '0' and stackfull = '1') then
            TRIGGER <= '1';
        else
            TRIGGER <= '0';
        end if;
    end process Triggering;



end TrigArch;
