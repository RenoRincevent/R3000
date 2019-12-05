LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY CombinationalTools;
USE CombinationalTools.bus_mux_pkg.ALL;
LIBRARY SequentialTools;
USE SequentialTools.ALL;

ENTITY InstructionDecoder IS
	PORT
	(
		code_op : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		Saut : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		EcrireMem_W : OUT STD_LOGIC;
		EcrireMem_H : OUT STD_LOGIC;
		EcrireMem_B : OUT STD_LOGIC;
		LireMem_W : OUT STD_LOGIC;
		LireMem_UH : OUT STD_LOGIC;
		LireMem_UB : OUT STD_LOGIC;
		LireMem_SH : OUT STD_LOGIC;
		LireMem_SB : OUT STD_LOGIC;
		B_ltz_ltzAl_gez_gezAl : OUT STD_LOGIC;
		B_gtz : OUT STD_LOGIC;
		B_lez : OUT STD_LOGIC;
		B_ne : OUT STD_LOGIC;
		B_eq : OUT STD_LOGIC;
		UALOp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		UALSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		EcrireReg : OUT STD_LOGIC;
		RegDst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		OpExt : OUT STD_LOGIC;
		MemVersReg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END ENTITY InstructionDecoder;

architecture fdd_inst_decoder of InstructionDecoder Is
  Component decoder IS
      GENERIC
      (
          dec_size : INTEGER := 6
      );
      PORT
      (
          input : IN STD_LOGIC_VECTOR(dec_size-1 DOWNTO 0);
          output : OUT STD_LOGIC_VECTOR((2**dec_size)-1 DOWNTO 0)
      );
  END Component decoder;
  Signal m : STD_LOGIC_VECTOR(63 DOWNTO 0); --minterms à la sortie du decodeur
  begin
    decoder_inst : entity CombinationalTools.decoder
    generic map (  dec_size => 6)
      port map ( input => code_op,
      output => m);

    OpExt <= m(1) or m(4) or m(5) or m(6) or m(7) or m(8) or m(10) or m(32) or m(33) or m(35) or m(36) or m(37) or m(40) or m(41) or m(43);
    RegDst(1) <= m(1) or m(3);
    RegDst(0) <= m(0);
    UALSrc(1) <= m(1) or m(15);
    UALSrc(0) <= m(8) or m(9) or m(10) or m(11) or m(12) or m(13) or m(14) or m(15) or m(32) or m(33) or m(35) or m(36) or m(37) or m(40) or m(41) or m(43);
    MemVersReg(1) <= m(0) or m(1) or m(3);
    MemVersReg(0) <= m(32) or m(33) or m(35) or m(36) or m(37);
    EcrireReg <= m(0) or m(1) or m(2) or m(3) or m(8) or m(9) or m(10) or m(11) or m(12) or m(13) or m(14) or m(15) or m(32) or m(33) or m(35) or m(36) or m(37);
    LireMem_SB <= m(32);
    LireMem_SH <= m(33);
    LireMem_W <= m(35);
    LireMem_UB <= m(36);
    LireMem_UH <= m(37);
    EcrireMem_B <= m(40);
    EcrireMem_H <= m(41);
    EcrireMem_W <= m(43);
    B_eq <= m(4);
    B_ne <= m(5);
    B_lez <= m(6);
    B_gtz <= m(7);
    B_ltz_ltzAl_gez_gezAl <= m(1);
    Saut(1) <= m(0);
    Saut(0) <= m(2) or m(3);
    UALOp(1) <= m(0) or m(8) or m(9) or m(10) or m(11) or m(12) or m(13) or m(14) or m(15);
    UALOp(0) <= m(1) or m(4) or m(5) or m(6) or m(7) or m(8) or m(9) or m(10) or m(11) or m(12) or m(13) or m(14) or m(15);

end architecture fdd_inst_decoder; 
