LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;

ENTITY test IS
END ENTITY;

Architecture arc of test is
    Signal code_op : STD_LOGIC_VECTOR(5 DOWNTO 0);
    Signal Saut : STD_LOGIC_VECTOR(1 DOWNTO 0);
    Signal EcrireMem_W : STD_LOGIC;
    Signal EcrireMem_H : STD_LOGIC;
    Signal EcrireMem_B : STD_LOGIC;
    Signal LireMem_W : STD_LOGIC;
    Signal LireMem_UH : STD_LOGIC;
    Signal LireMem_UB : STD_LOGIC;
    Signal LireMem_SH : STD_LOGIC;
    Signal LireMem_SB : STD_LOGIC;
    Signal B_ltz_ltzAl_gez_gezAl : STD_LOGIC;
    Signal B_gtz : STD_LOGIC;
    Signal B_lez : STD_LOGIC;
    Signal B_ne : STD_LOGIC;
    Signal B_eq : STD_LOGIC;
    Signal UALOp : STD_LOGIC_VECTOR(1 DOWNTO 0);
    Signal UALSrc : STD_LOGIC_VECTOR(1 DOWNTO 0);
    Signal EcrireReg : STD_LOGIC;
    Signal RegDst : STD_LOGIC_VECTOR(1 DOWNTO 0);
    Signal OpExt : STD_LOGIC;
    Signal MemVersReg : STD_LOGIC_VECTOR(1 DOWNTO 0);
begin
    inst_dec : entity work.InstructionDecoder(fdd_inst_decoder) Port Map(code_op,Saut,EcrireMem_W,EcrireMem_H,EcrireMem_B,
    LireMem_W,LireMem_UH,LireMem_UB,LireMem_SH,LireMem_SB,
    B_ltz_ltzAl_gez_gezAl,
    B_gtz,B_lez,B_ne,B_eq,
    UALOp,UALSrc,EcrireReg,RegDst,OpExt,MemVersReg);
    Process
    Begin
        for i in 0 to 63 loop
            -- Test de tout les code operations possible, meme les code op invalide.
            code_op <= conv_std_logic_vector(i,code_op'length);
            wait for 5 ns;
        end loop;
        wait;
    end process;
End architecture;
