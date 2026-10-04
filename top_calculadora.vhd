library ieee;
use ieee.std_logic_1164.all;

entity top_calculadora is
    port (
        sw    : in  std_logic_vector(9 downto 0);
        btn   : in  std_logic_vector(2 downto 0);
        hex3  : out std_logic_vector(6 downto 0);
        hex2  : out std_logic_vector(6 downto 0);
        hex1  : out std_logic_vector(6 downto 0);
        hex0  : out std_logic_vector(6 downto 0);
        ledg  : out std_logic_vector(9 downto 0)
    );
end entity;

architecture structural of top_calculadora is
    signal a, b       : std_logic_vector(3 downto 0);
    signal op         : std_logic_vector(1 downto 0);
    signal result     : std_logic_vector(7 downto 0);
    signal sign       : std_logic;
    signal tens, unid : std_logic_vector(3 downto 0);
    signal a_valid, b_valid, error : std_logic;
    signal modo       : std_logic_vector(2 downto 0);

    signal normal_mode  : std_logic;
    signal hex_mode     : std_logic;
    signal comp_mode    : std_logic;
    signal test_mode    : std_logic;
    signal hex_mode_eff : std_logic;

    signal a_gt_b, a_eq_b, a_lt_b : std_logic;
    signal comp_val   : std_logic_vector(3 downto 0);

    signal bcd3, bcd2, bcd1, bcd0 : std_logic_vector(3 downto 0);
begin
    a  <= sw(3 downto 0);
    b  <= sw(7 downto 4);
    op <= sw(9 downto 8);

    prio: entity work.codificador_prioridad
        port map (btn => btn, modo => modo);

    normal_mode  <= '1' when modo = "000" else '0';
    hex_mode     <= '1' when modo = "001" else '0';
    comp_mode    <= '1' when modo = "010" else '0';
    test_mode    <= '1' when modo = "100" else '0';
    hex_mode_eff <= hex_mode or comp_mode;

    val: entity work.validador_bcd
        generic map (N => 4)
        port map (a => a, b => b, enable => not hex_mode,
                  a_valid => a_valid, b_valid => b_valid, error => error);

    mux_op: entity work.mux_operaciones
        generic map (N => 4)
        port map (a => a, b => b, op => op, result => result, sign => sign);

    -- Experimento 3: bin2bcd recibe solo 7 bits (resultado máximo 81)
    bcd: entity work.bin2bcd
        port map (binary => result(6 downto 0), tens => tens, unid => unid);

    comp: entity work.comparador_magnitud
        port map (a => a, b => b, a_gt_b => a_gt_b, a_eq_b => a_eq_b, a_lt_b => a_lt_b);

    comp_val <= a when a_gt_b = '1' else b;

    bcd3 <= "1011" when (normal_mode = '1' and a_valid = '0') else a;
    bcd2 <= "1011" when (normal_mode = '1' and b_valid = '0') else b;

    process(modo, tens, unid, sign, error, result, comp_val)
    begin
        bcd1 <= "0000";
        bcd0 <= "0000";

        case modo is
            when "000" =>
                if error = '1' then
                    bcd1 <= "1011";
                    bcd0 <= "1011";
                elsif sign = '1' then
                    bcd1 <= "1010";
                    bcd0 <= unid;
                else
                    bcd1 <= tens;
                    bcd0 <= unid;
                end if;

            when "001" =>
                bcd1 <= result(7 downto 4);
                bcd0 <= result(3 downto 0);

            when "010" =>
                bcd1 <= comp_val;
                bcd0 <= "1111";

            when others =>
                bcd1 <= "0000";
                bcd0 <= "0000";
        end case;
    end process;

    dec3: entity work.deco7seg port map (bcd => bcd3, seg => hex3, test => test_mode, hex_mode => hex_mode_eff);
    dec2: entity work.deco7seg port map (bcd => bcd2, seg => hex2, test => test_mode, hex_mode => hex_mode_eff);
    dec1: entity work.deco7seg port map (bcd => bcd1, seg => hex1, test => test_mode, hex_mode => hex_mode_eff);
    dec0: entity work.deco7seg port map (bcd => bcd0, seg => hex0, test => test_mode, hex_mode => hex_mode_eff);

    ledg(0) <= a_gt_b when comp_mode = '1' else result(0);
    ledg(1) <= a_eq_b when comp_mode = '1' else result(1);
    ledg(2) <= a_lt_b when comp_mode = '1' else result(2);
    ledg(7 downto 3) <= result(7 downto 3);
    ledg(8) <= sign;
    ledg(9) <= error and (not hex_mode);
end architecture;