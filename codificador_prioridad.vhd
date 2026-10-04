library ieee;
use ieee.std_logic_1164.all;

entity codificador_prioridad is
    port (
        btn  : in  std_logic_vector(2 downto 0);
        modo : out std_logic_vector(2 downto 0)
    );
end entity;

architecture comb of codificador_prioridad is
begin
    modo(2) <= '1' when btn(2) = '0' else '0';
    modo(1) <= '1' when btn(2) = '1' and btn(1) = '0' else '0';
    modo(0) <= '1' when btn(2) = '1' and btn(1) = '1' and btn(0) = '0' else '0';
end architecture;