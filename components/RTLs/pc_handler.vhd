LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY pc_handler IS
    PORT (
        INT : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        RTI : IN STD_LOGIC;
        HLT : IN STD_LOGIC;
        JCond : IN STD_LOGIC;
        JMP : IN STD_LOGIC;
        CALL : IN STD_LOGIC;
        RET : IN STD_LOGIC;
        EmptySP : IN STD_LOGIC;
        InvMemAddress : IN STD_LOGIC;
        NOP : IN STD_LOGIC;
        Selector : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
    );
END pc_handler;

ARCHITECTURE Behavioral OF pc_handler IS
BEGIN
    PROCESS (NOP, reset, INT, RTI, JMP, RET, InvMemAddress, EmptySP, HLT, CALL, JCond)
    BEGIN
        IF JMP = '1' OR JCond = '1' OR CALL = '1' THEN
            Selector <= "011"; -- Code for JMP, JCond, CALL
        ELSIF HLT = '1' THEN
            Selector <= "001"; -- Code for HLT
        ELSIF reset = '1' THEN
            Selector <= "101"; -- Code for reset
        ELSIF InvMemAddress = '1' THEN
            Selector <= "110"; -- Code for InvMemAddress
        ELSIF EmptySP = '1' THEN
            Selector <= "111"; -- Code for EmptySP
        ELSIF RET = '1' OR RTI = '1' THEN
            Selector <= "100"; -- Code for RET, RTI
        ELSIF INT = '1' THEN
            Selector <= "010"; -- Code for INT
        ELSE
            Selector <= "000"; -- Default output (Increment PC normally or NOP)
        END IF;
    END PROCESS;
END Behavioral;