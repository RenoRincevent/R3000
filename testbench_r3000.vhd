LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;
LIBRARY CombinationalTools;
USE CombinationalTools.bus_mux_pkg.ALL;
LIBRARY SequentialTools;
USE SequentialTools.ALL;

ENTITY test IS
END ENTITY;

ARCHITECTURE arc OF test IS
    Signal CLK : STD_LOGIC := '0';
    Signal DMem_Abus, IMem_Abus : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    Signal IMem_WR : STD_LOGIC := '0';
    Signal DMem_Dbus, IMem_Dbus :STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    SIgnal DMem_WR : STD_LOGIC := '0';
begin
    inst_r3000 : ENTITY work.R3000(struct_r3000) Port Map (CLK,DMem_Abus,IMem_Abus,IMem_WR,DMem_Dbus,IMem_Dbus,DMem_WR);
    PROCESS 
    BEGIN
        --Test du SW rt, offset(base)
        
        IMem_Dbus <= conv_std_logic_vector(1,IMem_Dbus'length);
        CLK <= '0';
        wait for 5 ns;
        IMem_WR <= '0';
        CLK <= '1';
        wait for 5 ns;
        CLK <= '0';
        IMem_WR <= '1';
        wait for 5 ns;
        
        IMem_Dbus <= conv_std_logic_vector(2,IMem_Dbus'length);
        CLK <= '0';
        wait for 5 ns;
        IMem_WR <= '0';
        CLK <= '1';
        wait for 5 ns;
        CLK <= '0';
        IMem_WR <= '1';
        wait for 5 ns;
        
        IMem_Dbus <= conv_std_logic_vector(3,IMem_Dbus'length);
        CLK <= '0';
        wait for 5 ns;
        IMem_WR <= '0';
        CLK <= '1';
        wait for 5 ns;
        CLK <= '0';
        IMem_WR <= '1';
        wait for 5 ns;
        
        IMem_Dbus <= conv_std_logic_vector(4,IMem_Dbus'length);
        CLK <= '0';
        wait for 5 ns;
        IMem_WR <= '0';
        CLK <= '1';
        wait for 5 ns;
        CLK <= '0';
        IMem_WR <= '1';
        wait for 5 ns;
        WAIT; --pour terminer le test bench
    END PROCESS;
END ARCHITECTURE;
