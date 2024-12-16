LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ControlUnit IS
    PORT (
        opCode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        WB, MEMRd, MEMWr, MEMToReg, ALUSrc, SPInc, SPDec, DMAddress : OUT STD_LOGIC;
        EXE : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ControlUnit;

ARCHITECTURE Behavioral OF ControlUnit IS
    SIGNAL SPInc_internal, SPDec_internal, MEMRd_internal : STD_LOGIC;
BEGIN
    PROCESS (opCode)
    BEGIN
        ------------ WB, MEMRd, MEMWr ------------
        IF ((opCode(6 DOWNTO 3) = "0111") AND (opCode(2 DOWNTO 1) /= "11")) -- ADD, SUB, AND, NOT, INC, MOV
            OR (opCode(6 DOWNTO 1) = "111000") -- IADD, LDM
            OR (opCode = "0100000") -- IN
            THEN
            WB <= '1';
            MEMRd_internal <= '0';
            MEMWr <= '0';
        ELSIF (opCode(6 DOWNTO 1) = "001011") -- PUSH, CALL
            OR (opCode = "0000100") -- INT
            OR (opCode(6 DOWNTO 3) = "1011") -- STD
            THEN
            WB <= '0';
            MEMRd_internal <= '0';
            MEMWr <= '1';
        ELSIF (opCode(6 DOWNTO 1) = "000011") -- RET, RTI
            THEN
            WB <= '0';
            MEMRd_internal <= '1';
            MEMWr <= '0';
        ELSIF (opCode = "1110010") -- LDD
            OR (opCode = "0100001") -- POP
            THEN
            WB <= '1';
            MEMRd_internal <= '1';
            MEMWr <= '0';
        ELSE
            WB <= '0';
            MEMRd_internal <= '0';
            MEMWr <= '0';
        END IF;

        ------------ EXE ------------
        IF ((opCode(6 DOWNTO 1) = "011100") -- ADD, INC
            OR (opCode(6 DOWNTO 3) = "1011") -- STD
            OR (opCode = "1110010")) THEN -- LDD
            EXE <= "001";
        ELSIF (opCode = "0111010") THEN -- AND
            EXE <= "011";
        ELSIF (opCode = "0111011") THEN -- NOT
            EXE <= "100";
        ELSIF (opCode = "0000010") THEN -- SETC
            EXE <= "101";
        ELSIF (opCode = "0111100") THEN -- SUB
            EXE <= "010";
        ELSE
            EXE <= "000";
        END IF;

        ------------ ALUSrc ------------
        IF (opCode = "0111001") -- INC
            OR (opCode(6 DOWNTO 1) = "111" & "000") -- IADD
            OR (opCode(6 DOWNTO 3) = "1011") -- STD
            OR (opCode = "1110010") THEN -- LDD
            ALUSrc <= '1';
        ELSE
            ALUSrc <= '0';
        END IF;

        ------------ SPInc ------------
        IF (opCode(6 DOWNTO 1) = "000011") -- RET, RTI
            OR (opCode = "0100001") THEN -- POP
            SPInc_internal <= '1';
        ELSE
            SPInc_internal <= '0';
        END IF;

        ------------ SPDec ------------
        IF (opCode(6 DOWNTO 1) = "001011") -- PUSH, CALL
            OR (opCode = "0000100") THEN -- INT
            SPDec_internal <= '1';
        ELSE
            SPDec_internal <= '0';
        END IF;

    END PROCESS;

    SPInc <= SPInc_internal;
    SPDec <= SPDec_internal;
    MEMRd <= MEMRd_internal;

    ------------ MEMToReg ------------
    MEMToReg <= MEMRd_internal;

    ------------ DMAddress ------------
    DMAddress <= '1' WHEN SPInc_internal = '1' OR SPDec_internal = '1' ELSE
        '0';
END Behavioral;