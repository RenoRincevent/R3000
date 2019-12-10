-- Standard libraries
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
-- User-defined libraries
LIBRARY CombinationalTools;
USE CombinationalTools.bus_mux_pkg.ALL;
LIBRARY SequentialTools;
USE SequentialTools.ALL;



ENTITY R3000 IS
	PORT (
		CLK : IN STD_LOGIC;
		DMem_Abus, IMem_Abus : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		IMem_WR : IN STD_LOGIC;
		DMem_Dbus, IMem_Dbus : INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		DMem_WR : IN STD_LOGIC );
END ENTITY;

Architecture struct_r3000 of R3000 Is
    --Signal en sortie du controle
    Signal MemversReg : Std_logic_vector(1 downto 0);
    Signal RegDest : Std_logic_vector(1 downto 0);
    Signal UALSrc : Std_logic_vector(1 downto 0);
    Signal Saut : Std_logic_vector(1 downto 0);
    Signal EcrireReg : Std_Logic;
    Signal OpExt : Std_Logic;
    --Les Signaux Ecrire_Mem et LireMem ne sont pas pris en charge dans cette version
    Signal EcrireMem_W : Std_Logic;
    Signal EcrireMem_H : Std_Logic;
    Signal EcrireMem_B : Std_Logic;
    Signal LireMem_W : Std_Logic;
    Signal LireMem_UH : Std_Logic;
    Signal LireMem_UB : Std_Logic;
    Signal LireMem_SH : Std_Logic;
    Signal LireMem_SB : Std_Logic;
    Signal B_ltz_ltzAl_gez_gezAl : Std_Logic;
    Signal B_gtz : Std_Logic;
    Signal B_lez : Std_Logic;
    Signal B_ne : Std_Logic;
    Signal B_eq : Std_Logic;
    Signal UALOp : Std_logic_vector(1 DOWNTO 0);
    
    --Signal de sortie du controle mux
    Signal CPSrc : Std_logic;
    --Signal de sortie du mux cp
    Signal CPMux_out : Std_logic_vector(31 downto 0);
    --Signal du mux Saut
    Signal SautMux_out : Std_logic_vector(31 downto 0);
    Signal Input1_Saut_mux : Std_logic_vector(31 downto 0);
    --Signal du mux UALSrc
    Signal Input2_UALS_mux : Std_logic_vector(31 downto 0);
    Signal Input3_UALS_mux : Std_logic_vector(31 downto 0);
    
    --Signal branché au banc de registres
    Signal DWrite : Std_logic_vector(31 downto 0);
    Signal RWrite : Std_logic_vector(4 downto 0);
    Signal DRead0 : Std_logic_vector(31 downto 0);
    Signal DRead1 : Std_logic_vector(31 downto 0);
    
    --Signal de sortie de la memoire d'instructions
    Signal Instruction : Std_logic_vector(31 downto 0);
    
    --Signal de sortie de l'extension
    Signal Ext : Std_logic_vector(31 downto 0);
    
    --Signal de sortie du controle de l'UAL
    Signal Out_controle_UAL : Std_logic_vector(5 downto 0);
    
    --Signal de sortie de l'UAL
    Signal Res : Std_logic_vector(31 downto 0);
    Signal N : STD_LOGIC;
    Signal Z : STD_LOGIC;
    Signal C : STD_LOGIC;
    Signal V : STD_LOGIC;
    
    --Signal branché a l'UAL
    Signal BSrc : Std_logic_vector(31 downto 0);
    
    --Signal du CP
    Signal CP : Std_logic_vector(31 downto 0) := "10111111110000000000000000000000";
    
    --Signal de sortie de l'adder cp+4 et de l'adder de l'extension
    Signal Out_add_CP4 : Std_logic_vector(31 downto 0);
    Signal Out_add_ext : Std_logic_vector(31 downto 0);
    
    --Signal de la mémoire de données
    Signal Out_MD : Std_logic_vector(31 downto 0);
begin
    inst_mux_MemversReg : entity CombinationalTools.multiplexor
        generic map (  mux_size => 2, mux_width => 32)
        port map(input(0) => Res, 
        input(1) => Out_MD,
        input(2) => SautMux_out,
        input(3) => (others =>'Z'),
        sel_input => MemversReg, --le selecteur est connecté a la sortie MemversReg du controle
        output => DWrite); --la sortie est connecté a la donnée a écrire dans le banc de registre

    inst_mux_RegDest : entity CombinationalTools.multiplexor
        generic map (  mux_size => 2, mux_width => 5)
        port map(input(0) => Instruction(20 downto 16), 
        input(1) => Instruction(15 downto 11),
        input(2) => (others =>'1'),
        input(3) => (others =>'Z'),
        sel_input => RegDest, --le selecteur est connecté a la sortie RegDest du controle
        output => RWrite); --la sortie est connecté au registre destination dans le banc de registres

    Input2_UALS_mux <= (others => '0');
    Input3_UALS_mux(31 downto 16) <= Instruction(15 downto 0);
    Input3_UALS_mux(15 downto 0) <= (others => '0');
    inst_mux_UALSrc : entity CombinationalTools.multiplexor
        generic map (  mux_size => 2, mux_width => 32)
        port map(input(0) => DRead1, 
        input(1) => Ext,
        input(2) => (others => '0'),
        input(3) => Input3_UALS_mux,
        sel_input => UALSrc, --le selecteur est connecté a la sortie UALSrc du controle
        output => BSrc); --la sortie est connecté au registre B de l'UAL

    inst_mux_CPSrc : entity CombinationalTools.multiplexor
        generic map (  mux_size => 1, mux_width => 32)
        port map(input(0) => Out_add_CP4, 
        input(1) => Out_add_ext,
        sel_input(0) => CPSrc, --le selecteur est connecté a la sortie CPSrc du controle MUX
        output => CPMux_out); --la sortie est connecté a l'entrée 1 du mux saut
    
    Input1_Saut_mux <= CP(31 downto 28) & Instruction(25 downto 0) & "00";
    inst_mux_Saut : entity CombinationalTools.multiplexor
        generic map (  mux_size => 2, mux_width => 32)
        port map(input(0) => CPMux_out, 
        input(1) => Input1_Saut_mux,
        input(2) => Res,
        input(3) => (others =>'Z'),
        sel_input => Saut, --le selecteur est connecté a la sortie Saut du controle
        output => SautMux_out);
    CP <= SautMux_out;

    inst_RegisterBank : entity work.RegisterBank
        port map (source_register_0 => Instruction(25 downto 21),
        data_out_0 => DRead0,
        source_register_1 => Instruction(20 downto 16),
        data_out_1 => DRead1,
        destination_register => RWrite,
        data_in => DWrite,
        write_register => EcrireReg,
        clk => CLK);
    
    inst_extension : entity work.Extension
        port map (OpExt => OpExt,
        inst => Instruction(15 downto 0),
        output => Ext);

    inst_controle : entity work.InstructionDecoder
        port map(Instruction(31 downto 26),
        Saut,
        EcrireMem_W,EcrireMem_H,EcrireMem_B,
        LireMem_W,LireMem_UH,LireMem_UB,LireMem_SH,LireMem_SB,
        B_ltz_ltzAl_gez_gezAl,B_gtz,B_lez,B_ne,B_eq,
        UALOp,UALSrc,EcrireReg,RegDest,OpExt,MemVersReg);

    inst_controle_UAL : entity work.UALControler
        port map(op => Instruction(31 downto 26),
        f => Instruction(5 DOWNTO 0),
        UALOp => UALOp,
        Enable_V => Out_controle_UAL(0),
        Slt_Slti => Out_controle_UAL(1),
        Sel => Out_controle_UAL(5 downto 2));

    inst_UAL : entity work.ALU
    port map(A => DRead0,
        B => BSrc,
        sel => Out_controle_UAL(5 downto 2),
        Enable_V => Out_controle_UAL(0),
        ValDec => Instruction(10 downto 6),
        Slt => Out_controle_UAL(1),
        CLK => CLK,
        Res => Res,
        N => N,
        Z => Z,
        C => C,
        V => V);
        
    inst_controle_mux : entity work.CpMuxControler 
        port map(B_ltz_ltzAl_gez_gezAl => B_ltz_ltzAl_gez_gezAl,
        B_gtz => B_gtz,
        B_lez => B_lez,
        B_ne => B_ne,
        B_eq => B_eq,
        N => N,
        Z => Z,
        rt0 => '0', --What is that 'rt0'?
        CPSrc => CPSrc);

    inst_CP_Plus_4 : entity work.adder
        generic map(32)
        port map(op_0 => CP,
        op_1(31 downto 4) => (others => '0'),
        op_1(3 downto 0) => "0100",
        sum => Out_add_CP4);
    
    inst_adder_extension : entity work.adder
        generic map(32)
        port map(op_0 => Out_add_CP4,
        op_1(31 downto 2) => Ext(29 downto 0),
        op_1(1 downto 0) => "00",
        sum => Out_add_ext);

    IMem_Abus <= CP;
    inst_memoire_instructions : entity SequentialTools.SRAM_DPS
        generic map(address_width => 16,data_bus_width => 32)
        port map(address => CP(15 downto 0),
        data_in => IMem_Dbus,
        data_out => Instruction,
        WE => IMem_WR,
        CS => '0',
        OE => '0',
        CLK => CLK);

    DMem_Abus <= Res;
    DMem_Dbus <= DRead1;
    inst_memoire_donnees : entity SequentialTools.SRAM_DPS
        generic map(address_width => 16,data_bus_width => 32)
        port map(address => Res(15 downto 0),
        data_in => DRead1,
        data_out => Out_MD,
        WE => DMem_WR,
        CS => '0',
        OE => '0',
        CLK => CLK);
End Architecture struct_r3000;



