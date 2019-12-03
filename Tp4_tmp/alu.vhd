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
            mux_size : Integer := 3;
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
    Signal S_And : STD_LOGIC_VECTOR(31 DOWNTO 0); --Ces signaux font le lien entre les opération logique et le mux
    Signal S_Or : STD_LOGIC_VECTOR(31 DOWNTO 0); --
    Signal S_Nor : STD_LOGIC_VECTOR(31 DOWNTO 0); --
    Signal S_Xor : STD_LOGIC_VECTOR(31 DOWNTO 0); --

    Signal S_BS : STD_LOGIC_VECTOR(31 DOWNTO 0); -- fait le lien entre la sortie du barrel shifter et le mux
    Signal S_out_mux : std_logic_vector(31 downto 0); -- recupère la sortie du mux pour le brancher ensuite au res et a la bascule D de Z
    Signal S_out_adder : std_logic_vector(31 downto 0); -- signal en sortie de l'additionneur

    --Signaux utilse pour l'add/sub
    Signal overflow : Std_logic;
    Signal carry : Std_logic;
    Signal locala, localb, localsum : signed(32 downto 0);
    Signal sumout : std_logic_vector(32 downto 0);

    --bit du résultat pour les opération positionnement si inférieur
    Signal res0 : Std_logic;
begin
    S_And <= A and B;
    S_Or <= A or B;
    S_Nor <= A nor B;
    S_Xor <= A xor B;

    -- add/subb
    locala <= resize(signed(A), 33);
    localb <= resize(signed(B), 33);
    localsum <= locala + localb when sel(3) = '0' else locala - localb;
    overflow <= '1' when localsum(31) /= localsum(32) else '0';
    carry <= '1' when localsum(32) /= sel(3) else '0';
    sumout <= std_logic_vector(localsum);
    S_out_adder <= sumout(32) & sumout(30 downto 0);

    --Logique pour déterminer le bit du résultat res0 pour les opérations positionnement si inférieur.
    res0 <= (Enable_V and (S_out_adder(31) xor overflow)) or ((not Enable_V) and carry);

    bs_inst : entity CombinationalTools.barrel_shifter
        port map(input => B,
            shift_amount => ValDec,
            LeftRight => (not sel(0)),
            LogicArith => '0',
            ShiftRotate => '0',
            output => S_BS);

    mux_inst : entity CombinationalTools.multiplexor
        port map( input(0) => S_And,
        input(1) => S_Or,
        input(2) => S_out_adder,
        --input(3) => 31x"0" & res0
        input(4) => S_Nor,
        input(5) => S_Xor,
        input(6) => S_BS,
        input(7) => S_BS,
            output => S_out_mux,
            sel_input => sel(2 downto 0));

    res <= S_out_mux;

    --Bascule D pour la sortie C
    inst_reg0 : entity SequentialTools.parallel_register
      port map(wr => CLK,
      data_in => carry,
      data_out => C);

    --Bascule D pour la sortie V
    inst_reg1 : entity SequentialTools.parallel_register
      port map(wr => CLK,
      data_in => overflow and (not Slt_Slti) and Enable_V,
      data_out => V);

    --Bascule D pour la sortie N
    inst_reg2 : entity SequentialTools.parallel_register
      port map(wr => CLK,
      data_in => S_out_adder(31),
      data_out => N);

    --Bascule D pour la sortie Z
    inst_reg3 : entity SequentialTools.parallel_register
      port map(wr => CLK,
      --data_in => '1' when S_out_mux = 0
      data_out => Z);
End architecture struct_alu;
