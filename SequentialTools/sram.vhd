LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY SRAM_DPS IS
	GENERIC (
		address_width : NATURAL := 8;
		data_bus_width : NATURAL := 8
	);
	PORT (
		address : IN STD_LOGIC_VECTOR(address_width-1 DOWNTO 0);
		data_in : IN STD_LOGIC_VECTOR(data_bus_width-1 DOWNTO 0); 
		data_out : OUT STD_LOGIC_VECTOR(data_bus_width-1 DOWNTO 0); 
		WE, CS, OE, CLK : IN STD_LOGIC
	);
END ENTITY SRAM_DPS; 

Architecture comp_Sram of SRAM_DPS Is 
    type ram is array (0 to (2**address_width)-1) of std_logic_vector(data_bus_width-1 downto 0); --256 octets
    signal blockRam : ram := (others => (others => '0'));
begin
    process(CS,WE,OE,CLK) 
    begin
        if CS = '1' then --Circuit mémoire désactivé, bus de sortie à haute impédance
            data_out <= (others => 'Z');
        else --cs = '0' le circuit fonctionne en lecture/ecriture
            if rising_edge(CLK) and WE = '0' then --écriture
                blockRam(to_integer(unsigned(address))) <= data_in;
            end if;
            if WE = '1' and OE ='0' then --lecture
                data_out <= blockRam(to_integer(unsigned(address)));
            end if;
        end if;
    end process;
End Architecture comp_Sram;
