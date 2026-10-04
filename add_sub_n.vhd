library ieee;
use ieee.std_logic_1164.all;

entity add_sub_n is
    generic (N : integer := 4);
    port (
        a    : in  std_logic_vector(N-1 downto 0);
        b    : in  std_logic_vector(N-1 downto 0);
        sub  : in  std_logic;
        y    : out std_logic_vector(N-1 downto 0);
        cout : out std_logic
    );
end entity;

architecture structural of add_sub_n is
    signal b_xor : std_logic_vector(N-1 downto 0);
begin
    b_xor <= b xor (N-1 downto 0 => sub);
    add: entity work.adder_n
        generic map (N => N)
        port map (a => a, b => b_xor, cin => sub, sum => y, cout => cout);
end architecture;