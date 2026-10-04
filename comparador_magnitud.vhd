library ieee;
use ieee.std_logic_1164.all;

entity comparador_magnitud is
    port (
        a      : in  std_logic_vector(3 downto 0);
        b      : in  std_logic_vector(3 downto 0);
        a_gt_b : out std_logic;
        a_eq_b : out std_logic;
        a_lt_b : out std_logic
    );
end entity;

architecture comb of comparador_magnitud is
begin
    a_gt_b <= '1' when a > b else '0';
    a_eq_b <= '1' when a = b else '0';
    a_lt_b <= '1' when a < b else '0';
end architecture;