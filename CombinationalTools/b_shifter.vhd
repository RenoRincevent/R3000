LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY CombinationalTools;
USE CombinationalTools.bus_mux_pkg.ALL;


ENTITY barrel_shifter IS
	GENERIC 
	(
		shift_size : INTEGER := 5;
		shifter_width : INTEGER := 32
	);
	PORT
	(
		input : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		shift_amount : IN STD_LOGIC_VECTOR(shift_size-1 DOWNTO 0);
		LeftRight : IN STD_LOGIC;
		LogicArith : IN STD_LOGIC;
		ShiftRotate : IN STD_LOGIC;
		output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END ENTITY barrel_shifter;

architecture fdd_b_shifter of barrel_shifter is
    subtype Sel is STD_LOGIC_VECTOR(2 downto 0);
begin
    with Sel'(LeftRight & LogicArith & ShiftRotate) select
        output <= input sll to_integer(unsigned(shift_amount)) when "000",
            input rol to_integer(unsigned(shift_amount)) when "001",
            to_stdlogicvector(to_bitvector(input) sla to_integer(signed(shift_amount))) when "010",
            input rol to_integer(unsigned(shift_amount)) when "011",
            input srl to_integer(unsigned(shift_amount)) when "100",
            input ror to_integer(unsigned(shift_amount)) when "101",
            to_stdlogicvector(to_bitvector(input) sra to_integer(signed(shift_amount))) when "110",
            input ror to_integer(unsigned(shift_amount)) when "111",
            input when others;
end architecture fdd_b_shifter; 
