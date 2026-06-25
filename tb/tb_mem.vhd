library IEEE;
use IEEE.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity tb_mem is
end tb_mem;

architecture tb of tb_mem is

    constant N : positive := 16;
    constant S : positive := 5;

    signal endereco : std_logic_vector(S - 1 downto 0);
    signal dado_out  : std_logic_vector(N - 1 downto 0);

    constant passo : TIME := 20 ns;

begin
   
    DUV: entity work.mem
        generic map (
            N => N,
            S => S
        )
        port map (
            endereco => endereco,
            dado_out => dado_out
        );

    process
    begin
	 
        endereco <= std_logic_vector(to_unsigned(0, S));
        wait for passo;
        assert(dado_out = "0011001001000100")
        report "Fail ARCTAN i=0" severity error;

        endereco <= std_logic_vector(to_unsigned(1, S));
        wait for passo;
        assert(dado_out = "0001110110101100")
        report "Fail ARCTAN i=1" severity error;

        endereco <= std_logic_vector(to_unsigned(2, S));
        wait for passo;
        assert(dado_out = "0000111110101110")
        report "Fail ARCTAN i=2" severity error;

        endereco <= std_logic_vector(to_unsigned(3, S));
        wait for passo;
        assert(dado_out = "0000011111110101")
        report "Fail ARCTAN i=3" severity error;

        endereco <= std_logic_vector(to_unsigned(4, S));
        wait for passo;
        assert(dado_out = "0000001111111111")
        report "Fail ARCTAN i=4" severity error;

        endereco <= std_logic_vector(to_unsigned(5, S));
        wait for passo;
        assert(dado_out = "0000001000000000")
        report "Fail ARCTAN i=5" severity error;

        endereco <= std_logic_vector(to_unsigned(6, S));
        wait for passo;
        assert(dado_out = "0000000100000000")
        report "Fail ARCTAN i=6" severity error;

        endereco <= std_logic_vector(to_unsigned(7, S));
        wait for passo;
        assert(dado_out = "0000000010000000")
        report "Fail ARCTAN i=7" severity error;

        endereco <= std_logic_vector(to_unsigned(8, S));
        wait for passo;
        assert(dado_out = "0000000001000000")
        report "Fail ARCTAN i=8" severity error;

        endereco <= std_logic_vector(to_unsigned(9, S));
        wait for passo;
        assert(dado_out = "0000000000100000")
        report "Fail ARCTAN i=9" severity error;

        endereco <= std_logic_vector(to_unsigned(10, S));
        wait for passo;
        assert(dado_out = "0000000000010000")
        report "Fail ARCTAN i=10" severity error;

        endereco <= std_logic_vector(to_unsigned(11, S));
        wait for passo;
        assert(dado_out = "0000000000001000")
        report "Fail ARCTAN i=11" severity error;

        endereco <= std_logic_vector(to_unsigned(12, S));
        wait for passo;
        assert(dado_out = "0000000000000100")
        report "Fail ARCTAN i=12" severity error;

        endereco <= std_logic_vector(to_unsigned(13, S));
        wait for passo;
        assert(dado_out = "0000000000000010")
        report "Fail ARCTAN i=13" severity error;

        endereco <= std_logic_vector(to_unsigned(14, S));
        wait for passo;
        assert(dado_out = "0000000000000001")
        report "Fail ARCTAN i=14" severity error;

        endereco <= std_logic_vector(to_unsigned(15, S));
        wait for passo;
        assert(dado_out = "0000000000000000")
        report "Fail ARCTAN i=15" severity error;

       
        endereco <= std_logic_vector(to_unsigned(16, S));
        wait for passo;
        assert(dado_out = "0000000000000000")
        report "Fail OUT OF RANGE index=16" severity error;

        
        endereco <= std_logic_vector(to_unsigned(31, S));
        wait for passo;
        assert(dado_out = "0000000000000000")
        report "Fail OUT OF RANGE index=31" severity error;

        wait for passo;
        assert false report "Test done." severity note;
        wait;
    end process;

end tb;