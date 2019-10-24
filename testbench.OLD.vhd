LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY test IS
END ENTITY;

ARCHITECTURE arc OF test IS
    SIGNAL I2, I1, I0, O3, O2, O1, O0 : STD_LOGIC := '0';
BEGIN
    --test du circuit TP1_EX1
    fdd_DECODE2_4 : ENTITY WORK.DECODE2_4 PORT MAP (I2, I1, I0, O3, O2, O1, O0);
    I2 <= '0', '1' AFTER 60 ns;
    I1 <= '0', '1' AFTER 20 ns, 'U' AFTER 40 ns, '0' AFTER 50 ns;
    I0 <= '0', '1' AFTER 10 ns, '0' AFTER 20 ns, '1' AFTER 30 ns, 'U' AFTER 40 ns, '0' AFTER 50 ns;
END ARCHITECTURE;
