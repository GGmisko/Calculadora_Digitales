library ieee;
use ieee.std_logic_1164.all;
 
entity multiplier4x4 is
    port (
        a : in  std_logic_vector(3 downto 0);
        b : in  std_logic_vector(3 downto 0);
        p : out std_logic_vector(7 downto 0)
    );
end entity;
 
architecture structural of multiplier4x4 is
    signal pp0, pp1, pp2, pp3 : std_logic_vector(7 downto 0);
    signal s1, s2 : std_logic_vector(7 downto 0);
begin
    -- pp0 = a * b(0), sin desplazamiento
    pp0(0) <= a(0) and b(0);
    pp0(1) <= a(1) and b(0);
    pp0(2) <= a(2) and b(0);
    pp0(3) <= a(3) and b(0);
    pp0(7 downto 4) <= (others => '0');
 
    -- pp1 = a * b(1), desplazado 1
    pp1(0) <= '0';
    pp1(1) <= a(0) and b(1);
    pp1(2) <= a(1) and b(1);
    pp1(3) <= a(2) and b(1);
    pp1(4) <= a(3) and b(1);
    pp1(7 downto 5) <= (others => '0');
 
    -- pp2 = a * b(2), desplazado 2
    pp2(1 downto 0) <= "00";
    pp2(2) <= a(0) and b(2);
    pp2(3) <= a(1) and b(2);
    pp2(4) <= a(2) and b(2);
    pp2(5) <= a(3) and b(2);
    pp2(7 downto 6) <= (others => '0');
 
    -- pp3 = a * b(3), desplazado 3
    pp3(2 downto 0) <= "000";
    pp3(3) <= a(0) and b(3);
    pp3(4) <= a(1) and b(3);
    pp3(5) <= a(2) and b(3);
    pp3(6) <= a(3) and b(3);
    pp3(7) <= '0';
 
    -- Sumas
    add1: entity work.adder_n generic map (N => 8)
        port map (a => pp0, b => pp1, cin => '0', sum => s1, cout => open);
 
    add2: entity work.adder_n generic map (N => 8)
        port map (a => s1, b => pp2, cin => '0', sum => s2, cout => open);
 
    add3: entity work.adder_n generic map (N => 8)
        port map (a => s2, b => pp3, cin => '0', sum => p, cout => open);
end architecture;