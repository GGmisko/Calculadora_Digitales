library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_calculadora is
end entity;

architecture sim of tb_calculadora is
    signal sw    : std_logic_vector(9 downto 0) := (others => '0');
    signal btn   : std_logic_vector(2 downto 0) := (others => '1');
    signal hex3, hex2, hex1, hex0 : std_logic_vector(6 downto 0);
    signal ledg  : std_logic_vector(9 downto 0);

    signal errors : integer := 0;
begin
    dut: entity work.top_calculadora
        port map (sw => sw, btn => btn,
                  hex3 => hex3, hex2 => hex2, hex1 => hex1, hex0 => hex0,
                  ledg => ledg);

    stim: process
        variable a_val, b_val : integer;
        variable op_val       : integer;
        variable expected     : integer;
        variable exp_sign     : std_logic;
        variable total        : integer := 0;
        variable fallos       : integer := 0;
    begin
        btn <= "111";  -- sin botones presionados (modo normal)

        for op_val in 0 to 2 loop
            for a_val in 0 to 15 loop
                for b_val in 0 to 15 loop
                    total := total + 1;

                    sw(3 downto 0) <= std_logic_vector(to_unsigned(a_val, 4));
                    sw(7 downto 4) <= std_logic_vector(to_unsigned(b_val, 4));
                    sw(9 downto 8) <= std_logic_vector(to_unsigned(op_val, 2));
                    wait for 10 ns;

                    if a_val > 9 or b_val > 9 then
                        -- Caso de error: A o B > 9
                        if ledg(9) /= '1' then
                            report "FALLO error: A=" & integer'image(a_val) &
                                   " B=" & integer'image(b_val) &
                                   " op=" & integer'image(op_val) severity error;
                            fallos := fallos + 1;
                        end if;
                    else
                        -- Caso válido
                        if op_val = 0 then
                            expected := a_val + b_val;
                            exp_sign := '0';
                        elsif op_val = 1 then
                            if a_val >= b_val then
                                expected := a_val - b_val;
                                exp_sign := '0';
                            else
                                expected := b_val - a_val;
                                exp_sign := '1';
                            end if;
                        else
                            expected := a_val * b_val;
                            exp_sign := '0';
                        end if;

                        if ledg(7 downto 0) /= std_logic_vector(to_unsigned(expected, 8)) then
                            report "FALLO resultado: A=" & integer'image(a_val) &
                                   " B=" & integer'image(b_val) &
                                   " op=" & integer'image(op_val) &
                                   " esperado=" & integer'image(expected) severity error;
                            fallos := fallos + 1;
                        end if;

                        if ledg(8) /= exp_sign then
                            report "FALLO signo: A=" & integer'image(a_val) &
                                   " B=" & integer'image(b_val) &
                                   " op=" & integer'image(op_val) severity error;
                            fallos := fallos + 1;
                        end if;

                        if ledg(9) /= '0' then
                            report "FALLO error inesperado: A=" & integer'image(a_val) &
                                   " B=" & integer'image(b_val) severity error;
                            fallos := fallos + 1;
                        end if;
                    end if;
                end loop;
            end loop;
        end loop;

        report "==========================================";
        report "Total combinaciones probadas: " & integer'image(total);
        report "Total discrepancias: " & integer'image(fallos);
        report "==========================================";

        wait;
    end process;
end architecture;