library ieee;
use ieee.std_logic_1164.all;

entity deco7seg is
    port (
        bcd      : in  std_logic_vector(3 downto 0);
        seg      : out std_logic_vector(6 downto 0);
        test     : in  std_logic;
        hex_mode : in  std_logic
    );
end entity;

architecture comb of deco7seg is
    signal seg_int : std_logic_vector(6 downto 0);
begin
    process(bcd, hex_mode)
    begin
        if hex_mode = '1' then
            case bcd is
                when "0000" => seg_int <= "1000000";
                when "0001" => seg_int <= "1111001";
                when "0010" => seg_int <= "0100100";
                when "0011" => seg_int <= "0110000";
                when "0100" => seg_int <= "0011001";
                when "0101" => seg_int <= "0010010";
                when "0110" => seg_int <= "0000010";
                when "0111" => seg_int <= "1111000";
                when "1000" => seg_int <= "0000000";
                when "1001" => seg_int <= "0010000";
                when "1010" => seg_int <= "0001000";
                when "1011" => seg_int <= "0000011";
                when "1100" => seg_int <= "1000110";
                when "1101" => seg_int <= "0100001";
                when "1110" => seg_int <= "0000110";
                when "1111" => seg_int <= "0001110";
                when others => seg_int <= "1111111";
            end case;
        else
            case bcd is
                when "0000" => seg_int <= "1000000";
                when "0001" => seg_int <= "1111001";
                when "0010" => seg_int <= "0100100";
                when "0011" => seg_int <= "0110000";
                when "0100" => seg_int <= "0011001";
                when "0101" => seg_int <= "0010010";
                when "0110" => seg_int <= "0000010";
                when "0111" => seg_int <= "1111000";
                when "1000" => seg_int <= "0000000";
                when "1001" => seg_int <= "0010000";
                when "1010" => seg_int <= "0111111";
                when "1011" => seg_int <= "0000110";
                when others => seg_int <= "1111111";
            end case;
        end if;
    end process;

    seg <= "0000000" when test = '1' else seg_int;
end architecture;