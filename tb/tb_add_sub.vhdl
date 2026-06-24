library IEEE;
use IEEE.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity tb_add_sub is
end tb_add_sub;

architecture tb of tb_add_sub is

    constant N : positive := 16;

    signal input_a : std_logic_vector(N - 1 downto 0);
    signal input_b : std_logic_vector(N - 1 downto 0);
    signal op      : std_logic;
    signal result  : std_logic_vector(N - 1 downto 0);

    constant passo : TIME := 20 ns;

begin
    
    DUV: entity work.add_sub
        generic map (
            N => N
        )
        port map (
            input_a => input_a,
            input_b => input_b,
            op      => op,
            result  => result
        );

    process
    begin

        -- Soma simples positiva: 10 + 5 = 15
        input_a <= std_logic_vector(to_signed(10, N));
        input_b <= std_logic_vector(to_signed(5, N));
        op      <= '0';
        wait for passo;
        assert(result = std_logic_vector(to_signed(15, N)))
        report "Fail SOMA 10+5" severity error;

        -- Soma zero + zero = 0
        input_a <= std_logic_vector(to_signed(0, N));
        input_b <= std_logic_vector(to_signed(0, N));
        op      <= '0';
        wait for passo;
        assert(result = std_logic_vector(to_signed(0, N)))
        report "Fail SOMA 0+0" severity error;

        -- Soma dois negativos: -10 + (-5) = -15
        input_a <= std_logic_vector(to_signed(-10, N));
        input_b <= std_logic_vector(to_signed(-5, N));
        op      <= '0';
        wait for passo;
        assert(result = std_logic_vector(to_signed(-15, N)))
        report "Fail SOMA -10+-5" severity error;

        -- Soma negativo + positivo: -10 + 20 = 10
        input_a <= std_logic_vector(to_signed(-10, N));
        input_b <= std_logic_vector(to_signed(20, N));
        op      <= '0';
        wait for passo;
        assert(result = std_logic_vector(to_signed(10, N)))
        report "Fail SOMA -10+20" severity error;

        -- Soma com overflow positivo: 32767 + 1 = -32768 (wraparound)
        input_a <= std_logic_vector(to_signed(32767, N));
        input_b <= std_logic_vector(to_signed(1, N));
        op      <= '0';
        wait for passo;
        assert(result = std_logic_vector(to_signed(-32768, N)))
        report "Fail SOMA overflow positivo" severity error;

        -- Soma com overflow negativo: -32768 + (-1) = 32767 (wraparound)
        input_a <= std_logic_vector(to_signed(-32768, N));
        input_b <= std_logic_vector(to_signed(-1, N));
        op      <= '0';
        wait for passo;
        assert(result = std_logic_vector(to_signed(32767, N)))
        report "Fail SOMA overflow negativo" severity error;

        ---------------------------------------------------------------------

        -- Subtracao simples positiva: 10 - 5 = 5
        input_a <= std_logic_vector(to_signed(10, N));
        input_b <= std_logic_vector(to_signed(5, N));
        op      <= '1';
        wait for passo;
        assert(result = std_logic_vector(to_signed(5, N)))
        report "Fail SUB 10-5" severity error;

        -- Subtracao com resultado negativo: 5 - 10 = -5
        input_a <= std_logic_vector(to_signed(5, N));
        input_b <= std_logic_vector(to_signed(10, N));
        op      <= '1';
        wait for passo;
        assert(result = std_logic_vector(to_signed(-5, N)))
        report "Fail SUB 5-10" severity error;

        -- Subtracao zero - zero = 0
        input_a <= std_logic_vector(to_signed(0, N));
        input_b <= std_logic_vector(to_signed(0, N));
        op      <= '1';
        wait for passo;
        assert(result = std_logic_vector(to_signed(0, N)))
        report "Fail SUB 0-0" severity error;

        -- Subtracao dois negativos: -10 - (-5) = -5
        input_a <= std_logic_vector(to_signed(-10, N));
        input_b <= std_logic_vector(to_signed(-5, N));
        op      <= '1';
        wait for passo;
        assert(result = std_logic_vector(to_signed(-5, N)))
        report "Fail SUB -10--5" severity error;

        -- Subtracao com overflow negativo: -32768 - 1 = 32767 (wraparound)
        input_a <= std_logic_vector(to_signed(-32768, N));
        input_b <= std_logic_vector(to_signed(1, N));
        op      <= '1';
        wait for passo;
        assert(result = std_logic_vector(to_signed(32767, N)))
        report "Fail SUB overflow negativo" severity error;

        -- Subtracao com overflow positivo: 32767 - (-1) = -32768 (wraparound)
        input_a <= std_logic_vector(to_signed(32767, N));
        input_b <= std_logic_vector(to_signed(-1, N));
        op      <= '1';
        wait for passo;
        assert(result = std_logic_vector(to_signed(-32768, N)))
        report "Fail SUB overflow positivo" severity error;

        wait for passo;
        assert false report "Test done." severity note;
        wait;
    end process;

end tb;