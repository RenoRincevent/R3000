LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY test IS
END ENTITY;

ARCHITECTURE arc OF test IS
    CONSTANT dec_size : integer := 3;
    SIGNAL Idec : STD_LOGIC_VECTOR(dec_size-1 DOWNTO 0) := (others => '0');
    SIGNAL Odec : STD_LOGIC_VECTOR((2**dec_size)-1 DOWNTO 0) := (others => '0');
BEGIN
    --test du circuit decoder
    fdd_decoder : ENTITY WORK.decoder PORT MAP (Idec, Odec);
    
    PROCESS 
        TYPE TableDeVerite IS ARRAY(0 TO (2**dec_size)-1) OF STD_LOGIC_VECTOR(dec_size-1 DOWNTO 0);
    BEGIN
        FOR I IN 0 to (2**dec_size)-1 LOOP
            Idec <= std_logic_vector(to_unsigned(I,Idec'length));
            WAIT FOR 5 ns;
        END LOOP;
        WAIT; --pour terminer le test bench
    END PROCESS;
END ARCHITECTURE;
