LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
library work;
use work.bus_mux_pkg.all;

ENTITY RegisterBank IS
	PORT
	(
		source_register_0 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		data_out_0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		source_register_1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		data_out_1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		destination_register : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		write_register : IN STD_LOGIC;
		clk : IN STD_LOGIC
	);
END ENTITY RegisterBank;

architecture struct_reg of RegisterBank Is
    Component decoder IS
        GENERIC
        (
            dec_size : INTEGER := 5
        );
        PORT 
        (
            input : IN STD_LOGIC_VECTOR(dec_size-1 DOWNTO 0);
            output : OUT STD_LOGIC_VECTOR((2**dec_size)-1 DOWNTO 0)
        );
    END Component decoder;
    Component multiplexor Is 
        generic
        (
            mux_size : Integer := 5;
            mux_width : Integer := 32
        );
        Port
        (
            input : IN bus_mux_array((2**mux_size)-1 downto 0)(mux_width-1 downto 0);
            sel_input : IN std_logic_vector(mux_size-1 downto 0);
            output : OUT std_logic_vector(mux_width-1 downto 0)
        );
    End Component multiplexor;
    Component parallel_register is
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
    End Component parallel_register;
    Signal p0 : STD_LOGIC_VECTOR(31 DOWNTO 0); --Fait le lien entre le decodeur et les porte AND
    Signal p1 : STD_LOGIC; -- Fait le lien entre (clk & wr) et les porte AND
    Signal p2 : STD_LOGIC_VECTOR(31 DOWNTO 0); -- Fait le lien entre les porte AND et les registres (vers les pin wr)
    Signal p3 : bus_mux_array(31 downto 0)(31 downto 0); --Fait le lien entre les sortie des registres et les deux mux
begin

    decoder_inst : decoder
        port map ( input => destination_register,
            output => p0);
    p1 <= clk and write_register;
    
    GEN_P2:
    for i in 0 to 31 generate
        p2(i) <= p0(i) and p1;
    end generate GEN_P2;

    reg_inst0 : parallel_register --le data_in de R0 doit valoir zero
        port map ( data_in => (others => '0'),
            wr => p2(0),
            data_out => p3(0));
    GEN_REG:
    for i in 1 to 31 generate
        reg_inst : parallel_register
            port map ( data_in => data_in,
                wr => p2(i),
                data_out => p3(i));
    end generate GEN_REG;
    
-- le mux qui se charge de la sortie data_out_0    
    multiplexor_inst0 : multiplexor
        port map ( input => p3,
            output => data_out_0,
            sel_input => source_register_0);

-- le mux qui se charge de la sortie data_out_1
    multiplexor_inst1 : multiplexor
        port map ( input => p3,
            output => data_out_1,
            sel_input => source_register_1);
                    
            
End architecture struct_reg;
