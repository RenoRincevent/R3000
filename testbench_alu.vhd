LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;
LIBRARY CombinationalTools;
USE CombinationalTools.bus_mux_pkg.ALL;

ENTITY test IS
END ENTITY;

ARCHITECTURE arc OF test IS
    Signal A : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    Signal B : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    Signal sel : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
    Signal Enable_V : STD_LOGIC := '0';
    Signal ValDec : STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
    Signal Slt : STD_LOGIC := '0';
    Signal CLK : STD_LOGIC := '0';
    Signal Res : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    Signal N : STD_LOGIC := '0';
    Signal Z : STD_LOGIC := '0';
    Signal C : STD_LOGIC := '0';
    Signal V : STD_LOGIC := '0';
BEGIN
    --test du circuit decoder
    inst_alu : ENTITY work.ALU(struct_alu) PORT MAP (A,B,sel,Enable_V,ValDec,Slt,CLK,Res,N,Z,C,V);
    PROCESS 
    BEGIN
        A <= conv_std_logic_vector(8,A'length);
        B <= conv_std_logic_vector(2,B'length);
        Slt <= '0';
        ValDec <= conv_std_logic_vector(1,ValDec'length);
        Enable_V <= '1';
        FOR I IN 0 to 15 LOOP
            sel <= conv_std_logic_vector(I,sel'length);
            WAIT FOR 5 ns;
            CLK <= '1';
            WAIT FOR 5 ns;
            CLK <= '0';
            WAIT FOR 5 ns;
        END LOOP;
        
        --test avec des négatifs
        A <= conv_std_logic_vector(8,A'length);
        B <= conv_std_logic_vector(-9,B'length);
        Slt <= '0';
        ValDec <= conv_std_logic_vector(1,ValDec'length);
        Enable_V <= '1';
        FOR I IN 0 to 15 LOOP
            sel <= conv_std_logic_vector(I,sel'length);
            WAIT FOR 5 ns;
            CLK <= '1';
            WAIT FOR 5 ns;
            CLK <= '0';
            WAIT FOR 5 ns;
        END LOOP;
        WAIT; --pour terminer le test bench
    END PROCESS;
END ARCHITECTURE;
 
 
