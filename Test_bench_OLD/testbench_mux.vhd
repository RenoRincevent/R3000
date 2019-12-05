LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--USE IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;
LIBRARY CombinationalTools;
USE CombinationalTools.bus_mux_pkg.ALL;

Entity test Is 
End Entity;

Architecture arc Of test Is
    Constant mux_size : integer := 4;
    Constant mux_width : integer := 32;
    Signal input : bus_mux_array((2**mux_size)-1 downto 0)(mux_width-1 downto 0);
    Signal sel_input : std_logic_vector(mux_size-1 downto 0);
    Signal output : std_logic_vector(mux_width-1 downto 0);
begin
    inst_mux_fdd : Entity CombinationalTools.multiplexor(fdd_mux) generic Map(mux_size, mux_width) Port Map (input, sel_input,output);
    process
    begin
        -- Initialisation du tableau de vecteur, on met des valeur au pif pour les différentier
        for i in 0 to (2**mux_size)-1 loop
            input(i) <= conv_std_logic_vector(2*i,input(i)'length);
        end loop;
        for i in 0 to (2**mux_size)-1 loop
            sel_input <= conv_std_logic_vector(i,sel_input'length);
            wait for 5 ns;
        end loop;
        wait;
    end process;
End Architecture;
