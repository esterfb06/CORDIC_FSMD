library ieee;
use ieee.std_logic_1164.all;


-- Bloco de Controle (BC) do circuito CORDIC.
-- Responsável por gerar os sinais de controle para o bloco operativo (BO),
-- geralmente por meio de uma FSM.

entity cordic_bc is
    port(
        -- Entradas do Sistema
        clk         : in std_logic;
        reset       : in std_logic;
        iniciar     : in std_logic;
        -- Entradas de Status (vindas do BO)
        menor       : in std_logic;
        z_sign      : in std_logic;
        y_sign      : in std_logic;
        -- Saídas de Controle (para o BO)
        zi          : out std_logic;
        ci          : out std_logic;
        init_sel    : out std_logic;
        trig_tg     : out std_logic;
        en_x        : out std_logic;
        en_y        : out std_logic;
        en_z        : out std_logic;
        en_out_trig : out std_logic;
        en_out_tg   : out std_logic;
        op_x        : out std_logic;
        op_y        : out std_logic;
        op_z        : out std_logic;
        -- Saída de Status do Sistema
        pronto      : out std_logic
    );
end cordic_bc;

architecture behavior of cordic_bc is
	Type tipo_Estado is (S0, S1, S2, S3, S4, S5, S6, S7);
	signal estadoAtual, proximoEstado : tipo_Estado;
begin
    -- Preencher aqui (remova este comentário).
    -- Descreva a FSM responsável por coordenar o circuito CORDIC.
    
    State: process (clk, reset)
    begin
        if reset = '1' then
            estadoAtual <= S0;
        elsif (rising_edge(clk)) then
            estadoAtual <= proximoEstado;
        end if;
    end process State;

    LPE: process(estadoAtual, iniciar, menor, z_sign, y_sign)
    begin
        Case estadoAtual is
            When S0 =>
                if iniciar = '1' then
                    proximoEstado <= S1;
                else
                    proximoEstado <= S0;
                end if;
                 
            when S1 =>
                proximoEstado <= S2;

            when S2 =>
                if menor ='1' then
                    proximoEstado <= S3;
                else
                    proximoEstado <= S4;
                end if;
        		
            when S3 =>
                proximoEstado <= S2;

            when S4 =>
                proximoEstado <= S5;

            
            when S5 =>
                if menor = '1' then
                    proximoEstado <= S6;
                else
                    proximoEstado <= S7;
                end if;
            when S6 =>
                proximoEstado <= S5;
            when S7 =>
                proximoEstado <= S0;
        end case;
    end process LPE;

    LS: process(estadoAtual, z_sign, y_sign)
    begin
        -- Inicialização de todos os sinais de controle
        pronto      <= '0';
        zi          <= '0';
        ci          <= '0';
        init_sel    <= '0';
        trig_tg     <= '0';
        en_x        <= '0';
        en_y        <= '0';
        en_z        <= '0';
        en_out_trig <= '0';
        en_out_tg   <= '0';
        op_x        <= '0';
        op_y        <= '0';
        op_z        <= '0';

        case estadoAtual is
        when S0 =>
            pronto <= '1';
		when S1=>
            pronto      <= '0';
            zi          <= '1';
            ci          <= '1';
            init_sel    <= '1';
            trig_tg     <= '0';
            en_x        <= '1';
            en_y        <= '1';
            en_z        <= '1';
        when S2 =>
            null;
        when S3 =>
            zi          <= '0';
            ci          <= '1';
            init_sel    <= '0';
            en_x        <= '1';
            en_y        <= '1';
            en_z        <= '1';

            if z_sign = '0' then
                op_x <= '1';
                op_y <= '0';
                op_z <= '1';
            else
                op_x <= '0'; 
                op_y <= '1';
                op_z <= '0';
            end if;
        when S4 =>
            zi          <= '1';
            ci          <= '1';
            init_sel    <= '1';
            trig_tg     <= '1';
            en_out_trig <= '1';
            en_x        <= '0';
            en_y        <= '0';
            en_z        <= '1';
        when S5 =>
            null;
        when S6 =>
            zi          <= '0';
            ci          <= '1';
            init_sel    <= '0';
            en_x        <= '0';
            en_y        <= '1';
            en_z        <= '1';

            if y_sign = '0' then
                op_y <= '1';
                op_z <= '0';
            else
                op_y <= '0';
                op_z <= '1';
            end if;
        when S7 =>
            en_out_tg   <= '1';
        end case;
    end process LS;
    
end architecture;