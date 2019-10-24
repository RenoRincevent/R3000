LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY decoder IS
    GENERIC
    (
        dec_size : INTEGER := 3
    );
    PORT 
    (
        input : IN STD_LOGIC_VECTOR(dec_size-1 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR((2**dec_size)-1 DOWNTO 0)
    );
END ENTITY decoder;

ARCHITECTURE fdd_decoder OF decoder IS
    SIGNAL S : STD_LOGIC_VECTOR((2**dec_size)-1 DOWNTO 0) := (others => '0');
BEGIN
    output <= S;
    GEN_DEC: 
    for i in output'range generate 
        S(i) <= '1' when i = unsigned(input) else '0';
    end generate GEN_DEC;

END ARCHITECTURE fdd_decoder;
--------   Description comportementale ---------
--     output <= S;
--     process(input)
--         variable tmp: std_logic_vector(output'range);
--     begin
--         tmp := (others => '0');
--         tmp(to_integer(unsigned(input))) := '1';
--         S <= tmp;
--     end process;

-- Description comportementale non séquentielle
--     process(input)
--     begin
--         S <= (others => '0');
--         S(to_integer(unsigned(input))) <= '1';
--     end process;


-- mux generic 
-- LIBRARY IEEE;
-- USE IEEE.STD_LOGIC_1164.ALL;
-- USE work.my_data_types.all;
-- -------------------------------------------------------------------------------------------------------------
-- ENTITY generic_mux IS
-- GENERIC (  inputs: INTEGER := 16;                     -- number of inputs
--                        size : INTEGER := 8);                         -- size of each input
-- 
-- PORT  (        input  :  IN MATRIX (0 TO inputs-1, size-1 DOWNTO 0);
--                       sel      :  IN INTEGER RANGE 0 TO inputs-1;
--                       output : OUT STD_LOGIC_VECTOR (size-1 DOWNTO 0));
-- 
--  
-- 
-- END generic_mux;
-- 
-- -------------------------------------------------------------------------------------------------------------
-- ARCHITECTURE behavioral OF generic_mux IS
-- BEGIN
--               gen: FOR i IN size-1 DOWNTO 0 GENERATE
--                         output(i) <= input(sel, i);
--              END GENERATE gen;
-- END behavioral;


-- Registre parrallèle on lit les 32 bit en meme temps, inverse du registre a décalage
