library IEEE;
use IEEE.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity tb_cordic is
end tb_cordic;

architecture tb of tb_cordic is

        signal clk         : std_logic := '0';
        signal reset       : std_logic := '0';
        signal iniciar     : std_logic := '0';
        signal sw_angulo   : std_logic_vector(15 downto 0) := (others => '0');
            
        signal    pronto      : std_logic;
        signal    seno_out    : std_logic_vector(15 downto 0);
        signal    cosseno_out : std_logic_vector(15 downto 0);

        -- Flag para interromper o gerador de clock ao fim da simulação
        signal sim_done    : boolean := false;

        constant passo : time := 20 ns;
begin
    -- Connect DUV
    DUV: entity work.cordic_top
        port map (
            clk     => clk,
            reset => reset,
            iniciar    => iniciar,
            sw_angulo => sw_angulo,
            pronto => pronto,
            seno_out => seno_out,
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
        wait; -- Interrompe o processo permanentemente após sim_done ser true
    end process;

    -- 2. Processo de Estímulos
    process_stim: process
    begin
        reset <= '1';
        iniciar <= '0';
        wait for passo * 2;
        reset <= '0';
        wait for passo;

        -- Calculo do angulo: 30 graus = 0.523598 radianos. Em Q1.14: 0.523598 * 16384 = 8579
        sw_angulo <= std_logic_vector(to_signed(8579, 16));
        wait for passo;
        iniciar <= '1';
        wait for passo;
        iniciar <= '0';
        wait until pronto = '1';
        wait for passo * 2;

        -- Calculo do angulo: 0 graus = 0.0 radianos. Em Q1.14: 0.0 * 16384 = 0
        sw_angulo <= std_logic_vector(to_signed(0, 16));
        wait for passo;
        iniciar <= '1';
        wait for passo;
        iniciar <= '0';
        wait until pronto = '1';
        wait for passo * 2;

        -- Calculo do angulo: 45 graus = 0.785398 radianos. Em Q1.14: 0.785398 * 16384 = 12868
        sw_angulo <= std_logic_vector(to_signed(12868, 16));
        wait for passo;
        iniciar <= '1';
        wait for passo;
        iniciar <= '0';
        wait until pronto = '1';
        wait for passo * 2;

        -- Calculo do angulo: 60 graus = 1.047197 radianos. Em Q1.14: 1.047197 * 16384 = 17157
        sw_angulo <= std_logic_vector(to_signed(17157, 16));
        wait for passo;
        iniciar <= '1';
        wait for passo;
        iniciar <= '0';
        wait until pronto = '1';
        wait for passo * 2;

        -- Calculo do angulo: -45 graus = -0.785398 radianos. Em Q1.14: -0.785398 * 16384 = -12868
        sw_angulo <= std_logic_vector(to_signed(-12868, 16));
        wait for passo;
        iniciar <= '1';
        wait for passo;
        iniciar <= '0';
        wait until pronto = '1';
        wait for passo * 2;

        sim_done <= true;
        assert false report "Test done." severity note;
        wait;
    end process;

end tb;