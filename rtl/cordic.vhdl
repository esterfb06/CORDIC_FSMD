library ieee;
use ieee.std_logic_1164.all;

entity cordic_top is
    port(
        clk         : in  std_logic;
        reset       : in  std_logic;
        iniciar     : in  std_logic;
        sw_angulo   : in  std_logic_vector(15 downto 0);
        
        pronto      : out std_logic;
        seno_out    : out std_logic_vector(15 downto 0);
        cosseno_out : out std_logic_vector(15 downto 0)
    );
end cordic_top;

architecture structure of cordic_top is

    signal fio_menor       : std_logic;
    signal fio_z_sign      : std_logic;
    
    signal fio_zi          : std_logic;
    signal fio_ci          : std_logic;
    signal fio_init_sel    : std_logic;
    signal fio_en_x        : std_logic;
    signal fio_en_y        : std_logic;
    signal fio_en_z        : std_logic;
    signal fio_en_out_trig : std_logic;
    signal fio_op_x        : std_logic;
    signal fio_op_y        : std_logic;
    signal fio_op_z        : std_logic;

begin

    U_BC: entity work.cordic_bc
        port map(
            clk         => clk,
            reset       => reset,
            iniciar     => iniciar,
            menor       => fio_menor,
            z_sign      => fio_z_sign,
            zi          => fio_zi,
            ci          => fio_ci,
            init_sel    => fio_init_sel,
            en_x        => fio_en_x,
            en_y        => fio_en_y,
            en_z        => fio_en_z,
            en_out_trig => fio_en_out_trig,
            op_x        => fio_op_x,
            op_y        => fio_op_y,
            op_z        => fio_op_z,
            pronto      => pronto
        );

    U_BO: entity work.cordic_bo
        port map(
            clk         => clk,
            sw_angulo   => sw_angulo,
            zi          => fio_zi,
            ci          => fio_ci,
            init_sel    => fio_init_sel,
            en_x        => fio_en_x,
            en_y        => fio_en_y,
            en_z        => fio_en_z,
            en_out_trig => fio_en_out_trig,
            op_x        => fio_op_x,
            op_y        => fio_op_y,
            op_z        => fio_op_z,
            menor       => fio_menor,
            z_sign      => fio_z_sign,
            seno_out    => seno_out,
            cosseno_out => cosseno_out
        );

end architecture structure;