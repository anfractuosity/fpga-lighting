library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.MATH_REAL;

entity lighting is

port (
    clk: in std_logic;
    strip_1: out std_logic
);

end lighting;

architecture Behavioral of lighting is
    
    constant size: integer := 60 * 4;         -- Number of LEDs
    constant tp_clock: real := 1.0 / 125.0e6; -- Get time period, for 125MHz clock
    
    signal data2: unsigned(23 downto 0) := "000000000000000011111111"; -- each LED is 24 bits, we output the same bitstream to all LEDs

    signal long: integer := integer(0.85e-6 / tp_clock);       -- long duration
    signal short: integer := integer(0.4e-6 / tp_clock);       -- short duration
    signal refresh: integer := integer((74.0e-6) / tp_clock);  -- refresh duration, when strip is driven low, MUST be ABOVE 50uS
     
    signal clock_counter: integer := 0;    -- Counts clock pulses
    signal led_bit_counter: integer := 0;  -- Counts the Nth bit of an LED's colour data (24 bits total)
    signal led_counter: integer := 0;      -- LED number we're sending data for    
    signal pulse: integer := 0; -- Keeps track if we are outputting a high


    begin

        Prescaler: process(clk)
        begin

            if rising_edge(clk) then
            
                clock_counter <= clock_counter + 1;
                
                if led_counter = size then
                    if clock_counter > refresh then
                        clock_counter <= 0;
                        led_counter <= 0;
                    else
                        strip_1 <= '0';                    
                    end if;                
                else
                
                    if data2(led_bit_counter) = '0' then
                        pulse <= short;
                    else
                        pulse <= long;
                    end if;
                                
                    if clock_counter > short+long then
                    
                        clock_counter <= 0;
                        led_bit_counter <= led_bit_counter + 1;
                                     
                        if led_bit_counter = 23 then
                            led_bit_counter <= 0;
                            led_counter <= led_counter + 1;
                        end if;
                                     
                    elsif clock_counter > pulse then
                        strip_1 <= '0';
                    else
                        strip_1 <= '1';
                    end if;     
                                
                end if;    
                           
            end if;      
      
        end process Prescaler;

end Behavioral;
