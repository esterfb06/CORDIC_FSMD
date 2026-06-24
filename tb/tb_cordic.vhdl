library IEEE;
use IEEE.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity tb_cordic is
end tb_cordic;

architecture tb of tb_cordic is

        signal    clk         : std_logic;
        signal    reset       : std_logic;
        signal    iniciar     : std_logic;
        signal    sw_angulo   : std_logic_vector(15 downto 0);
            
        signal    pronto      : std_logic;
        signal    seno_out    : std_logic_vector(15 downto 0);
        signal    cosseno_out : std_logic_vector(15 downto 0);

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

    process
    begin
        reset <= '1';
        iniciar <='0';
        wait for passo;
        reset <= '0';
        wait for passo;

        sw_angulo <= std_logic_vector(to_signed(30, 16));
        iniciar <= '1';
        wait for passo;
        iniciar <= '0';
        
        wait until pronto = '1';
        wait for passo;
        assert false report "Simualação finalizada com sucesso";
        wait;
    end process;

end tb;