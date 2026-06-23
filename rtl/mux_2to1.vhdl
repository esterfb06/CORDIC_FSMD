library ieee;
use ieee.std_logic_1164.all;

-- Multiplexador 2:1 com entradas e saída de N bits.
-- A seleção é feita com base no sinal `sel`.
-- Se sel = '0', então y = in_0; caso contrário, y = in_1.
entity mux_2to1 is
	generic(
		N : positive  -- número de bits das entradas e da saída
	);
	port(
		sel        : in  std_logic;                        -- sinal de seleção
		in_0, in_1 : in  std_logic_vector(N - 1 downto 0); -- entradas do mux
		y          : out std_logic_vector(N - 1 downto 0)  -- saída do mux
	);
end mux_2to1;

architecture behavior of mux_2to1 is
begin
MUX: process(sel, in_0, in_1)
begin
    if sel = '0' then
    y <= in_0;
    else
    y <= in_1;
    end if;
end process;


end architecture behavior;