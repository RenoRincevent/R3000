LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;
LIBRARY CombinationalTools;
USE CombinationalTools.ALL;

ENTITY test IS
END ENTITY;

ARCHITECTURE arc OF test IS
    CONSTANT dec_size : integer := 3;
    SIGNAL IdecFDD : STD_LOGIC_VECTOR(dec_size-1 DOWNTO 0) := (others => '0');
    SIGNAL OdecFDD : STD_LOGIC_VECTOR((2**dec_size)-1 DOWNTO 0) := (others => '0');
    SIGNAL IdecCOMP : STD_LOGIC_VECTOR(dec_size-1 DOWNTO 0) := (others => '0');
    SIGNAL OdecCOMP : STD_LOGIC_VECTOR((2**dec_size)-1 DOWNTO 0) := (others => '0');
BEGIN
    --test du circuit decoder
    inst_dec_fdd : ENTITY CombinationalTools.decoder(fdd_decoder) generic Map (dec_size) PORT MAP (IdecFDD, OdecFDD);
    inst_dec_comp : ENTITY CombinationalTools.decoder(comp_decoder) generic Map (dec_size) PORT MAP (IdecCOMP, OdecCOMP);
    PROCESS 
    BEGIN
        FOR I IN 0 to (2**dec_size)-1 LOOP
            IdecFDD <= conv_std_logic_vector(I,IdecFDD'length);
            IdecCOMP <= conv_std_logic_vector(I,IdecCOMP'length);
            WAIT FOR 5 ns;
        END LOOP;
        WAIT; --pour terminer le test bench
    END PROCESS;
END ARCHITECTURE;
