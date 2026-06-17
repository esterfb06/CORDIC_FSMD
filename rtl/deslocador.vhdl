library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Deslocador Aritmético para a Direita
-- Desloca dado_in em shift_valor posições para a direita
entity deslocador is
    generic(
        N : positive := 16;
        S : positive := 5   
    );
    port(
        dado_in   : in  std_logic_vector(N - 1 downto 0);
        shift_valor : in  std_logic_vector(S - 1 downto 0); 
        dado_out  : out std_logic_vector(N - 1 downto 0)
    );
end deslocador;

architecture behavior of deslocador is
begin

    dado_out <= std_logic_vector(shift_right(signed(dado_in), to_integer(unsigned(shift_valor))));

end architecture behavior;