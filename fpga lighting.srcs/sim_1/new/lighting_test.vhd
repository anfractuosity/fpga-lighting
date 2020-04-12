library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lighting_test is
end lighting_test;

architecture Behavioral of lighting_test is

signal clk : std_logic := '0';
signal spi_clk : std_logic := '0';
signal spi_in : std_logic := '0';
signal strip_1: std_logic := '0';

begin

    UUT : entity work.lighting port map (spi_clk => spi_clk,spi_in => spi_in,clk=>clk,strip_1=>strip_1);

    test_proc: process
    begin
        wait for 8 ns;
        clk <= '1';
        wait for 8 ns;
        clk <= '0';
    end process;

end Behavioral;
