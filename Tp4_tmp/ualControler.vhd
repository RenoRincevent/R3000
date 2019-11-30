LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY CombinationalTools;
USE CombinationalTools.bus_mux_pkg.ALL;
LIBRARY SequentialTools;
USE SequentialTools.ALL;

ENTITY UALControler IS
	PORT
	(
		op : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		f : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		UALOp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Enable_V : OUT STD_LOGIC;
		Slt_Slti : OUT STD_LOGIC;
		Sel : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END ENTITY UALControler;

Architecture fdd_ual_controler of UALControler Is
Begin
  Enable_V <= (UALOp(1) and (not UALOp(0)) and f(5) and (not f(2)) and (not f(0)))
    or (UALOp(1) and UALOp(0) and (not op(2)) and (not op(0)));

  Slt_Slti <= (UALOp(1) and (not UALOp(0)) and f(3) and (not f(2)) and f(1) and (not f(0)))
    or (UALOp(1) and UALOp(0) and (not op(2)) and op(1) and (not op(0)));

  Sel(0) <= (UALOp(1) and (not UALOp(0)) and
      (((not f(5)) and (not f(3)) and (not f(2)) and (not f(1)) and (not f(0)))
          or ( f(5) and (not f(3)) and f(2) and (not f(1)) and f(0) )
          or ( (not f(5)) and (not f(3)) and f(2) and f(1) and (not f(0)) )
          or ( (not f(5)) and f(3) and (not f(2)) and f(1))))
    or ( UALOp(1) and UALOp(0) and (op(1) or (op(2) and op(0))) );

  Sel(1) <= (not UALOp(1)) or (UALOp(1) and (not UALOp(0)) and
      ( ( (not f(3)) and (not f(2)) and (not f(0)) )
      or ( (not f(5)) and (not f(3)) and f(2) and (not f(1)) and (not f(0)) )
      or ( (not f(5)) and f(3) and (not f(2)) and (not f(1)) and f(0) )
      or ( f(5) and (not f(3)) and (not f(2)) and f(0))
      or ( (not f(5)) and f(3) and (not f(2)) and f(1)) ))
    or (UALOp(1) and UALOp(0) and (not op(2)));

  Sel(2) <= (UALOp(1) and (not UALOp(0)) and
      ( ( (not f(5)) and (not f(3)) and (not f(2)) and (not f(0)) )
      or ( (not f(5)) and (not f(3)) and f(2) and f(1) ) ) )
    or (UALOp(1) and UALOp(0) and op(2) and op(1) and (not op(0)));

  Sel(3) <= ((not UALOp(1)) and UALOp(0)) or (UALOp(1) and (not UALOp(0)) and
    ( ( f(5) and (not f(3)) and (not f(2)) and f(1) ) or ( (not f(5)) and f(3) and (not f(2)) and f(1) )))
    or (UALOp(1) and UALOp(0) and (not op(2)) and op(1)); 
End Architecture fdd_ual_controler;
