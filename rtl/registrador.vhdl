library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Registrador parametrizável para N bits com controle de enable.
-- O registrador atualiza sua saída 'q' com o valor da entrada 'd' na borda de
-- subida do sinal 'clk', apenas quando 'enable' = '1'.
entity register_en is
    generic(
        N : positive := 16 -- Largura do registrador, pode ser ajustada conforme necessário
    );
    port(
        clk, enable : in  std_logic;
        d           : in  std_logic_vector(N - 1 downto 0); 
        q           : out std_logic_vector(N - 1 downto 0)  
    );
end register_en;

architecture behavior of register_en is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then
                q <= d;
            end if;
        end if;
    end process;

end architecture behavior;