LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;

ENTITY test IS
END ENTITY;

Architecture arc of test is
    Signal op : STD_LOGIC_VECTOR(5 DOWNTO 0) := (others => '0');
    Signal f : STD_LOGIC_VECTOR(5 DOWNTO 0) := (others => '0');
    Signal UALOp : STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
    Signal Enable_V : STD_LOGIC := '0';
    Signal Slt_Slti : STD_LOGIC := '0';
    Signal Sel : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
begin
    inst_ual_controler : entity work.UALControler(fdd_ual_controler) Port Map(op,f,UALOp,Enable_V,Slt_Slti,sel);
    Process
    Begin
        --test pour chaque valeur de op, f et ualop
        for i in 0 to 63 loop
            op <= conv_std_logic_vector(i,op'length);
            for j in 0 to 63 loop
                f <= conv_std_logic_vector(j,f'length);
                for k in 0 to 3 loop
                    UALOp <= conv_std_logic_vector(k,UALOp'length);
                    wait for 5 ns;
                end loop;
            end loop;
        end loop;
        wait;
    end process;
End architecture;
