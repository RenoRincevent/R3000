LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;
LIBRARY CombinationalTools;
USE CombinationalTools.ALL;

ENTITY test IS
END ENTITY;

ARCHITECTURE arc OF test IS
    Constant shift_size : integer := 5;
    constant shifter_width : integer := 32;
    Signal input : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    Signal shift_amount : STD_LOGIC_VECTOR(shift_size-1 DOWNTO 0) := (others => '0');
    Signal LeftRight : STD_LOGIC := '0';
    Signal LogicArith : STD_LOGIC := '0';
    Signal ShiftRotate : STD_LOGIC := '0';
    Signal output : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
BEGIN
    --test du circuit decoder
    inst_bshifter : ENTITY CombinationalTools.barrel_shifter(fdd_b_shifter) generic Map (shift_size,shifter_width) PORT MAP (input,shift_amount,LeftRight,LogicArith,ShiftRotate,output);
    PROCESS 
    BEGIN
        input <= conv_std_logic_vector(251658255,input'length);
        --Test du sll
        FOR I IN 0 to shifter_width-1 LOOP
            shift_amount <= conv_std_logic_vector(I,shift_amount'length);
            WAIT FOR 5 ns;
        END LOOP;
        
        --test du rol
        LeftRight <= '0';
        ShiftRotate <= '1';
        FOR I IN 0 to shifter_width-1 LOOP
            shift_amount <= conv_std_logic_vector(I,shift_amount'length);
            WAIT FOR 5 ns;
        END LOOP;
        
        --test du sla
        LeftRight <= '0';
        LogicArith <= '1';
        ShiftRotate <= '0';
        FOR I IN 0 to shifter_width-1 LOOP
            shift_amount <= conv_std_logic_vector(I,shift_amount'length);
            WAIT FOR 5 ns;
        END LOOP;
        
        --test du srl
        LeftRight <= '1';
        LogicArith <= '0';
        ShiftRotate <= '0';
        FOR I IN 0 to shifter_width-1 LOOP
            shift_amount <= conv_std_logic_vector(I,shift_amount'length);
            WAIT FOR 5 ns;
        END LOOP;
        
        --test du ror
        LeftRight <= '1';
        ShiftRotate <= '1';
        FOR I IN 0 to shifter_width-1 LOOP
            shift_amount <= conv_std_logic_vector(I,shift_amount'length);
            WAIT FOR 5 ns;
        END LOOP;
        
        --test du sra
        LeftRight <= '1';
        LogicArith <= '1';
        ShiftRotate <= '0';
        FOR I IN 0 to shifter_width-1 LOOP
            shift_amount <= conv_std_logic_vector(I,shift_amount'length);
            WAIT FOR 5 ns;
        END LOOP;
        WAIT; --pour terminer le test bench
    END PROCESS;
END ARCHITECTURE;
 
