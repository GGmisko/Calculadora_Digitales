library ieee;
use ieee.std_logic_1164.all;

entity logica_modos is
    port (
        modo      : in  std_logic_vector(2 downto 0);
        bcd_en    : out std_logic;
        hex_mode  : out std_logic;
        comp_mode : out std_logic;
        test_mode : out std_logic
    );
end entity;

architecture comb of logica_modos is
begin
    bcd_en    <= '1' when modo = "000" else '0';
    hex_mode  <= '1' when modo = "001" else '0';
    comp_mode <= '1' when modo = "010" else '0';
    test_mode <= '1' when modo = "100" else '0';
end architecture;