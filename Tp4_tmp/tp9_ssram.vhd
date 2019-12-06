--------------------------------------------------------------------------------
-- SSRAM
-- Dr THIEBOLT Francois
--------------------------------------------------------------------------------

------------------------------------------------------------------
-- RAM Statique Synchrone - mode burst -
-- Les donnes sur DBUS changent d'etat juste apres le front
-- 	montant CLK. La memoire n'est pas circulaire, c.a.d que lorsque
--		l'adresse depasse la capacite, DBUS <= Z
-- Elle dispose d'un parametre fixant la latence au chip
-- select, c.a.d que lorsque CS* est actif, il se passe CS_LATENCY
-- cycles avant que l'operation READ ou WRITE se fasse effectivement
-- Une operation READ ou WRITE dure tant que CS est actif.
-- L'adresse de l'operation est echantillonnee sur front descendant
--		de CS*, puis incrementee tacitement apres CS_LATENCY cycles
--		et ce tant que CS* est actif.
------------------------------------------------------------------

-- Definition des librairies
library IEEE;

-- Definition des portee d'utilisation
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

use WORK.cpu_package.all;

-- Definition de l'entite
entity ssram is

	generic (
		-- taille du bus d'adresse
		ABUS_WIDTH : natural := 4; -- soit 16 mots memoire

		-- taille du bus donnee
		DBUS_WIDTH : natural := 8;
		
		-- chip select latence en nombre de cycles
		CS_LATENCY : natural := 4;
		
		-- delai de propagation entre la nouvelle adresse et la donnee sur la sortie
		I2Q : time := 2 ns );

	port (
		-- signaux de controle
		RW			: in std_logic; -- R/W* (W actif a l'etat bas)
		CS,RST	: in std_logic; -- actifs a l'etat bas
		CLK		: in std_logic;

		-- bus d'adresse et de donnee
		ABUS : in std_logic_vector(ABUS_WIDTH-1 downto 0);
		DBUS : inout std_logic_vector(DBUS_WIDTH-1 downto 0) );

end ssram;

-- -----------------------------------------------------------------------------
-- Definition de l'architecture de la ssram
-- -----------------------------------------------------------------------------
architecture behavior of ssram is

	-- definition de constantes

	-- definitions de types (index type default is integer)
	type FILE_REG_typ is array (0 to 2**ABUS_WIDTH-1) of std_logic_vector (DBUS_WIDTH-1 downto 0);

	-- definition des ressources internes
	signal REGS : FILE_REG_typ; -- le banc de registres
	signal LADR : std_logic_vector(ABUS_WIDTH-1 downto 0); --l'adress à incrementer à chaque lecture ou ecriture 
	signal CS_OK : std_logic; -- permet de savoir si l'on a pas atteint la fin de la memoire 

begin

-- P_LADR : process 
-- 	variable isZ : std_logic_vector(ABUS_WIDTH-1 downto 0);
-- 	variable lat : std_logic_vector(CS_LATENCY-1 downto 0);
-- begin
-- 	wait on ABUS, CLK; 
-- 	isZ := (others => 'Z');
-- 	if (isZ /= ABUS) then 
-- 		LADR <= ABUS;
-- 	end if;

-- 	DBUS <= (others => 'Z');
-- 	if (rising_edge(CLK)) then 
-- 		if RST = '0' or CS = '1' then -- pas sur
-- 			lat := (others => '0');
-- 			CS_OK <= '0';
-- 			DBUS <= (others => 'Z');
-- 		else 
-- 			if (CS = '0') then
-- 				if conv_integer(lat) >= CS_LATENCY-2 then 
-- 					if (CS_OK = '0' and conv_integer(lat) = CS_LATENCY-2) then 
-- 						CS_OK <= '1';
-- 						lat := lat+'1';
-- 						if (RW = '1') then
-- 							DBUS <= REGS(conv_integer(LADR)) after I2Q;
-- 						else 
-- 							DBUS <= (others => 'Z');
-- 						end if;
-- 					else
-- 						if conv_integer(LADR) = 2**ABUS_WIDTH-1 then 
-- 							CS_OK <= '0';
-- 							DBUS <= (others => 'Z');
-- 						else 
-- 							LADR <= LADR + '1';
-- 							if (CS_OK = '1' and RW = '1') then
-- 								DBUS <= REGS(conv_integer(LADR)) after I2Q;
-- 							else 
-- 								DBUS <= (others => 'Z');
-- 							end if;
-- 						end if;
-- 					end if;
-- 				else
-- 					lat := lat+'1';
-- 				end if;
-- 			end if;
-- 		end if;
-- 	end if;
-- end process P_LADR;

-- on sensibilise en fonction de CS_OK
-- P_RD : 
-- 	DBUS <= 
-- 			(others => 'Z') when CS_OK = '0' and RW = '0' else  
			


P_RD : process (CS_OK, RW)
begin
	if (CS_OK = '1' and RW = '1') then 
		DBUS <= REGS(conv_integer(LADR)) after I2Q;
	else 
		DBUS <= (others => 'Z');
	end if ;
end process P_RD;

P_LADR : process (CLK, CS, RST) 
	variable lat : std_logic_vector(CS_LATENCY-1 downto 0);
begin	
	if RST = '0' then 
		CS_OK <= '0';
		LADR <= (others => 'U');
	else 
		if falling_edge(CS) then 
			LADR <= ABUS;
		elsif rising_edge(CLK) then 
			if (CS = '1') then 
				lat := (others => '0');
			else 
				if (conv_integer(lat) < CS_LATENCY-1) then 
					lat := lat + '1'; 
					if (conv_integer(lat) = CS_LATENCY-1) then 
						CS_OK <= '1';
					end if; 
				elsif conv_integer(LADR) < 2**ABUS_WIDTH-1 then 
					LADR <= LADR + '1';
				else 
					CS_OK <= '0';
				end if;
			end if;
		end if;
	end if;
end process P_LADR;

P_WR : process(CLK, RST)
begin
	if RST = '0' then 
		REGS <= (others => (others => '0'));	
	elsif (rising_edge(CLK)) and CS_OK = '1' and (RW = '0') then  
		REGS(conv_integer(LADR)) <= DBUS;
	end if;
end process P_WR;

end behavior;


















-- P_LADR : process (CLK, CS) 
-- 	variable lat : std_logic_vector(CS_LATENCY-1 downto 0);
-- begin	
-- 	if falling_edge(CS) then 
-- 		LADR <= ABUS;
-- 	elsif rising_edge(CLK) then 
-- 		if (CS = '1') then 
-- 			lat := (others => '0');
-- 			LADR <= (others => '0');
-- 		else 
-- 			if (conv_integer(lat) < CS_LATENCY-1) then 
-- 				lat := lat + '1'; 
-- 				if (conv_integer(lat) = CS_LATENCY-1) then 
-- 					CS_OK <= '1';
-- 				end if; 
-- 			elsif conv_integer(LADR) < 2**ABUS_WIDTH-1 then 
-- 				LADR <= LADR + '1';
-- 			else 
-- 				CS_OK <= '0';
-- 			end if;
-- 		end if;
-- 	end if;
-- end process P_LADR;