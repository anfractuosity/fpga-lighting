
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.MATH_REAL;

entity lighting is

port (
    CLK_50MHz: in std_logic;
    LED: out std_logic;
    STRIP1: out std_logic
);

end lighting;

architecture Behavioral of lighting is
    
    constant t0h : real := 35.0e-6;
    constant t1h : real := 0.9e-6;
    constant t0l : real := 0.9e-6;
    constant t1l : real := 35.0e-6;
    constant res : real := 50.0e-6;    
    
    signal data2: unsigned(23 downto 0) := "101111110101011111111111"; -- each LED is 24 bits, we output the same bitstream to all LEDs

    signal long: integer := 45;
    signal short: integer := 18;
    signal refresh: integer := 2500;


    signal ct: integer := 0;  -- Tracks the length of the high or low
    signal ct2: integer := 0; -- Keeps track if we are outputting a high
    signal ct3: integer := 0; -- Keeps track if we are outputting a high
    
    signal pulse: integer := 0; -- Keeps track if we are outputting a high


    begin

        Prescaler: process(CLK_50MHz)
        begin

            if rising_edge(CLK_50MHz) then
            
                ct <= ct + 1;
                
                if ct3 = 10 then
                    if ct > refresh then
                        ct <= 0;
                        ct3 <= 0;
                    else
                        STRIP1 <= '0';                    
                    end if;                
                else
                
                    if data2(ct2) = '0' then
                        pulse <= short;
                    else
                        pulse <= long;
                    end if;
                                
                    if ct > short+long then
                        ct <= 0;
                        ct2 <= ct2 + 1;
                                     
                        if ct2 = 24 then
                            ct2 <= 0;
                            ct3 <= ct3 + 1;
                        end if;
                                     
                    elsif ct > pulse then
                        STRIP1 <= '0';
                    else
                        STRIP1 <= '1';
                    end if;     
                                
                end if;    
                           
            end if;      
      
        end process Prescaler;

end Behavioral;
