library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Guarda os valores pre-calculados de arctan(2^-i)
-- Formato Q1.14 (1 bit de sinal, 1 bit inteiro, 14 bits fracionarios)
entity mem is
    generic(
        N : positive := 16; -- Tamanho do dado de saída
        S : positive := 5   -- Tamanho do endereço de entrada
    );
    port(
        endereco : in  std_logic_vector(S - 1 downto 0); -- Sinal de 0 a 15
        dado_out : out std_logic_vector(N - 1 downto 0)  -- Valor lido da tabela
    );
end mem;

architecture behavior of mem is

    type rom_type is array (0 to 15) of std_logic_vector(N - 1 downto 0);

    -- Tabela Trigonométrica: arctan(2^-i) em radianos * 16384
    constant LUT_ARCTAN : rom_type := (
        "0011001001000100", -- i=0  (12868) -> 0.785398 rad (45 graus)
        "0001110110101100", -- i=1  (7596)  -> 0.463647 rad
        "0000111110101110", -- i=2  (4014)  -> 0.244978 rad
        "0000011111110101", -- i=3  (2037)  -> 0.124354 rad
        "0000001111111111", -- i=4  (1023)  -> 0.062418 rad
        "0000001000000000", -- i=5  (512)   -> 0.031240 rad
        "0000000100000000", -- i=6  (256)   -> 0.015623 rad
        "0000000010000000", -- i=7  (128)   -> 0.007812 rad
        "0000000001000000", -- i=8  (64)    -> 0.003906 rad
        "0000000000100000", -- i=9  (32)    -> 0.001953 rad
        "0000000000010000", -- i=10 (16)    -> 0.000976 rad
        "0000000000001000", -- i=11 (8)     -> 0.000488 rad
        "0000000000000100", -- i=12 (4)     -> 0.000244 rad
        "0000000000000010", -- i=13 (2)     -> 0.000122 rad
        "0000000000000001", -- i=14 (1)     -> 0.000061 rad
        "0000000000000000"  -- i=15 (0)     -> 0.000030 rad (limite da precisão de 14 casas)
    );

begin
    process(endereco)
        variable index : integer range 0 to 31;
    begin
        index := to_integer(unsigned(endereco));
        
        if index <= 15 then
            dado_out <= LUT_ARCTAN(index);
        else
            dado_out <= (others => '0');
        end if;
    end process;

end architecture behavior;