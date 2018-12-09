
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

    signal Counter: std_logic_vector(26 downto 0);
    
    signal hz1: std_logic;
    constant clk_val : integer := 50000000;
    
    constant t0h : real := 35.0e-6;
    constant t1h : real := 0.9e-6;
    constant t0l : real := 0.9e-6;
    constant t1l : real := 35.0e-6;
    constant res : real := 50.0e-6;
    
    --signal data: std_logic_vector(24 downto 0) := "111111111111111111111111";
    
    
    signal data2: unsigned(23 downto 0) := "101111110101011111111111"; --"111111111111111111111111";
    signal step1: integer := 0; --std_logic_vector(15 downto 0) := "00000000";
    signal step2: integer := 0; --std_logic_vector(15 downto 0) := "00000000";
    
    signal long: integer := 25000000;--43; --std_logic_vector(15 downto 0) := "00000000";
    signal short: integer := 1000000; --std_logic_vector(15 downto 0) := "00000000";


    signal rot: integer := 0;

    signal ct: integer := 0;

    signal ct2: integer := 0;
    




    
    -- 0.85e-6/(1/50e6) = 43
    -- 0.4e-6/(1/50e6) = 20
    
    --signal sleep: 
 
    begin

        Prescaler: process(CLK_50MHz)
        begin

            if rising_edge(CLK_50MHz) then
           
                ct <= ct + 1;
                
                if ct2 = 0 then
                
                    if data2(0) = '0' then
                        if ct > short then
                            ct2 <= 1;
                            LED <= '0';
                            ct <= 0;
                        else 
                            LED <= '1';
                        end if;
                    else
                        if ct > long then
                            ct2 <= 1;
                            LED <= '0';
                            ct <= 0;                            
                        else
                            LED <= '1';
                        end if;
                    end if;
                                        
                else 
                   
                    if data2(0) = '0' then
                        if ct > long then
                            ct <= 0;
                            ct2 <= 0;
                            data2 <= rotate_right(data2,1);
                        else 
                            LED <= '0';
                        end if;
                    else
                        if ct > short then
                            ct <= 0;
                            ct2 <= 0;
                            data2 <= rotate_right(data2,1);
                        else
                            LED <= '0';
                        end if;
                    end if;                
                end if;    
            
            end if;
            
      
        end process Prescaler;

end Behavioral;
