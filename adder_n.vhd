library ieee;
use ieee.std_logic_1164.all;

entity adder_n is
    generic (N : integer := 4);
    port (
        a    : in  std_logic_vector(N-1 downto 0);
        b    : in  std_logic_vector(N-1 downto 0);
        cin  : in  std_logic;
        sum  : out std_logic_vector(N-1 downto 0);
        cout : out std_logic
    );
end entity;

architecture structural of adder_n is
    signal c : std_logic_vector(N downto 0);
begin
    c(0) <= cin;
    gen_add: for i in 0 to N-1 generate
        sum(i) <= a(i) xor b(i) xor c(i);
        c(i+1) <= (a(i) and b(i)) or (a(i) and c(i)) or (b(i) and c(i));
    end generate;
    cout <= c(N);
end architecture;