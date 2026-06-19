library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cordic_bo is
    port(
        clk             : in std_logic;

        sw_angulo       : in std_logic_vector(15 downto 0);
        zi              : in std_logic;
        ci              : in std_logic;
        init_sel        : in std_logic;
        trig_tg         : in std_logic;
        en_x            : in std_logic;
        en_y            : in std_logic;
        en_z            : in std_logic;
        en_out_trig     : in std_logic;
        en_out_tg       : in std_logic;
        op_x            : in std_logic;
        op_y            : in std_logic;
        op_z            : in std_logic;

        menor           : out std_logic;
        z_sign          : out std_logic;
        y_sign          : out std_logic;

        seno_out        : out std_logic_vector(15 downto 0);
        cosseno_out     : out std_logic_vector(15 downto 0);
        tg_out          : out std_logic_vector(15 downto 0)
    );
end cordic_bo;

architecture structure OF cordic_bo is
    -- Constante de Ganho K (0.6072 em Q1.14 = 9949)
    constant K_CONST : std_logic_vector(15 downto 0) := "0010011011011101";
    constant ZERO_16 : std_logic_vector(15 downto 0) := "0000000000000000";

    --Bloco contador de iterações
    signal out_mux_i          : std_logic_vector(4 downto 0);
    signal out_reg_i          : std_logic_vector(4 downto 0);
    signal out_add_i          : std_logic_vector(4 downto 0);

    -- Bloco de calculo do cosseno
    signal out_mux_x          : std_logic_vector(15 downto 0);
    signal out_reg_x          : std_logic_vector(15 downto 0);
    signal out_add_sub_x          : std_logic_vector(15 downto 0);
    signal out_shift_x        : std_logic_vector(15 downto 0);

    --Bloco de calculo do seno
    signal out_shift_y        : std_logic_vector(15 downto 0);

begin
    --Contador de iterações
    mux_i: entity work.mux_2to1(behavior)
        generic map (N => 5 )
        port map (in_1=> "00000", in_0 => out_add_i, sel => zi, y => out_mux_i);
    reg_i: entity work.register_en(behavior)
        generic map (N => 5)
        port map (clk => clk, enable => ci, d => out_mux_i, q => out_reg_i);
    menor <= NOT(out_reg_i(4));
    add_i: entity work.add_sub(behavior)
        generic map (N => 5)
        port map (op => '0', input_a => out_reg_i, input_b => "00001", result => out_add_i);
    
    -- Bloco de calculo do cosseno
    mux_x: entity work.mux_2to1(behavior)
        generic map (N => 16)
        port map (in_1 => K_CONST, in_0 => out_add_sub_x, sel => init_sel, y => out_mux_x);
    reg_x: entity work.register_en(behavior)
        generic map (N => 16)
        port map (clk => clk, enable => en_x, d => out_mux_x, q => out_reg_x);
    add_sub_x: entity work.add_sub(behavior)
        generic map (N => 16)
        port map (op => op_x, input_a => out_reg_x, input_b => out_shift_y, result => out_add_sub_x);
    reg_ox: entity work.register_en(behavior)
        generic map (N => 16)
        port map (clk => clk, enable => en_out_trig, d => out_reg_x, q => cosseno_out);
    shift_x: entity work.deslocador(behavior)
        generic map (N => 16, S => 5)
        port map (dado_in => out_reg_x, shift_valor => out_reg_i, dado_out => out_shift_x);

end architecture structure;