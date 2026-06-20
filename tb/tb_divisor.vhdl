library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity td_divisor is
end td_divisor;
architecture Comportamento of td_divisor is
    component divisor
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            Ai : in STD_LOGIC_VECTOR(15 downto 0);
            B : IN SIGNED(15 downto 0);
            DIV : OUT STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    signal    clk : STD_LOGIC := '0';
    signal    rst : STD_LOGIC := '0';
    signal    Ai : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal    B : SIGNED(15 downto 0) := (others => '0');
    signal    DIV : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

    constant periodo_clk : time := 10 ns;

begin
    UUT: divisor port map (
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


    processo_testes: process
    begin
        rst <= '1';
        wait for periodo_clk * 2;
        rst <= '0';

        wait for periodo_clk;

        Ai <= STD_LOGIC_VECTOR(to_signed(10, 16));
        B <= to_signed(2, 16);

        wait for periodo_clk * 20;

        assert (signed(DIV) = 5)
        report "Divisão falhou: Resultado Diferente"
        severity error;

        wait;

    end process;
end comportamento;