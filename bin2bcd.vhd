library ieee;
use ieee.std_logic_1164.all;

entity bin2bcd is
    port (
        binary : in  std_logic_vector(6 downto 0);
        tens   : out std_logic_vector(3 downto 0);
        unid   : out std_logic_vector(3 downto 0)
    );
end entity;

architecture comb of bin2bcd is
    constant C10 : std_logic_vector(6 downto 0) := "0001010";
    constant C20 : std_logic_vector(6 downto 0) := "0010100";
    constant C30 : std_logic_vector(6 downto 0) := "0011110";
    constant C40 : std_logic_vector(6 downto 0) := "0101000";
    constant C50 : std_logic_vector(6 downto 0) := "0110010";
    constant C60 : std_logic_vector(6 downto 0) := "0111100";
    constant C70 : std_logic_vector(6 downto 0) := "1000110";
    constant C80 : std_logic_vector(6 downto 0) := "1010000";

    signal ge10, ge20, ge30, ge40, ge50, ge60, ge70, ge80 : std_logic;
    signal sub_const : std_logic_vector(6 downto 0);
    signal resto : std_logic_vector(6 downto 0);
begin
    ge10 <= '1' when binary >= C10 else '0';
    ge20 <= '1' when binary >= C20 else '0';
    ge30 <= '1' when binary >= C30 else '0';
    ge40 <= '1' when binary >= C40 else '0';
    ge50 <= '1' when binary >= C50 else '0';
    ge60 <= '1' when binary >= C60 else '0';
    ge70 <= '1' when binary >= C70 else '0';
    ge80 <= '1' when binary >= C80 else '0';

    tens <= "1000" when ge80 = '1' else
            "0111" when ge70 = '1' else
            "0110" when ge60 = '1' else
            "0101" when ge50 = '1' else
            "0100" when ge40 = '1' else
            "0011" when ge30 = '1' else
            "0010" when ge20 = '1' else
            "0001" when ge10 = '1' else
            "0000";

    sub_const <= "1010000" when ge80 = '1' else
                 "1000110" when ge70 = '1' else
                 "0111100" when ge60 = '1' else
                 "0110010" when ge50 = '1' else
                 "0101000" when ge40 = '1' else
                 "0011110" when ge30 = '1' else
                 "0010100" when ge20 = '1' else
                 "0001010" when ge10 = '1' else
                 "0000000";

    restar: entity work.add_sub_n generic map (N => 7)
        port map (a => binary, b => sub_const, sub => '1', y => resto, cout => open);

    unid <= resto(3 downto 0);
end architecture;