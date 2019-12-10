LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;
LIBRARY SequentialTools;
USE SequentialTools.ALL;

ENTITY test IS
END ENTITY;

ARCHITECTURE arc OF test IS
    Constant address_width : NATURAL := 8;
    Constant data_bus_width : NATURAL := 8;
    Signal address : STD_LOGIC_VECTOR(address_width-1 DOWNTO 0);
    Signal data_in : STD_LOGIC_VECTOR(data_bus_width-1 DOWNTO 0); 
    Signal data_out : STD_LOGIC_VECTOR(data_bus_width-1 DOWNTO 0); 
    Signal WE, CS, OE, CLK : STD_LOGIC;
begin
    inst_sram : ENTITY SequentialTools.SRAM_DPS(comp_Sram) Generic Map (address_width,data_bus_width) Port Map (address,data_in,data_out,WE,CS,OE,CLK);
    PROCESS 
    BEGIN
        address <= conv_std_logic_vector(1,address'length);
        data_in <= conv_std_logic_vector(4,data_in'length);
        CLK <= '0';
        CS <= '1'; --sortie à haute impédance
        wait for 5 ns;
        CS <= '0'; --ecriture dans un octet
        WE <= '0';
        CLK <= '1';
        wait for 5 ns;
        CLK <= '0'; --lecture dans un octet
        WE <= '1';
        OE <= '0';
        wait for 5 ns;
        CLK <= '1';
        wait for 5 ns;
        WAIT; --pour terminer le test bench
    END PROCESS;
END ARCHITECTURE;
 
 
 
