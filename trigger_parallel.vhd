-- GRBalpha trigger algorithm
-- Written by Gergely Dálya and Gergely Friss, 2020
-- dalyag@caesar.elte.hu

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity TrigCircuit is
    port (
        EMIN_CHOOSE         : inout std_logic_vector (7 downto 0);  
        EMAX_CHOOSE         : inout std_logic_vector (7 downto 0);
        T_CHOOSE            : inout std_logic_vector (2 downto 0);
        -- T is the integration time of the counter before the stack
        K_CHOOSE            : inout unsigned (7 downto 0);
        -- K is the multiplicator for the background i.e. we compare (S-B)^2 to K*B
        WIN_CHOOSE          : inout std_logic_vector (3 downto 0);
        -- Choose the time window for signal and background accumulation
        PH                  : in std_logic_vector (11 downto 0);
        -- The output of the gamma detector is 12 bit ADC data
        CLK                 : in std_logic;
        CLEAR               : in std_logic := '0';
        -- if CLEAR='1', it clears the GRB flag output (i.e. TRIGGER)       
        TRIGGER             : out std_logic;
        WHICH				: out std_logic_vector (1 downto 0)
        -- either '1': there is a GRB, or '0': there is no GRB
--        EMIN_OUT            : out std_logic_vector (7 downto 0);
--        EMAX_OUT            : out std_logic_vector (7 downto 0);
--        T_OUT               : out std_logic_vector (2 downto 0);
--        K_OUT               : out std_logic_vector (7 downto 0);
--        WIN_OUT             : out std_logic_vector (3 downto 0)
    );
end TrigCircuit;



architecture TrigArch of TrigCircuit is

type shift_register is array (0 to 4095) of unsigned (13 downto 0); 
constant CLK_FREQ_KHZ   : integer := 12000;

signal EMIN         : std_logic_vector (15 downto 0);
signal EMAX         : std_logic_vector (15 downto 0);
signal T            : unsigned (9 downto 0);
signal K            : unsigned (7 downto 0);
signal counter      : unsigned (13 downto 0);

signal stack : shift_register := (others => to_unsigned(0, 14));


signal SA           : unsigned (19 downto 0);
signal BA           : unsigned (19 downto 0);
signal SB           : unsigned (19 downto 0);
signal BB           : unsigned (19 downto 0);
signal SC           : unsigned (19 downto 0);
signal BC           : unsigned (19 downto 0);

signal stackfull    : std_logic := '0';
signal sbreset      : std_logic := '0';
signal comp1A       : std_logic := '0';
signal comp2A       : std_logic := '0';
signal comp1B       : std_logic := '0';
signal comp2B       : std_logic := '0';
signal comp1C       : std_logic := '0';
signal comp2C       : std_logic := '0';
signal trigback     : std_logic := '0';

begin

    with T_CHOOSE select 
        T <= to_unsigned(32, 10)     when "000",
             to_unsigned(64, 10)     when "001",
             to_unsigned(128, 10)    when "010",
             to_unsigned(256, 10)    when "011",
             to_unsigned(512, 10)    when "100",
             to_unsigned(1024, 10)   when "101",
             to_unsigned(1024, 10)   when others;

        
    K <= K_CHOOSE;
    

     
    Clk_Proc : process (CLK, EMIN, EMAX, T, K, trigback) is
        variable ticks                  : unsigned (13 downto 0) := to_unsigned(0, 14);  -- for size we should know CLK_FREQ_KHZ
        variable millisecs              : unsigned (9 downto 0) := to_unsigned(0, 10);  -- have to have at least the same size as T
        variable step_counter           : unsigned (11 downto 0) := to_unsigned(0, 12);  -- have to have size>=n+N
        variable EMIN_old, EMAX_old     : std_logic_vector (15 downto 0);
        variable T_old                  : unsigned (9 downto 0);
        variable K_old                  : unsigned (7 downto 0);
    begin
    

    
        if rising_edge(CLK) then

			if (EMIN /= EMIN_old) or (EMAX /= EMAX_old) or (T /= T_old) or (K /= K_old) or trigback = '1' then
		        ticks := to_unsigned(0, 14);
		        millisecs := to_unsigned(0, 10);
		        step_counter := to_unsigned(0, 12);
		        stackfull <= '0';
		        stack <= (others => to_unsigned(0, 14));
		        counter <= to_unsigned(0, 14);
				sbreset <= '1';
			end if;


            ticks := ticks + 1;
           
            if EMIN < PH and EMAX > PH then  -- filter based on the energy
                counter <= counter + 1;
            end if;
           
            if ticks = CLK_FREQ_KHZ - 1 then  -- count the milliseconds based on clk frequency
                ticks := to_unsigned(0, 14);
                millisecs := millisecs + 1;
            end if;   
            
            if millisecs = T then
                stack(0) <=  counter;
                for i in 4095 downto 1 loop
	                stack(i) <= stack(i-1);
                end loop;
                step_counter := step_counter + 1;
                millisecs := to_unsigned(0, 10);
                counter <= to_unsigned(0, 14);
            end if;   
            
            if step_counter*T = 73732 then   -- Stack full check: step_counter = n+NN; the highest SIGWIN & BGWIN values have to be used, i.e. 8196+65536=73732
                stackfull <= '1';
            end if;
             
        end if;
        
        EMIN_old    := EMIN;
        EMAX_old    := EMAX;
        T_old       := T;
        K_old       := K;
        
    end process Clk_Proc;
     
     

    
     
    S_And_B_Accumulation_A : process (stack, sbreset) is
        Variable n, NN      : unsigned (15 downto 0);
        Variable accumulated_signal, accumulated_background : unsigned (19 downto 0) := to_unsigned(0, 20);
    begin
    
        if sbreset = '1' then
            accumulated_signal := to_unsigned(0, 20);
            accumulated_background := to_unsigned(0, 20); 
        end if;
        
        n := shift_right(to_unsigned(32, 16), 5+to_integer(unsigned(T_CHOOSE)));
        NN := shift_right(to_unsigned(16384, 16), 5+to_integer(unsigned(T_CHOOSE)));
        accumulated_signal := accumulated_signal + stack(0) - stack(to_integer(n));  
        accumulated_background := accumulated_background + stack(to_integer(n)) - stack(to_integer(n+NN));
        SA <= accumulated_signal / n;
		BA <= accumulated_background / NN;        
    end process S_And_B_Accumulation_A;
     
     
    Comparison1_A : process (SA, BA, K) is
       variable SmBsq       : unsigned (19 downto 0);
    begin
       SmBsq := to_unsigned(to_integer(SA - BA) * to_integer(SA - BA), 20); 
       if SmBsq > K*BA then
           comp1A <= '1';
       else
           comp1A <= '0';
       end if;
    end process Comparison1_A;       
     
     
    Comparison2_A : process (SA, BA) is
    begin 
        if SA > BA then
            comp2A <= '1';
        else
            comp2A <= '0';
        end if;
    end process Comparison2_A;
    
    
    S_And_B_Accumulation_B : process (stack, sbreset) is
        Variable n, NN      : unsigned (15 downto 0);
        Variable accumulated_signal, accumulated_background : unsigned (19 downto 0) := to_unsigned(0, 20);
    begin
    
        if sbreset = '1' then
            accumulated_signal := to_unsigned(0, 20);
            accumulated_background := to_unsigned(0, 20); 
        end if;
        
        n := shift_right(to_unsigned(1024, 16), 5+to_integer(unsigned(T_CHOOSE)));
        NN := shift_right(to_unsigned(32768, 16), 5+to_integer(unsigned(T_CHOOSE)));
        accumulated_signal := accumulated_signal + stack(0) - stack(to_integer(n));  
        accumulated_background := accumulated_background + stack(to_integer(n)) - stack(to_integer(n+NN));
        SB <= accumulated_signal / n;
		BB <= accumulated_background / NN;        
    end process S_And_B_Accumulation_B;
          
    Comparison1_B : process (SB, BB, K) is
       variable SmBsq       : unsigned (19 downto 0);
    begin
       SmBsq := to_unsigned(to_integer(SB - BB) * to_integer(SB - BB), 20); 
       if SmBsq > K*BB then
           comp1B <= '1';
       else
           comp1B <= '0';
       end if;
    end process Comparison1_B;       
         
    Comparison2_B : process (SB, BB) is
    begin 
        if SB > BB then
            comp2B <= '1';
        else
            comp2B <= '0';
        end if;
    end process Comparison2_B;
    
    
    S_And_B_Accumulation_C : process (stack, sbreset) is
        Variable n, NN      : unsigned (15 downto 0);
        Variable accumulated_signal, accumulated_background : unsigned (19 downto 0) := to_unsigned(0, 20);
    begin
    
        if sbreset = '1' then
            accumulated_signal := to_unsigned(0, 20);
            accumulated_background := to_unsigned(0, 20); 
        end if;
        
        n := shift_right(to_unsigned(8196, 16), 5+to_integer(unsigned(T_CHOOSE)));
        NN := shift_right(to_unsigned(65536, 16), 5+to_integer(unsigned(T_CHOOSE)));
        accumulated_signal := accumulated_signal + stack(0) - stack(to_integer(n));  
        accumulated_background := accumulated_background + stack(to_integer(n)) - stack(to_integer(n+NN));
        SC <= accumulated_signal / n;
		BC <= accumulated_background / NN;        
    end process S_And_B_Accumulation_C;
          
    Comparison1_C : process (SC, BC, K) is
       variable SmBsq       : unsigned (19 downto 0);
    begin
       SmBsq := to_unsigned(to_integer(SC - BC) * to_integer(SC - BC), 20); 
       if SmBsq > K*BC then
           comp1C <= '1';
       else
           comp1C <= '0';
       end if;
    end process Comparison1_C;       
         
    Comparison2_C : process (SC, BC) is
    begin 
        if SC > BC then
            comp2C <= '1';
        else
            comp2C <= '0';
        end if;
    end process Comparison2_C;
    
    
    Triggering : process (comp1A, comp2A, comp1B, comp2B, comp1C, comp2C, stackfull, CLEAR) is
    begin
        if (comp1A = '1' and comp2A = '1' and CLEAR = '0' and stackfull = '1') then
            TRIGGER <= '1';
            trigback <= '1';
            WHICH <= 00;
        elsif (comp1B = '1' and comp2B = '1' and CLEAR = '0' and stackfull = '1') then
            TRIGGER <= '1';
            trigback <= '1';
            WHICH <= 01;
        elsif (comp1C = '1' and comp2C = '1' and CLEAR = '0' and stackfull = '1') then
            TRIGGER <= '1';
            trigback <= '1';
            WHICH <= 10;
        else
            TRIGGER <= '0';
            trigback <= '0';
        end if;
    end process Triggering;


end TrigArch;
