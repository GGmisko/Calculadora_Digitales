library ieee;
use ieee.std_logic_1164.all;

entity validador_bcd is
    generic (N : integer := 4);
    port (
        a       : in  std_logic_vector(N-1 downto 0);
        b       : in  std_logic_vector(N-1 downto 0);
        enable  : in  std_logic;
        a_valid : out std_logic;
        b_valid : out std_logic;
        error   : out std_logic
    );
end entity;

architecture comb of validador_bcd is
    signal a_gt9, b_gt9 : std_logic;
begin
    a_gt9 <= '1' when (a(3) = '1' and (a(2) = '1' or a(1) = '1')) else '0';
    b_gt9 <= '1' when (b(3) = '1' and (b(2) = '1' or b(1) = '1')) else '0';

    a_valid <= '0' when (enable = '1' and a_gt9 = '1') else '1';
    b_valid <= '0' when (enable = '1' and b_gt9 = '1') else '1';
    error   <= '1' when (enable = '1' and (a_gt9 = '1' or b_gt9 = '1')) else '0';
end architecture;