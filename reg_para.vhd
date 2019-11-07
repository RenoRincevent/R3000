LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

Entity parallel_register is
    Generic
    (
        register_size : Integer := 32
    );
    Port
    (
        wr : In Std_logic;
        data_in : In Std_logic_vector(register_size-1 downto 0);
        data_out : Out Std_logic_vector(register_size-1 downto 0)
    );
End entity parallel_register;

Architecture comp_reg_para of parallel_register is
begin
    process(wr)
    begin
        if rising_edge(wr) then
            data_out <= data_in;
        end if;
    end process;
End Architecture comp_reg_para;


