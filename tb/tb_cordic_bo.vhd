library IEEE;
use IEEE.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity tb_cordic_bo is
end tb_cordic_bo;

architecture tb of tb_cordic_bo is

    signal clk         : std_logic := '0';

    signal sw_angulo   : std_logic_vector(15 downto 0);
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

    signal menor       : std_logic;
    signal z_sign      : std_logic;

    signal seno_out    : std_logic_vector(15 downto 0);
    signal cosseno_out : std_logic_vector(15 downto 0);

    constant periodo_clk : TIME := 10 ns;
    constant passo        : TIME := 20 ns;

    signal fim_simulacao : boolean := false;

    constant K_CONST : std_logic_vector(15 downto 0) := "0010011011011101";

    -- Valor de arctan(2^-0) na LUT = i=0 -> 12868 (0011001001000100)
    constant ARCTAN_0 : std_logic_vector(15 downto 0) := "0011001001000100";

begin
    -- Connect DUV
    DUV: entity work.cordic_bo
        port map (
            clk         => clk,
            sw_angulo   => sw_angulo,
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
            menor       => menor,
            z_sign      => z_sign,
            seno_out    => seno_out,
            cosseno_out => cosseno_out
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
        -- Valores iniciais para evitar 'U' em sinais nao usados neste teste
        sw_angulo <= (others => '0');

        -- ===================== TESTE 1: Reset do contador de iteracoes =====================
        -- zi='1', ci='1' -> mux seleciona "00000" e registrador captura na borda
        zi       <= '1';
        ci       <= '1';
        init_sel <= '0';
        en_x     <= '0';
        en_y     <= '0';
        en_z     <= '0';
        op_x     <= '0';
        op_y     <= '0';
        op_z     <= '0';
        wait until rising_edge(clk);
        wait for 1 ns;

        -- Apos reset, i = 0 ("00000"), bit4 = '0' -> menor = NOT('0') = '1'
        assert(menor = '1')
        report "Fail: menor deveria ser '1' apos reset do contador (i=0)" severity error;

        -- ===================== TESTE 2: Incremento do contador =====================
        zi <= '0'; -- mux passa a selecionar out_add_i (i+1)
        ci <= '1';
        for k in 1 to 14 loop
            wait until rising_edge(clk);
        end loop;
        wait for 1 ns;
        -- Apos 14 incrementos a partir de 0, i = 14 ("01110"), bit4 = '0' -> menor = '1'
        assert(menor = '1')
        report "Fail: menor deveria ser '1' com i=14" severity error;

        -- Mais 2 incrementos: i=15 (bit4='0'), i=16 (bit4='1') -> menor='0'
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait for 1 ns;
        assert(menor = '0')
        report "Fail: menor deveria ser '0' com i=16 (bit4='1')" severity error;

        -- ===================== TESTE 3: ci='0' nao deve alterar o contador =====================
        ci <= '0';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait for 1 ns;
        assert(menor = '0')
        report "Fail: contador nao deveria mudar com ci='0' (menor deveria continuar '0')" severity error;

        -- Reseta o contador para o proximo teste
        zi <= '1';
        ci <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        assert(menor = '1')
        report "Fail: contador deveria resetar para i=0 (menor='1')" severity error;

        -- ===================== TESTE 4: Inicializacao de x, y e z (init_sel='1') =====================
        sw_angulo <= std_logic_vector(to_signed(8000, 16)); -- valor arbitrario para z inicial
        init_sel  <= '1';
        en_x      <= '1';
        en_y      <= '1';
        en_z      <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;

        -- z_sign deve refletir o bit de sinal de z apos a inicializacao (8000 -> positivo -> bit15='0')
        assert(z_sign = '0')
        report "Fail: z_sign deveria ser '0' apos inicializar z com valor positivo (8000)" severity error;

        -- Captura as saidas finais (en_out_trig habilita os registradores de saida)
        en_out_trig <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;

        assert(cosseno_out = K_CONST)
        report "Fail: cosseno_out deveria ser K_CONST apos inicializacao (init_sel='1')" severity error;
        assert(seno_out = "0000000000000000")
        report "Fail: seno_out deveria ser 0 apos inicializacao (init_sel='1')" severity error;

        -- ===================== TESTE 5: Inicializacao de z com valor negativo =====================
        en_out_trig <= '0';
        zi          <= '1';
        ci          <= '1';
        sw_angulo   <= std_logic_vector(to_signed(-8000, 16));
        init_sel    <= '1';
        en_z        <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;
        assert(z_sign = '1')
        report "Fail: z_sign deveria ser '1' apos inicializar z com valor negativo (-8000)" severity error;

        -- ===================== TESTE 6: Uma iteracao completa do bloco Z (i=0, op_z='1') =====================
        -- Reinicia z com um valor conhecido e positivo, depois subtrai arctan(2^-0)
        zi        <= '1';
        ci        <= '1';
        sw_angulo <= std_logic_vector(to_signed(20000, 16));
        init_sel  <= '1';
        en_z      <= '1';
        wait until rising_edge(clk); -- z = 20000, i = 0
        wait for 1 ns;

        -- Agora aplica uma iteracao: z = z - arctan(2^-0) = 20000 - 12868 = 7132
        zi       <= '0';
        ci       <= '1'; -- incrementa i tambem
        init_sel <= '0';
        en_z     <= '1';
        op_z     <= '1'; -- z = z - mem(i)
        wait until rising_edge(clk);
        wait for 1 ns;

        assert(z_sign = '0')
        report "Fail: z_sign deveria ser '0' apos z = 20000 - 12868 = 7132 (positivo)" severity error;

        -- ===================== TESTE 7: en_x/en_y='0' nao deve atualizar os registradores =====================
        zi          <= '1';
        ci          <= '1';
        init_sel    <= '1';
        en_x        <= '1';
        en_y        <= '1';
        wait until rising_edge(clk); -- reinicializa x=K_CONST, y=0
        wait for 1 ns;

        init_sel <= '0';
        en_x     <= '0';
        en_y     <= '0';
        op_x     <= '1';
        op_y     <= '0';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait for 1 ns;

        en_out_trig <= '1';
        wait until rising_edge(clk);
        wait for 1 ns;

        -- Como en_x/en_y ficaram em '0', os registradores internos nao mudaram
        assert(cosseno_out = K_CONST)
        report "Fail: cosseno_out nao deveria mudar com en_x='0'" severity error;
        assert(seno_out = "0000000000000000")
        report "Fail: seno_out nao deveria mudar com en_y='0'" severity error;

        wait for passo;
        assert false report "Test done." severity note;
        fim_simulacao <= true;
        wait;
    end process;

end tb;