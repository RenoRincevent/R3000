LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;

ENTITY test IS
END ENTITY;

Architecture arc of test is
    Signal OpExt : STD_LOGIC;
    Signal inst : STD_LOGIC_VECTOR(15 DOWNTO 0);
    Signal output : STD_LOGIC_VECTOR(31 DOWNTO 0);
begin
    inst_extension : entity work.Extension(fdd_extension) Port Map(OpExt,inst,output);
    Process
    Begin
        inst <= "1000111000000000";
        OpExt <= '0';
        wait for 5 ns;
        OpExt <= '1';
        wait for 5 ns; 
        inst <= "0000111000000000";
        OpExt <= '0';
        wait for 5 ns;
        OpExt <= '1';
        wait for 5 ns;
        wait;
    end process;
End architecture;
