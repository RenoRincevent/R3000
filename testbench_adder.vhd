LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;

ENTITY test IS
END ENTITY;

Architecture arc of test is
    Constant word_size : INTEGER :=32;
    Signal op_0 : STD_LOGIC_VECTOR(word_size-1 DOWNTO 0);
    Signal op_1 : STD_LOGIC_VECTOR(word_size-1 DOWNTO 0);
    Signal sum : STD_LOGIC_VECTOR(word_size-1 DOWNTO 0);
    Signal C : STD_LOGIC;
begin
    inst_add : entity work.adder(comp_adder) generic Map (word_size) Port Map(op_0,op_1,sum,C);
    Process
    Begin
        op_0 <= conv_std_logic_vector(1,op_0'length);
        --Au dernier tour de boucle la somme vaut 2**32 donc trop grand pour le vecteur, une retenue est retourné.
        for i in 0 to word_size loop
            op_1 <= conv_std_logic_vector((2**i)-1,op_1'length);
            wait for 5 ns;
        end loop;
        wait;
    end process;
End architecture;
