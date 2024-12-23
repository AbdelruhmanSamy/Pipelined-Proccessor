LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY jump_unit IS
    PORT (
        JC, JN, JZ : IN STD_LOGIC;
        Flags : IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- passed as Zero &  Neg & Carry
        Jump : OUT STD_LOGIC
    );
END jump_unit;

ARCHITECTURE rtl OF jump_unit IS

BEGIN
    JUMP <= '1' WHEN (JC AND Flags(2) = '1') OR (JN AND Flags(1) = '1') OR (JZ AND Flags(0) = '1') ELSE
        '0';

END rtl;

END ARCHITECTURE;