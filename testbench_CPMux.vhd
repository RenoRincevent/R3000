LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;

ENTITY test IS
END ENTITY;

Architecture arc of test is
    Signal B_ltz_ltzAl_gez_gezAl : STD_LOGIC;
    Signal B_gtz : STD_LOGIC;
    Signal B_lez : STD_LOGIC;
    Signal B_ne : STD_LOGIC;
    Signal B_eq : STD_LOGIC;
    Signal N : STD_LOGIC;
    Signal Z : STD_LOGIC;
    Signal rt0 : STD_LOGIC;
    Signal CPSrc : STD_LOGIC;
    Signal inputs : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
begin
    inst_cp_controler : entity work.CpMuxControler(fdd_cp_mux) Port Map(B_ltz_ltzAl_gez_gezAl,B_gtz,B_lez,B_ne,B_eq,N,Z,rt0,CPSrc);
    (B_ltz_ltzAl_gez_gezAl,B_gtz,B_lez,B_ne,B_eq,N,Z,rt0) <= inputs;
    Process
    Begin
        for i in 0 to 255 loop
            inputs <= conv_std_logic_vector(i,inputs'length);
            wait for 5 ns;
        end loop;
        wait;
    end process;
End architecture;
