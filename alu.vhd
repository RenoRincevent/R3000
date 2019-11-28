LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY CombinationalTools;
USE CombinationalTools.bus_mux_pkg.ALL;
LIBRARY SequentialTools;
USE SequentialTools.ALL;


ENTITY ALU IS
	PORT
	(
		A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		Enable_V : IN STD_LOGIC;
		ValDec : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		Slt : IN STD_LOGIC;
		CLK : IN STD_LOGIC;
		Res : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		N : OUT STD_LOGIC;
		Z : OUT STD_LOGIC;
		C : OUT STD_LOGIC;
		V : OUT STD_LOGIC
	);
END ENTITY ALU;

architecture struct_alu of ALU Is
    Component multiplexor Is 
        generic
        (
            mux_size : Integer := 4;
            mux_width : Integer := 32
        );
        Port
        (
            input : IN bus_mux_array((2**mux_size)-1 downto 0)(mux_width-1 downto 0);
            sel_input : IN std_logic_vector(mux_size-1 downto 0);
            output : OUT std_logic_vector(mux_width-1 downto 0)
        );
    End Component multiplexor;
    Component barrel_shifter Is
        generic
        (
            shift_size : INTEGER := 5;
            shifter_width : INTEGER := 32
        );
        Port
        (
            input : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            shift_amount : IN STD_LOGIC_VECTOR(shift_size-1 DOWNTO 0);
            LeftRight : IN STD_LOGIC;
            LogicArith : IN STD_LOGIC;
            ShiftRotate : IN STD_LOGIC;
            output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END Component barrel_shifter;
    Signal S_And : STD_LOGIC_VECTOR(31 DOWNTO 0); --Ces signaux font le lien entre les opération logique et le mux
    Signal S_Or : STD_LOGIC_VECTOR(31 DOWNTO 0); --
    Signal S_Xor : STD_LOGIC_VECTOR(31 DOWNTO 0); --
    Signal S_Nand : STD_LOGIC_VECTOR(31 DOWNTO 0);
    Signal S_Nor : STD_LOGIC_VECTOR(31 DOWNTO 0);
    Signal S_Xnor : STD_LOGIC_VECTOR(31 DOWNTO 0);
    Signal S_BS : STD_LOGIC_VECTOR(31 DOWNTO 0); -- fait le lien entre la sortie du barrel shifter et le mux
begin
    S_And <= A and B;
    S_Or <= A or B;
    S_Xor <= A xor B;
    S_Nand <= A nand B;
    S_Nor <= A nor B;
    S_Xnor <= A xnor B;
    
    bs_inst : entity CombinationalTools.barrel_shifter
        port map(input => B,
            shift_amount => ValDec,
            LeftRight => sel(2),
            LogicArith => sel(1),
            ShiftRotate => sel(0),
            output => S_BS);
    
    mux_inst : entity CombinationalTools.multiplexor
        port map( input(0) => S_And,
        input(1) => S_Or,
        input(2) => S_Xor,
        input(3) => S_Nand,
        input(4) => S_Nor,
        input(5) => S_Xnor,
        -- input 6 = add
        -- input 7 = sub
        input(8) => S_BS,
        input(9) => S_BS,
        input(10) => S_BS,
        input(11) => S_BS,
        input(12) => S_BS,
        input(13) => S_BS,
        input(14) => S_BS,
        input(15) => S_BS,
            output => Res,
            sel_input => sel);
            
End architecture struct_alu;
 
