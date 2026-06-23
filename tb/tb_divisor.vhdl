library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_divisor is
end tb_divisor;
architecture Comportamento of tb_divisor is

    signal    clk : STD_LOGIC := '0';
    signal    rst : STD_LOGIC := '0';
    signal    Ai : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal    B : SIGNED(15 downto 0) := (others => '0');
    signal    DIV : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

    constant periodo_clk : time := 10 ns;

begin
    UUT: entity work.divisor port map (
        clk => clk,
        rst => rst,
        Ai => Ai,
        B => B,
        DIV => DIV
    );

    processo_clk : process
    begin
        clk <= '0';
        wait for periodo_clk / 2;
        clk <= '1';
        wait for periodo_clk / 2;
    end process;

    -- escrever mais testes 
    processo_testes: process
    begin

        Ai <= STD_LOGIC_VECTOR(to_signed(10, 16));
        B <= to_signed(2, 16);
        
        rst <= '1';
        wait for periodo_clk * 2;
        rst <= '0';

        wait for periodo_clk;

        wait for periodo_clk * 20;

        assert (signed(DIV) = 5)
        report "Divisão falhou: Resultado Diferente"
        severity error;

        report "Teste concluído com sucesso";
        wait;

    end process;
end comportamento;