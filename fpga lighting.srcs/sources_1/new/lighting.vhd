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

    constant size: integer := 60*5;  -- Tracks the length of the high or low
    type ram1 is array(0 to size*2) of std_logic_vector(0 to 23);
    signal RAM_1 : ram1 := (others => "111111110000000011111111");
    signal led_bits: std_logic_vector(0 to 23) := "000000000000000000000000"; -- each LED is 24 bits, we output the same bitstream to all LEDs
    
    signal long: integer := 113;         -- long duration, measured in clock pulses, 0.4us
    signal short: integer := 44;         -- short duration, measured in clock pulses, 0.85us
    signal refresh: integer := 6250;     -- refresh duration, when strip is driven low, 50us 
    
    signal clock_counter: integer := 0;    -- Counts clock pulses
    signal led_bit_counter: integer := 0;  -- Counts the Nth bit of an LED's colour data (24 bits total)
    signal led_counter: integer := 0;      -- LED number we're sending data for
    
    signal spi_counter: integer := 0;
    signal spi_frame_counter: integer := 0;
    signal spi_data: std_logic_vector(0 to 23) := "000000000000000000000000";
    signal off: bit := '0';

    begin

--        Arb: process(req_a, req_b)
--        begin
--            if req_a then 
--                grant_a <= '1'; 
--                grant_b <= '0'; 
--            elsif req_b then 
--                grant_a <= '0'; 
--                grant_b <= '1'; 
--            else 
--                grant_a <= '0'; 
--                grant_b <= '0';
--            end if;
--        end Process Arb;
        
--        SPI: process(spi_clk)
--        begin
--            if rising_edge(spi_clk) then
                
----                if spi_counter = 23 then
                
----                    if off = '0' then
----                        RAM_1(spi_frame_counter) <= spi_data(0 to 22) & spi_in  ;
----                    else
----                        RAM_1(spi_frame_counter+size) <= spi_data(0 to 22) & spi_in  ;
----                    end if;
                    
----                    if spi_frame_counter = size then
----                        spi_frame_counter <= 0;
----                        off <= off xor '1';
----                    else
----                        spi_frame_counter <= spi_frame_counter + 1; 
----                    end if;
                    
----                    spi_data <= "000000000000000000000000";
----                    spi_counter <= 0;
                    
----                else 
                        
----                    spi_data(spi_counter) <= spi_in;   
----                    spi_counter <= spi_counter + 1;
----                end if;
                
--            end if;
--        end Process SPI;
        

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
                                  
                -- Check if we've reached end of LED stript
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
