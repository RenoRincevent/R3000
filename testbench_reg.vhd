LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;

ENTITY test IS
END ENTITY;

Architecture arc of test is 
    Signal source_register_0 : STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
    Signal data_out_0 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    Signal source_register_1 : STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
    Signal data_out_1 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    Signal destination_register : STD_LOGIC_VECTOR(4 DOWNTO 0) := (others => '0');
    Signal data_in : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    Signal write_register : STD_LOGIC;
    Signal clk : STD_LOGIC;
begin
    inst_regs : entity work.RegisterBank(struct_reg) Port Map(source_register_0, data_out_0, source_register_1, data_out_1, destination_register, data_in, write_register, clk);
    Process
    Begin
        for i in 0 to 31 loop
            clk <= '0';
            destination_register <= conv_std_logic_vector(i,source_register_0'length);
            data_in <= conv_std_logic_vector(2**i,data_in'length);
            if i < 10 then -- ecrit uniquement sur les 10 premier registres
                write_register <= '1';
            else
                write_register <= '0';
            end if;
            if i >= 1 then 
                source_register_0 <= conv_std_logic_vector(i-1,source_register_0'length);
                source_register_1 <= conv_std_logic_vector(i-1,source_register_1'length); 
            end if;
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;
End architecture;
