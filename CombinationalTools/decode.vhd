LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY decoder IS
    GENERIC
    (
        dec_size : INTEGER := 5
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

ARCHITECTURE comp_decoder OF decoder IS
BEGIN
    process(input)
    begin
        output <= (others => '0');
        output(to_integer(unsigned(input))) <= '1';
    end process;
END ARCHITECTURE comp_decoder;

--------   Description comportementale ---------
--     output <= S;
--     process(input)
--         variable tmp: std_logic_vector(output'range);
--     begin
--         tmp := (others => '0');
--         tmp(to_integer(unsigned(input))) := '1';
--         S <= tmp;
--     end process;

-- Description comportementale non séquentielle ?
--     process(input)
--     begin
--         S <= (others => '0');
--         S(to_integer(unsigned(input))) <= '1';
--     end process;



-- Registre parrallèle on lit les 32 bit en meme temps, inverse du registre a décalage
