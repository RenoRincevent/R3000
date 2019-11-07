LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

Package bus_mux_pkg Is
    Type bus_mux_array is array(natural range<>) of std_logic_vector;
End Package bus_mux_pkg;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
library work;
use work.bus_mux_pkg.all;

Entity multiplexor Is 
    generic
    (
        mux_size : Integer := 2;
        mux_width : Integer := 32
    );
    Port
    (
        input : IN bus_mux_array((2**mux_size)-1 downto 0)(mux_width-1 downto 0);
        sel_input : IN std_logic_vector(mux_size-1 downto 0);
        output : OUT std_logic_vector(mux_width-1 downto 0)
    );
End Entity multiplexor;

ARCHITECTURE fdd_mux OF multiplexor IS
    Begin
        output <= input(to_integer(unsigned(sel_input)));
--         GEN_MUX:
--         for i IN size-1 DOWNTO 0 GENERATE
--             output(i) <= input(sel, i);
--         END GENERATE GEN_MUX;
End ARCHITECTURE fdd_mux;
