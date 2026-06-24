library IEEE;
use IEEE.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity tb_mux_2to1 is
end tb_mux_2to1;

architecture tb of tb_mux_2to1 is

    constant N : positive := 16;

    signal sel  : std_logic;
    signal in_0 : std_logic_vector(N - 1 downto 0);
    signal in_1 : std_logic_vector(N - 1 downto 0);
    signal y    : std_logic_vector(N - 1 downto 0);

    constant passo : TIME := 20 ns;

begin
    -- Connect DUV
    DUV: entity work.mux_2to1
        generic map (
            N => N
        )
        port map (
            sel  => sel,
            in_0 => in_0,
            in_1 => in_1,
            y    => y
        );

    process
    begin
        -- sel = '0': y deve ser igual a in_0
        in_0 <= std_logic_vector(to_unsigned(12345, N));
        in_1 <= std_logic_vector(to_unsigned(54321, N));
        sel  <= '0';
        wait for passo;
        assert(y = std_logic_vector(to_unsigned(12345, N)))
        report "Fail sel=0 (deveria ser in_0)" severity error;

        -- sel = '1': y deve ser igual a in_1
        in_0 <= std_logic_vector(to_unsigned(12345, N));
        in_1 <= std_logic_vector(to_unsigned(54321, N));
        sel  <= '1';
        wait for passo;
        assert(y = std_logic_vector(to_unsigned(54321, N)))
        report "Fail sel=1 (deveria ser in_1)" severity error;

        -- sel = '0', valores zero
        in_0 <= std_logic_vector(to_unsigned(0, N));
        in_1 <= std_logic_vector(to_unsigned(65535, N));
        sel  <= '0';
        wait for passo;
        assert(y = std_logic_vector(to_unsigned(0, N)))
        report "Fail sel=0 com in_0=0" severity error;

        -- sel = '1', valores no limite maximo
        in_0 <= std_logic_vector(to_unsigned(0, N));
        in_1 <= std_logic_vector(to_unsigned(65535, N));
        sel  <= '1';
        wait for passo;
        assert(y = std_logic_vector(to_unsigned(65535, N)))
        report "Fail sel=1 com in_1=65535" severity error;

        -- sel = '0', in_0 e in_1 iguais -> y deve ser igual a ambos
        in_0 <= std_logic_vector(to_unsigned(4242, N));
        in_1 <= std_logic_vector(to_unsigned(4242, N));
        sel  <= '0';
        wait for passo;
        assert(y = std_logic_vector(to_unsigned(4242, N)))
        report "Fail sel=0 com in_0=in_1" severity error;

        -- sel = '1', in_0 e in_1 iguais -> y deve ser igual a ambos
        in_0 <= std_logic_vector(to_unsigned(4242, N));
        in_1 <= std_logic_vector(to_unsigned(4242, N));
        sel  <= '1';
        wait for passo;
        assert(y = std_logic_vector(to_unsigned(4242, N)))
        report "Fail sel=1 com in_0=in_1" severity error;

        -- Mudanca dinamica de sel sem alterar as entradas
        in_0 <= std_logic_vector(to_unsigned(1000, N));
        in_1 <= std_logic_vector(to_unsigned(2000, N));
        sel  <= '0';
        wait for passo;
        assert(y = std_logic_vector(to_unsigned(1000, N)))
        report "Fail mudanca dinamica sel=0" severity error;

        sel <= '1';
        wait for passo;
        assert(y = std_logic_vector(to_unsigned(2000, N)))
        report "Fail mudanca dinamica sel=1" severity error;

        sel <= '0';
        wait for passo;
        assert(y = std_logic_vector(to_unsigned(1000, N)))
        report "Fail mudanca dinamica de volta para sel=0" severity error;

        -- Padrao alternado de bits (0101...) com sel=0
        in_0 <= "0101010101010101";
        in_1 <= "1010101010101010";
        sel  <= '0';
        wait for passo;
        assert(y = "0101010101010101")
        report "Fail padrao alternado sel=0" severity error;

        -- Padrao alternado de bits (0101...) com sel=1
        sel <= '1';
        wait for passo;
        assert(y = "1010101010101010")
        report "Fail padrao alternado sel=1" severity error;

        wait for passo;
        assert false report "Test done." severity note;
        wait;
    end process;

end tb;