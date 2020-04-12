library IEEE;

use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.MATH_REAL;
USE ieee.numeric_std.ALL; 

entity lighting is

port (
    spi_clk: in std_logic;
    spi_in: in std_logic;
    clk: in std_logic;
    strip_1: out std_logic
);

end lighting;

architecture Behavioral of lighting is

    constant tp_clock: time := 1 sec / 125e6; -- Get time period, for 125MHz clock
    constant size: integer := 60*5;           -- Number of LEDs
    
    type ram1 is array(0 to size*2) of std_logic_vector(0 to 23);
    signal RAM_1 : ram1 := (others => "111111110000000011111111");
    signal led_bits: std_logic_vector(0 to 23) := "000000000000000000000000"; -- each LED is 24 bits, we output the same bitstream to all LEDs
    
    signal long: integer := time(0.4us) / tp_clock;         -- long duration, measured in clock pulses, 0.4us
    signal short: integer := time(0.85us) / tp_clock;       -- short duration, measured in clock pulses, 0.85us
    signal refresh: integer := time(50us) / tp_clock;     -- refresh duration, when strip is driven low, 50us 
    
    signal clock_counter: integer := 0;    -- Counts clock pulses
    signal led_bit_counter: integer := 0;  -- Counts the Nth bit of an LED's colour data (24 bits total)
    signal led_counter: integer := 0;      -- LED number we're sending data for
    signal spi_counter: integer := 0;
    signal spi_frame_counter: integer := 0;
    signal spi_data: std_logic_vector(0 to 23) := "000000000000000000000000";
    signal off: bit := '0';

    begin
        
        SPI: process(spi_clk)
        begin
            if rising_edge(spi_clk) then
                
                if spi_counter = 23 then
                
                    -- We have a double buffer, write to different part of BRAM
                    if off = '0' then
                        RAM_1(spi_frame_counter) <= spi_data(0 to 22) & spi_in  ;
                    else
                        RAM_1(spi_frame_counter+size) <= spi_data(0 to 22) & spi_in  ;
                    end if;
                    
                    -- Check if we've reached end of data from SPI
                    if spi_frame_counter = size then
                        spi_frame_counter <= 0;
                        off <= off xor '1';
                    else
                        spi_frame_counter <= spi_frame_counter + 1; 
                    end if;
                    
                    -- Clear variable storing data from SPI
                    spi_data <= "000000000000000000000000";
                    spi_counter <= 0;
                else 
                    -- Capture 24 bits from SPI
                    spi_data(spi_counter) <= spi_in;   
                    spi_counter <= spi_counter + 1;
                end if;
                
            end if;
        end Process SPI;
        

        Prescaler: process(clk)
        begin
            if rising_edge(clk) then
            
                -- Counting clock edges
                clock_counter <= clock_counter + 1;
            
                if off = '0' then
                    led_bits <= RAM_1(led_counter+size) ;
                else
                    led_bits <= RAM_1(led_counter)  ;
                end if;
                                  
                -- Check if we've reached end of LED strip
                if led_counter = size then
                    -- Check if we have finished refresh duration
                    if clock_counter > refresh then
                        clock_counter <= 0;
                        led_counter <= 0;
                    else
                        strip_1 <= '0';                    
                    end if;                
                else
                    -- Check if at the end of a WS2812B '0' or '1'
                    if clock_counter > short+long then
                        if led_bit_counter = 23 then
                            led_bit_counter <= 0;
                            led_counter <= led_counter + 1;
                        else 
                            led_bit_counter <= led_bit_counter + 1; 
                        end if;
                        clock_counter <= 0;
                    elsif led_bits(led_bit_counter) = '0' and clock_counter > short then
                        strip_1 <= '0';
                    elsif led_bits(led_bit_counter) = '1' and clock_counter > long then
                        strip_1 <= '0';
                    else
                        strip_1 <= '1';
                    end if;     
                                
                end if;        
            end if;      
        end process Prescaler;

end Behavioral;
