library IEEE;
use IEEE.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity tb_cordic_bc is
end tb_cordic_bc;

architecture tb of tb_cordic_bc is

    signal clk     : std_logic := '0';
    signal reset   : std_logic;
    signal iniciar : std_logic;
    signal menor   : std_logic;
    signal z_sign  : std_logic;

    signal zi          : std_logic;
    signal ci          : std_logic;
    signal init_sel    : std_logic;
    signal en_x        : std_logic;
    signal en_y        : std_logic;
    signal en_z        : std_logic;
    signal en_out_trig : std_logic;
    signal op_x        : std_logic;
    signal op_y        : std_logic;
    signal op_z        : std_logic;
    signal pronto      : std_logic;

    constant periodo_clk : TIME := 10 ns;
    constant passo        : TIME := 20 ns;

    signal fim_simulacao : boolean := false;

begin
    -- Connect DUV
    DUV: entity work.cordic_bc
        port map (
            clk         => clk,
            reset       => reset,
            iniciar     => iniciar,
            menor       => menor,
            z_sign      => z_sign,
            zi          => zi,
            ci          => ci,
            init_sel    => init_sel,
            en_x        => en_x,
            en_y        => en_y,
            en_z        => en_z,
            en_out_trig => en_out_trig,
            op_x        => op_x,
            op_y        => op_y,
            op_z        => op_z,
            pronto      => pronto
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

    stim_proc: process
    begin
        -- ===================== TESTE 1: Reset =====================
        reset   <= '1';
        iniciar <= '0';
        menor   <= '0';
        z_sign  <= '0';
        wait for passo;
        assert(pronto = '1')
        report "Fail: pronto deveria ser '1' em S0 (apos reset)" severity error;

        reset <= '0';
        wait for passo;
        assert(pronto = '1')
        report "Fail: pronto deveria permanecer '1' em S0 sem iniciar" severity error;

        -- ===================== TESTE 2: S0 -> S1 (inicializacao) =====================
        iniciar <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        iniciar <= '0'; -- pulso de iniciar, so precisa durar um ciclo

        -- Agora deve estar em S1: zi=ci=init_sel=en_x=en_y=en_z='1', pronto='0'
        assert(pronto = '0')
        report "Fail: pronto deveria ser '0' em S1" severity error;
        assert(zi = '1' and ci = '1' and init_sel = '1')
        report "Fail: zi/ci/init_sel deveriam ser '1' em S1" severity error;
        assert(en_x = '1' and en_y = '1' and en_z = '1')
        report "Fail: en_x/en_y/en_z deveriam ser '1' em S1" severity error;
        assert(en_out_trig = '0')
        report "Fail: en_out_trig deveria ser '0' em S1" severity error;

        -- ===================== TESTE 3: S1 -> S2 (avalia 'menor') =====================
        wait until rising_edge(clk);
        wait for 1 ns;
        -- Em S2 (estado "null" na logica de saida), todos os sinais de controle = '0'
        assert(zi = '0' and ci = '0' and init_sel = '0')
        report "Fail: sinais deveriam ser '0' em S2" severity error;
        assert(en_x = '0' and en_y = '0' and en_z = '0')
        report "Fail: en_x/en_y/en_z deveriam ser '0' em S2" severity error;
        assert(pronto = '0')
        report "Fail: pronto deveria ser '0' em S2" severity error;

        -- ===================== TESTE 4: S2 -> S3 -> S2 (loop CORDIC, menor='1') =====================
        menor  <= '1';
        z_sign <= '0'; -- testa ramo op_x='1', op_y='0', op_z='1'
        wait until rising_edge(clk);
        wait for 1 ns;
        -- Deve estar em S3
        assert(zi = '0' and ci = '1' and init_sel = '0')
        report "Fail: zi/ci/init_sel incorretos em S3" severity error;
        assert(en_x = '1' and en_y = '1' and en_z = '1')
        report "Fail: en_x/en_y/en_z deveriam ser '1' em S3" severity error;
        assert(op_x = '1' and op_y = '0' and op_z = '1')
        report "Fail: op_x/op_y/op_z incorretos em S3 com z_sign='0'" severity error;

        -- Volta para S2
        wait until rising_edge(clk);
        wait for 1 ns;
        assert(en_x = '0' and en_y = '0' and en_z = '0')
        report "Fail: deveria estar de volta em S2 (sinais zerados)" severity error;

        -- Testa o outro ramo de z_sign em S3
        z_sign <= '1';
        wait until rising_edge(clk); -- volta para S3
        wait for 1 ns;
        assert(op_x = '0' and op_y = '1' and op_z = '0')
        report "Fail: op_x/op_y/op_z incorretos em S3 com z_sign='1'" severity error;

        wait until rising_edge(clk); -- volta para S2
        wait for 1 ns;

        -- ===================== TESTE 5: S2 -> S4 (fim do loop, menor='0') =====================
        menor <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;
        -- Deve estar em S4
        assert(zi = '1' and ci = '1' and init_sel = '1')
        report "Fail: zi/ci/init_sel deveriam ser '1' em S4" severity error;
        assert(en_z = '1')
        report "Fail: en_z deveria ser '1' em S4" severity error;
        assert(en_out_trig = '1')
        report "Fail: en_out_trig deveria ser '1' em S4" severity error;
        assert(en_x = '0' and en_y = '0')
        report "Fail: en_x/en_y deveriam ser '0' em S4" severity error;
        assert(pronto = '0')
        report "Fail: pronto deveria ainda ser '0' em S4" severity error;

        -- ===================== TESTE 6: S4 -> S0 (retorno ao estado de espera) =====================
        wait until rising_edge(clk);
        wait for 1 ns;
        assert(pronto = '1')
        report "Fail: pronto deveria ser '1' de volta em S0" severity error;
        assert(en_out_trig = '0')
        report "Fail: en_out_trig deveria voltar a '0' em S0" severity error;
        assert(zi = '0' and ci = '0' and init_sel = '0' and en_z = '0')
        report "Fail: sinais deveriam estar zerados de volta em S0" severity error;

        -- ===================== TESTE 7: Ciclo completo com varias iteracoes (i=0 a 15) =====================
        -- Simula um ciclo real: inicia, e percorre S2/S3 dezesseis vezes antes
        -- de ir para S4, simulando o comportamento de 'menor' vindo do contador real.
        iniciar <= '1';
        wait until rising_edge(clk); -- S0 -> S1
        wait for 1 ns;
        iniciar <= '0';

        wait until rising_edge(clk); -- S1 -> S2
        wait for 1 ns;

        menor <= '1';
        for k in 0 to 14 loop
            wait until rising_edge(clk); -- S2 -> S3
            wait for 1 ns;
            assert(en_x = '1' and en_y = '1' and en_z = '1')
            report "Fail: en_x/en_y/en_z deveriam ser '1' em S3 (iteracao " & integer'image(k) & ")" severity error;
            wait until rising_edge(clk); -- S3 -> S2
            wait for 1 ns;
        end loop;

        -- Ultima iteracao (i=15): menor ainda '1' (i<16), entao ainda vai para S3
        wait until rising_edge(clk); -- S2 -> S3 (i=15)
        wait for 1 ns;
        wait until rising_edge(clk); -- S3 -> S2
        wait for 1 ns;

        -- Agora i=16 (out of range no contador), menor='0'
        menor <= '0';
        wait until rising_edge(clk); -- S2 -> S4
        wait for 1 ns;
        assert(en_out_trig = '1')
        report "Fail: en_out_trig deveria ser '1' em S4 apos 16 iteracoes" severity error;

        wait until rising_edge(clk); -- S4 -> S0
        wait for 1 ns;
        assert(pronto = '1')
        report "Fail: pronto deveria ser '1' apos ciclo completo de 16 iteracoes" severity error;

        -- ===================== TESTE 8: Reset no meio de uma operacao =====================
        iniciar <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        iniciar <= '0';
        -- Deve estar em S1 agora; aplica reset
        reset <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        assert(pronto = '1')
        report "Fail: reset deveria forcar retorno a S0 (pronto='1')" severity error;
        reset <= '0';

        wait for passo;
        assert false report "Test done." severity note;
        fim_simulacao <= true;
        wait;
    end process;

end tb;