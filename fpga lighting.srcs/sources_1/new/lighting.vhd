
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.MATH_REAL;

entity lighting is

port (
    CLK_50MHz: in std_logic;
    LED: out std_logic
);

end lighting;

architecture Behavioral of lighting is
    
    constant t0h : real := 35.0e-6;
    constant t1h : real := 0.9e-6;
    constant t0l : real := 0.9e-6;
    constant t1l : real := 35.0e-6;
    constant res : real := 50.0e-6;    
    
    signal data2: unsigned(23 downto 0) := "101111110101011111111111"; -- each LED is 24 bits, we output the same bitstream to all LEDs

    signal long: integer := 25000000;
    signal short: integer := 1000000;

    signal ct: integer := 0;  -- Tracks the length of the high or low
    signal ct2: integer := 0; -- Keeps track if we are outputting a high
 
    begin

        Prescaler: process(CLK_50MHz)
        begin

            if rising_edge(CLK_50MHz) then
           
                ct <= ct + 1; -- tracking length of pulse 
                
                if ct2 = 0 then
                
                    -- outputting the high part of the waveform
                    
                    LED <= '1';
                
                    if data2(0) = '0' then
                        if ct > short then
                            ct2 <= 1;
                            LED <= '0';
                            ct <= 0;
                        end if;
                    else
                        if ct > long then
                            ct2 <= 1;
                            LED <= '0';
                            ct <= 0;                            
                        end if;
                    end if;    
                                        
                else 
                
                    -- outputting the low part of the waveform
                   
                    LED <= '0';

                    if data2(0) = '0' then
                        if ct > long then
                            ct <= 0;
                            ct2 <= 0;
                            -- rotate, to output next bit
                            data2 <= rotate_right(data2,1);
                        end if;
                    else
                        if ct > short then
                            ct <= 0;
                            ct2 <= 0;
                            -- rotate, to output next bit
                            data2 <= rotate_right(data2,1);
                        end if;
                    end if;  
                                  
                end if;    
            
            end if;
            
      
        end process Prescaler;

end Behavioral;
