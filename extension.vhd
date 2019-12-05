LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY CombinationalTools;
USE CombinationalTools.bus_mux_pkg.ALL;
LIBRARY SequentialTools;
USE SequentialTools.ALL;

ENTITY Extension IS
	PORT
	(
		OpExt : IN STD_LOGIC;
		inst : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END ENTITY Extension; 

architecture fdd_extension of Extension Is
begin
    output <= (31 downto 16 => '0') & inst when OpExt = '0'
        else (31 downto 16 => inst(15)) & inst;
end architecture fdd_extension; 
