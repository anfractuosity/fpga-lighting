library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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
    
    signal data: std_logic_vector(24 downto 0);

    begin

        Prescaler: process(CLK_50MHz)
        begin

            if rising_edge(CLK_50MHz) then
                if Counter < clk_val then
                    Counter <= Counter + 1;
                else
                    hz1 <= not hz1 ;
                    Counter <= (others => '0');
                end if;
            end if;
      
        end process Prescaler;

        LED <= hz1;

end Behavioral;
