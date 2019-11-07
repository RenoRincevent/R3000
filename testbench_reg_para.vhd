LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;

ENTITY test IS
END ENTITY;

Architecture arc of test is 
    Constant register_size : Integer := 32;
    Signal  wr : Std_logic := '0';
    Signal data_in : Std_logic_vector(register_size-1 downto 0) := (others => '0');
    Signal data_out : Std_logic_vector(register_size-1 downto 0) := (others => '0');
begin
    inst_reg_para : entity work.parallel_register(comp_reg_para) generic Map (register_size) Port Map(wr,data_in,data_out);
    Process
    begin
        for i in 0 to register_size-1 loop
            if i mod 2 = 0 then
                wr <= '1';
            else 
                wr <= '0';
            end if;
            data_in(i) <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;
end Architecture;
