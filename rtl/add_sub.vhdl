library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Somador/Subtrator parametrizável para N bits.
-- O sinal 'op' define a operação:
-- op = '0' -> result = a + b
-- op = '1' -> result = a - b
entity add_sub is
    generic(
        N : positive := 16
    );
    port(
        input_a      : in  std_logic_vector(N - 1 downto 0);
        input_b      : in  std_logic_vector(N - 1 downto 0);
        op     : in  std_logic;                            -- Sinal de controle vindo do BC
        result : out std_logic_vector(N - 1 downto 0)
    );
end add_sub;

architecture behavior of add_sub is
begin
    -- Processo sensível às entradas e ao sinal de operação
    process(input_a, input_b, op)
    begin
        if op = '0' then
            -- Converte para signed, soma, e converte de volta para std_logic_vector
            result <= std_logic_vector(signed(input_a) + signed(input_b));
        else
            -- Converte para signed, subtrai, e converte de volta para std_logic_vector
            result <= std_logic_vector(signed(input_a) - signed(input_b));
        end if;
    end process;
end architecture behavior;