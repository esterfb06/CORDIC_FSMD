library IEEE;
use IEEE.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity tb_register_en is
end tb_register_en;

architecture tb of tb_register_en is

    constant N : positive := 16;

    signal clk    : std_logic := '0';
    signal enable : std_logic;
    signal d      : std_logic_vector(N - 1 downto 0);
    signal q      : std_logic_vector(N - 1 downto 0);

    constant passo       : TIME := 20 ns;
    constant periodo_clk : TIME := 10 ns;

    signal fim_simulacao : boolean := false;

begin
    -- Connect DUV
    DUV: entity work.register_en
        generic map (
            N => N
        )
        port map (
            clk    => clk,
            enable => enable,
            d      => d,
            q      => q
        );

    -- Processo de geracao do clock
    clk_proc: process
    begin
        while not fim_simulacao loop
            clk <= '0';
            wait for periodo_clk / 2;
            clk <= '1';
            wait for periodo_clk / 2;
        end loop;
        wait;
    end process;

    -- Processo de estimulo e verificacao
    stim_proc: process
    begin
        -- Estado inicial: enable = '0'
        enable <= '0';
        d      <= std_logic_vector(to_unsigned(1234, N));
        wait for passo;

        -- enable = '1': na proxima borda de subida, q deve capturar d = 1234
        enable <= '1';
        d      <= std_logic_vector(to_unsigned(1234, N));
        wait for passo;
        assert(q = std_logic_vector(to_unsigned(1234, N)))
        report "Fail captura com enable=1 (1234)" severity error;

        -- enable = '0': muda d, mas q NAO deve mudar (mantem 1234)
        enable <= '0';
        d      <= std_logic_vector(to_unsigned(9999, N));
        wait for passo;
        assert(q = std_logic_vector(to_unsigned(1234, N)))
        report "Fail q mudou com enable=0 (deveria manter 1234)" severity error;

        -- ainda enable = '0', outro valor de d: q continua sem mudar
        d <= std_logic_vector(to_unsigned(5555, N));
        wait for passo;
        assert(q = std_logic_vector(to_unsigned(1234, N)))
        report "Fail q mudou com enable=0 (deveria manter 1234) #2" severity error;

        -- enable = '1' novamente: q deve capturar o valor atual de d = 5555
        enable <= '1';
        d      <= std_logic_vector(to_unsigned(5555, N));
        wait for passo;
        assert(q = std_logic_vector(to_unsigned(5555, N)))
        report "Fail captura com enable=1 (5555)" severity error;

        -- enable = '1' com novo valor: q deve atualizar para 0
        d <= std_logic_vector(to_unsigned(0, N));
        wait for passo;
        assert(q = std_logic_vector(to_unsigned(0, N)))
        report "Fail captura com enable=1 (0)" severity error;

        -- enable = '1' com valor maximo (65535)
        d <= std_logic_vector(to_unsigned(65535, N));
        wait for passo;
        assert(q = std_logic_vector(to_unsigned(65535, N)))
        report "Fail captura com enable=1 (65535)" severity error;

        -- enable = '0': mesmo com d mudando, q deve manter 65535
        enable <= '0';
        d      <= std_logic_vector(to_unsigned(1, N));
        wait for passo;
        assert(q = std_logic_vector(to_unsigned(65535, N)))
        report "Fail q mudou com enable=0 (deveria manter 65535)" severity error;

        -- Teste de pulso curto de enable: enable = '1' por apenas um ciclo de clock
        enable <= '1';
        d      <= std_logic_vector(to_unsigned(777, N));
        wait for periodo_clk;  -- espera exatamente uma borda de subida
        enable <= '0';
        d      <= std_logic_vector(to_unsigned(888, N)); -- d muda, mas nao deve ser capturado
        wait for passo;
        assert(q = std_logic_vector(to_unsigned(777, N)))
        report "Fail pulso curto de enable (deveria ter capturado 777)" severity error;

        wait for passo;
        assert false report "Test done." severity note;
        fim_simulacao <= true;
        wait;
    end process;

end tb;