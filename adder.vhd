LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY CombinationalTools;
USE CombinationalTools.bus_mux_pkg.ALL;
LIBRARY SequentialTools;
USE SequentialTools.ALL;

ENTITY adder IS
	GENERIC 
	(
		word_size : INTEGER :=32
	);
	PORT
	(
		op_0 : IN STD_LOGIC_VECTOR(word_size-1 DOWNTO 0);
		op_1 : IN STD_LOGIC_VECTOR(word_size-1 DOWNTO 0);
		sum : OUT STD_LOGIC_VECTOR(word_size-1 DOWNTO 0);
		C : OUT STD_LOGIC
	);
END ENTITY adder;

architecture comp_adder of adder Is
    Signal carry : STD_LOGIC_VECTOR(word_size-1 DOWNTO 0);
begin
    sum(0) <= op_0(0) xor op_1(0);
    carry(0) <= op_0(0) and op_1(0);
    
    GEN_ADD:
    for i in 1 to 31 generate 
        sum(i) <= op_0(i) xor op_1(i) xor carry(i-1);
        carry(i) <= (op_0(i) and op_1(i)) or (op_0(i) and carry(i-1)) or (op_1(i) and carry(i-1));
    end generate GEN_ADD;
    
    C <= carry(31);
end architecture comp_adder;
