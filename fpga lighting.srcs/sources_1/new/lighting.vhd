
library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.MATH_REAL;

USE ieee.numeric_std.ALL; 



entity lighting is

port (
    SPI_CLK: in std_logic;
    SPI_DATA_IN: in std_logic;
    CLK_50MHz: in std_logic;
    LED: out std_logic;
    STRIP1: out std_logic
);

end lighting;

architecture Behavioral of lighting is

    constant size: integer := 60*5*3;  -- Tracks the length of the high or low
        
    type ram1 is array(0 to size*2) of std_logic_vector(0 to 23);
    signal RAM_1 : ram1 := (others => "000000000000000011111111");
    
    --type ram2 is array(0 to 60*5*3-1) of std_logic_vector(23 downto 0);
    --signal RAM_2 : ram2;
 
    signal data2: std_logic_vector(0 to 23) := "000000000000000000000000"; -- each LED is 24 bits, we output the same bitstream to all LEDs

    
    signal long: integer := 113;
    signal short: integer := 44;
    signal refresh: integer := 6250;

    signal ct: integer := 0;  -- Tracks the length of the high or low
    signal ct2: integer := 0; -- Keeps track if we are outputting a high
    signal ct3: integer := 0; -- Keeps track if we are outputting a high
    signal pulse: integer := 0; -- Keeps track if we are outputting a high
    
    signal req_a: boolean := false; -- Keeps track if we are outputting a high
    signal req_b: boolean := false; -- Keeps track if we are outputting a high

    signal grant_a: bit := '0'; -- Keeps track if we are outputting a high
    signal grant_b: bit := '0'; -- Keeps track if we are outputting a high

    signal spi_counter: integer := 0;
    signal spi_frame_counter: integer := 0;

    signal spi_data: std_logic_vector(0 to 23) := "000000000000000000000000";

    signal off: bit := '0';



    begin

        --LED <= '0';
        --STRIP1 <= '0';

        
        Arb: process(req_a, req_b)
        begin
            if req_a then 
                grant_a <= '1'; 
                grant_b <= '0'; 
            elsif req_b then 
                grant_a <= '0'; 
                grant_b <= '1'; 
            else 
                grant_a <= '0'; 
                grant_b <= '0';
            end if;
        end Process Arb;
        
    
        SPI: process(SPI_CLK)
        begin
            if rising_edge(SPI_CLK) then
                
                if spi_counter = 23 then
                
                    if off = '0' then
                        RAM_1(spi_frame_counter) <= spi_data(0 to 22) & SPI_DATA_IN  ;
                    else
                        RAM_1(spi_frame_counter+size) <= spi_data(0 to 22) & SPI_DATA_IN  ;
                    end if;
                    
                    if spi_frame_counter = size then
                        spi_frame_counter <= 0;
                        off <= off xor '1';
                    else
                        spi_frame_counter <= spi_frame_counter + 1; 
                    end if;
                    
                    spi_data <= "000000000000000000000000";
                    spi_counter <= 0;
                    
                else 
                        
                    spi_data(spi_counter) <= SPI_DATA_IN;   
                    spi_counter <= spi_counter + 1;
        
                
                end if;
                
            end if;
        end Process SPI;

        Prescaler: process(CLK_50MHz)
        begin

            if rising_edge(CLK_50MHz) then

                
                if off = '0' then
                    data2 <= RAM_1(ct3+size) ;
                else
                    data2 <= RAM_1(ct3)  ;
                end if;
                                  
                                  
                ct <= ct + 1;
                
                if ct3 = size then
                    if ct > refresh then
                        ct <= 0;
                        ct3 <= 0;
                    else
                        STRIP1 <= '0';                    
                    end if;                
                else
                        
                    if ct > short+long then
                        
                        
                        if ct2 = 23 then
                            ct2 <= 0;
                            ct3 <= ct3 + 1;
                        else 
                            ct2 <= ct2 + 1; 
                        end if;
                                     
                        ct <= 0;
                        
                    elsif data2(ct2) = '0' and ct > short then
                        STRIP1 <= '0';
                    elsif data2(ct2) = '1' and ct > long then
                        STRIP1 <= '0';
                    else
                        STRIP1 <= '1';
                    end if;     
                                
                end if;    
                           
            end if;      
      
        end process Prescaler;

end Behavioral;
