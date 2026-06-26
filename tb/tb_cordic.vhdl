library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cordic is
end tb_cordic;

architecture tb of tb_cordic is

    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal iniciar     : std_logic := '0';
    signal sw_angulo   : std_logic_vector(15 downto 0) := (others => '0');
            
    signal pronto      : std_logic;
    signal seno_out    : std_logic_vector(15 downto 0);
    signal cosseno_out : std_logic_vector(15 downto 0);

    signal sim_done    : boolean := false;
    constant passo     : time := 20 ns;

begin
    -- Instanciação do DUV
    DUV: entity work.cordic_top
        port map (
            clk         => clk,
            reset       => reset,
            iniciar     => iniciar,
            sw_angulo   => sw_angulo,
            pronto      => pronto,
            seno_out    => seno_out,
            cosseno_out => cosseno_out
        );

    -- 1. Processo Gerador de Clock
    process_clk: process
    begin
        while not sim_done loop
            clk <= '0';
            wait for passo / 2;
            clk <= '1';
            wait for passo / 2;
        end loop;
        wait; 
    end process;

    -- 2. Processo de Estímulos e Verificação Automática
    process_stim: process
        -- Variáveis para simplificar a matemática dos asserts
        variable v_seno      : integer;
        variable v_cosseno   : integer;
        
        -- Tolerância de erro devido à aproximação natural do CORDIC (ex: +/- 20)
        constant TOLERANCIA  : integer := 20; 
    begin
        -- ========================================================
        -- INICIALIZAÇÃO
        -- ========================================================
        reset <= '1';
        iniciar <= '0';
        wait for passo * 2;
        reset <= '0';
        wait for passo;

        -- ========================================================
        -- TESTE 1: 30 graus
        -- Calculo do angulo: 0.523598 rad * 16384 = 8579
        -- Esperado: Sen = 0.5 (8192), Cos = ~0.8660 (14189)
        -- ========================================================
        sw_angulo <= std_logic_vector(to_signed(8579, 16));
        wait for passo;
        iniciar <= '1';
        wait for passo;
        iniciar <= '0';
        
        wait until pronto = '1';
        wait for passo / 2; -- Atraso para amostragem segura
        
        v_seno := to_integer(signed(seno_out));
        v_cosseno := to_integer(signed(cosseno_out));
        
        assert (abs(v_seno - 8192) <= TOLERANCIA) 
            report "Falha no Seno de 30. Obtido: " & integer'image(v_seno) severity error;
        assert (abs(v_cosseno - 14189) <= TOLERANCIA) 
            report "Falha no Cosseno de 30. Obtido: " & integer'image(v_cosseno) severity error;
        
        wait for passo * 2;

        -- ========================================================
        -- TESTE 2: 0 graus
        -- Calculo do angulo: 0.0 rad * 16384 = 0
        -- Esperado: Sen = 0 (0), Cos = 1.0 (16384)
        -- ========================================================
        sw_angulo <= std_logic_vector(to_signed(0, 16));
        wait for passo;
        iniciar <= '1';
        wait for passo;
        iniciar <= '0';
        
        wait until pronto = '1';
        wait for passo / 2;
        
        v_seno := to_integer(signed(seno_out));
        v_cosseno := to_integer(signed(cosseno_out));
        
        assert (abs(v_seno - 0) <= TOLERANCIA) 
            report "Falha no Seno de 0. Obtido: " & integer'image(v_seno) severity error;
        assert (abs(v_cosseno - 16384) <= TOLERANCIA) 
            report "Falha no Cosseno de 0. Obtido: " & integer'image(v_cosseno) severity error;

        wait for passo * 2;

        -- ========================================================
        -- TESTE 3: 45 graus
        -- Calculo do angulo: 0.785398 rad * 16384 = 12868
        -- Esperado: Sen = ~0.7071 (11585), Cos = ~0.7071 (11585)
        -- ========================================================
        sw_angulo <= std_logic_vector(to_signed(12868, 16));
        wait for passo;
        iniciar <= '1';
        wait for passo;
        iniciar <= '0';
        
        wait until pronto = '1';
        wait for passo / 2;
        
        v_seno := to_integer(signed(seno_out));
        v_cosseno := to_integer(signed(cosseno_out));
        
        assert (abs(v_seno - 11585) <= TOLERANCIA) 
            report "Falha no Seno de 45. Obtido: " & integer'image(v_seno) severity error;
        assert (abs(v_cosseno - 11585) <= TOLERANCIA) 
            report "Falha no Cosseno de 45. Obtido: " & integer'image(v_cosseno) severity error;

        wait for passo * 2;

        -- ========================================================
        -- TESTE 4: 60 graus
        -- Calculo do angulo: 1.047197 rad * 16384 = 17157
        -- Esperado: Sen = ~0.8660 (14189), Cos = 0.5 (8192)
        -- ========================================================
        sw_angulo <= std_logic_vector(to_signed(17157, 16));
        wait for passo;
        iniciar <= '1';
        wait for passo;
        iniciar <= '0';
        
        wait until pronto = '1';
        wait for passo / 2;
        
        v_seno := to_integer(signed(seno_out));
        v_cosseno := to_integer(signed(cosseno_out));
        
        assert (abs(v_seno - 14189) <= TOLERANCIA) 
            report "Falha no Seno de 60. Obtido: " & integer'image(v_seno) severity error;
        assert (abs(v_cosseno - 8192) <= TOLERANCIA) 
            report "Falha no Cosseno de 60. Obtido: " & integer'image(v_cosseno) severity error;

        wait for passo * 2;

        -- ========================================================
        -- TESTE 5: -45 graus (Teste de ângulo negativo)
        -- Calculo do angulo: -0.785398 rad * 16384 = -12868
        -- Esperado: Sen = ~ -0.7071 (-11585), Cos = ~0.7071 (11585)
        -- ========================================================
        sw_angulo <= std_logic_vector(to_signed(-12868, 16));
        wait for passo;
        iniciar <= '1';
        wait for passo;
        iniciar <= '0';
        
        wait until pronto = '1';
        wait for passo / 2;
        
        v_seno := to_integer(signed(seno_out));
        v_cosseno := to_integer(signed(cosseno_out));
        
        assert (abs(v_seno - (-11585)) <= TOLERANCIA) 
            report "Falha no Seno de -45. Obtido: " & integer'image(v_seno) severity error;
        assert (abs(v_cosseno - 11585) <= TOLERANCIA) 
            report "Falha no Cosseno de -45. Obtido: " & integer'image(v_cosseno) severity error;

        wait for passo * 2;

        -- ========================================================
        -- TESTE 6: 90 graus (Limite superior do CORDIC)
        -- Calculo do angulo: 1.570796 rad * 16384 = 25736
        -- Esperado: Sen = 1.0 (16384), Cos = 0.0 (0)
        -- ========================================================
        sw_angulo <= std_logic_vector(to_signed(25736, 16));
        wait for passo;
        iniciar <= '1';
        wait for passo;
        iniciar <= '0';
        
        wait until pronto = '1';
        wait for passo / 2;
        
        v_seno := to_integer(signed(seno_out));
        v_cosseno := to_integer(signed(cosseno_out));
        
        assert (abs(v_seno - 16384) <= TOLERANCIA) 
            report "Falha no Seno de 90. Obtido: " & integer'image(v_seno) severity error;
        assert (abs(v_cosseno - 0) <= TOLERANCIA) 
            report "Falha no Cosseno de 90. Obtido: " & integer'image(v_cosseno) severity error;

        wait for passo * 2;

        -- ========================================================
        -- FINALIZAÇÃO
        -- ========================================================
        sim_done <= true;
        
        assert false report "Test done." severity note;
        wait;
    end process;

end tb;