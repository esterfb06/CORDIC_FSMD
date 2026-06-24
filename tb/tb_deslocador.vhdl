library IEEE;
use IEEE.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity tb_deslocador is
end tb_deslocador;

architecture tb of tb_deslocador is

    constant N : positive := 16;
    constant S : positive := 5;

    signal dado_in     : std_logic_vector(N - 1 downto 0);
    signal shift_valor : std_logic_vector(S - 1 downto 0);
    signal dado_out    : std_logic_vector(N - 1 downto 0);

    constant passo : TIME := 20 ns;

begin
    -- Connect DUV
    DUV: entity work.deslocador
        generic map (
            N => N,
            S => S
        )
        port map (
            dado_in     => dado_in,
            shift_valor => shift_valor,
            dado_out    => dado_out
        );

    process
    begin
        -- Shift de 0 posicoes: deve manter o valor original
        dado_in     <= std_logic_vector(to_signed(100, N));
        shift_valor <= std_logic_vector(to_unsigned(0, S));
        wait for passo;
        assert(dado_out = std_logic_vector(to_signed(100, N)))
        report "Fail shift 0" severity error;

        -- Shift de 1 posicao, valor positivo: 16 >> 1 = 8
        dado_in     <= std_logic_vector(to_signed(16, N));
        shift_valor <= std_logic_vector(to_unsigned(1, S));
        wait for passo;
        assert(dado_out = std_logic_vector(to_signed(8, N)))
        report "Fail shift 1 (16>>1)" severity error;

        -- Shift de 2 posicoes, valor positivo: 100 >> 2 = 25
        dado_in     <= std_logic_vector(to_signed(100, N));
        shift_valor <= std_logic_vector(to_unsigned(2, S));
        wait for passo;
        assert(dado_out = std_logic_vector(to_signed(25, N)))
        report "Fail shift 2 (100>>2)" severity error;

        -- Shift de 4 posicoes, valor positivo: 256 >> 4 = 16
        dado_in     <= std_logic_vector(to_signed(256, N));
        shift_valor <= std_logic_vector(to_unsigned(4, S));
        wait for passo;
        assert(dado_out = std_logic_vector(to_signed(16, N)))
        report "Fail shift 4 (256>>4)" severity error;

        -- Shift aritmetico de numero negativo: -16 >> 1 = -8
        dado_in     <= std_logic_vector(to_signed(-16, N));
        shift_valor <= std_logic_vector(to_unsigned(1, S));
        wait for passo;
        assert(dado_out = std_logic_vector(to_signed(-8, N)))
        report "Fail shift -16>>1" severity error;

        -- Shift aritmetico de numero negativo: -100 >> 2 = -25
        dado_in     <= std_logic_vector(to_signed(-100, N));
        shift_valor <= std_logic_vector(to_unsigned(2, S));
        wait for passo;
        assert(dado_out = std_logic_vector(to_signed(-25, N)))
        report "Fail shift -100>>2" severity error;

        -- Shift aritmetico de -1: deve permanecer -1 (sinal preenche com 1's)
        dado_in     <= std_logic_vector(to_signed(-1, N));
        shift_valor <= std_logic_vector(to_unsigned(3, S));
        wait for passo;
        assert(dado_out = std_logic_vector(to_signed(-1, N)))
        report "Fail shift -1>>3" severity error;

        -- Shift de muitas posicoes em valor positivo: deve tender a 0
        dado_in     <= std_logic_vector(to_signed(100, N));
        shift_valor <= std_logic_vector(to_unsigned(10, S));
        wait for passo;
        assert(dado_out = std_logic_vector(to_signed(0, N)))
        report "Fail shift 100>>10" severity error;

        -- Shift de muitas posicoes em valor negativo: deve tender a -1
        dado_in     <= std_logic_vector(to_signed(-100, N));
        shift_valor <= std_logic_vector(to_unsigned(10, S));
        wait for passo;
        assert(dado_out = std_logic_vector(to_signed(-1, N)))
        report "Fail shift -100>>10" severity error;

        -- Shift maximo permitido por S (31 posicoes, N=16): valor positivo tende a 0
        dado_in     <= std_logic_vector(to_signed(32767, N));
        shift_valor <= std_logic_vector(to_unsigned(31, S));
        wait for passo;
        assert(dado_out = std_logic_vector(to_signed(0, N)))
        report "Fail shift 32767>>31" severity error;

        -- Shift maximo permitido por S (31 posicoes, N=16): valor negativo tende a -1
        dado_in     <= std_logic_vector(to_signed(-32768, N));
        shift_valor <= std_logic_vector(to_unsigned(31, S));
        wait for passo;
        assert(dado_out = std_logic_vector(to_signed(-1, N)))
        report "Fail shift -32768>>31" severity error;

        wait for passo;
        assert false report "Test done." severity note;
        wait;
    end process;

end tb;