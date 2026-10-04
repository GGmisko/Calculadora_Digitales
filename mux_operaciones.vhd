library ieee;
use ieee.std_logic_1164.all;
 
entity mux_operaciones is
    generic (N : integer := 4);
    port (
        a      : in  std_logic_vector(N-1 downto 0);
        b      : in  std_logic_vector(N-1 downto 0);
        op     : in  std_logic_vector(1 downto 0);
        result : out std_logic_vector(2*N-1 downto 0);
        sign   : out std_logic
    );
end entity;
 
architecture structural of mux_operaciones is
    signal sum4, diff4, mag4 : std_logic_vector(N-1 downto 0);
    signal prod8             : std_logic_vector(2*N-1 downto 0);
    signal cout_sum, cout_diff : std_logic;
    signal zero4             : std_logic_vector(N-1 downto 0);
begin
    zero4 <= (others => '0');
 
    add_sum: entity work.add_sub_n generic map (N => N)
        port map (a => a, b => b, sub => '0', y => sum4, cout => cout_sum);
 
    sub_rest: entity work.add_sub_n generic map (N => N)
        port map (a => a, b => b, sub => '1', y => diff4, cout => cout_diff);
 
    mag_sub: entity work.add_sub_n generic map (N => N)
        port map (a => zero4, b => diff4, sub => '1', y => mag4, cout => open);
 
    mult: entity work.multiplier4x4
        port map (a => a, b => b, p => prod8);
 
    -- Corrección: incluir cout_sum como bit 4 para sumas > 15
    result <= (N-2 downto 0 => '0') & cout_sum & sum4 when op = "00" else
              (N-1 downto 0 => '0') & diff4  when (op = "01" and cout_diff = '1') else
              (N-1 downto 0 => '0') & mag4   when (op = "01" and cout_diff = '0') else
              prod8          when op = "10" else
              (others => '0');
 
    sign <= '0' when op = "00" else
            '0' when (op = "01" and cout_diff = '1') else
            '1' when (op = "01" and cout_diff = '0') else
            '0';
end architecture;