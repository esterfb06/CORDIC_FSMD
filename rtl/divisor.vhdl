library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divisor is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        Ai : in STD_LOGIC_VECTOR(15 downto 0);
        B : IN SIGNED(15 downto 0);
        DIV : OUT STD_LOGIC_VECTOR(15 downto 0)
    );
end divisor;
architecture Comportamento of divisor is
    signal    SEL_A : STD_lOGIC;
    signal    EN_A : STD_LOGIC;
    signal    SEL_COUNT : STD_LOGIC;
    signal    EN_COUNT : STD_LOGIC;
    signal    EN_DIV : STD_LOGIC;
    signal    NEG : STD_LOGIC;

    signal muxA_out : STD_LOGIC_VECTOR(15 downto 0);
    signal regA_out : STD_LOGIC_VECTOR(15 downto 0);
    signal sub_out : STD_LOGIC_VECTOR(15 downto 0);
    signal count_out : STD_LOGIC_VECTOR(15 downto 0);
    signal muxCount_out : STD_LOGIC_VECTOR(15 downto 0);
    signal adder_out : STD_LOGIC_VECTOR(15 downto 0);

    TYPE tipo_estado IS (S0, S1, S2, S3);
    signal estado_atual, proximo_estado : tipo_estado;

begin
    LRE : process (clk, rst)
    begin
        if rst = '1' THEN
            estado_atual <= S0;
        elsif rising_edge(clk) THEN
            estado_atual <= proximo_estado;
        end if;
    end process LRE;

    LPE : process (estado_atual, NEG)
    begin
        CASE estado_atual IS
            WHEN S0 =>
                proximo_estado <= S1;
            WHEN S1 =>
                if (neg = '1') then
                    proximo_estado <= S3;
                else
                    proximo_estado <= S2;
                end if;
            WHEN S2 =>
                proximo_estado <= S1;
            WHEN S3 =>
                proximo_estado <= S3;
        end CASE;
    end process LPE;

    LS : process (estado_atual)
    begin
        SEL_A <= '0';
        EN_A <= '0';
        SEL_COUNT <= '0';
        EN_COUNT <= '0';
        EN_DIV <= '0';

        CASE estado_atual IS
            WHEN S0 =>
                EN_COUNT <= '1';
                EN_A <= '1';
                SEL_A <= '1';
            WHEN S1 =>
                SEL_A <= '0';
                EN_A <= '1';
            WHEN S2 =>
                SEL_COUNT <= '1';
                EN_COUNT <= '1';
            WHEN S3 =>
                EN_DIV <= '1';
        end CASE;
    end process LS;

    muxA_out <= Ai WHEN (SEL_A = '1') ELSE sub_out;
    sub_out <= std_logic_vector(signed(regA_out) - B);

    muxCount_out <= adder_out WHEN (SEL_COUNT = '1') ELSE x"0000";
    adder_out <= std_logic_vector(signed(count_out) + 1);
    NEG <= sub_out(15);

    process(clk, rst)
    begin
        if (rst = '1') then
            regA_out <= x"0000";
            count_out <= x"0000";
            div <= x"0000";
        elsif rising_edge(clk) then
            if (EN_A = '1') then
                regA_out <= muxA_out;
            end if;
            if (EN_COUNT = '1') then
                count_out <= muxCount_out;
            end if;
            if (EN_DIV = '1') then
                DIV <= count_out;
            end if;
        end if;
    end process;

end Comportamento;