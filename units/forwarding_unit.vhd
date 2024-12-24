LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ForwardingUnit IS
  PORT (
    ID_EX_Rsrc1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    ID_EX_Rsrc2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    EX_MEM_Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    MEM_WB_Rdst : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    EX_MEM_regWrite : IN STD_LOGIC;
    MEM_WB_regWrite : IN STD_LOGIC;
    ForwardA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    ForwardB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
  );
END ForwardingUnit;

ARCHITECTURE a_ForwardingUnit OF ForwardingUnit IS
BEGIN
  -- ForwardA logic
  PROCESS (EX_MEM_regWrite, EX_MEM_Rdst, MEM_WB_regWrite, MEM_WB_Rdst, ID_EX_Rsrc1)
  BEGIN
    IF EX_MEM_regWrite = '1' AND EX_MEM_Rdst = ID_EX_Rsrc1 THEN
      ForwardA <= "01";  -- Forward from EX stage
    ELSIF MEM_WB_regWrite = '1' AND MEM_WB_Rdst = ID_EX_Rsrc1 THEN
      ForwardA <= "10";  -- Forward from MEM stage
    ELSE
      ForwardA <= "00";  -- No forwarding
    END IF;
  END PROCESS;
 
  -- ForwardB logic
  PROCESS (EX_MEM_regWrite, EX_MEM_Rdst, MEM_WB_regWrite, MEM_WB_Rdst, ID_EX_Rsrc2)
  BEGIN
    IF EX_MEM_regWrite = '1' AND EX_MEM_Rdst = ID_EX_Rsrc2 THEN
      ForwardB <= "01";  -- Forward from EX stage
    ELSIF MEM_WB_regWrite = '1' AND MEM_WB_Rdst = ID_EX_Rsrc2 THEN
      ForwardB <= "10";  -- Forward from MEM stage
    ELSE
      ForwardB <= "00";  -- No forwarding
    END IF;
  END PROCESS;

END a_ForwardingUnit;