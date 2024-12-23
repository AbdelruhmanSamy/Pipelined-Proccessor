LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ControlUnit IS
    PORT (
        opCode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        WB, MEMRd, MEMWr, MEMToReg, ALUSrc, SPInc, SPDec, DMAddress : OUT STD_LOGIC;
        INC, INT, RTI, JMP, CALL, RET, POP, PUSH, LDM, R_Type, IN_PORT : OUT STD_LOGIC;
        EXE : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ControlUnit;

ARCHITECTURE Behavioral OF ControlUnit IS
    -- Internal signals for instruction type detection
    SIGNAL R_Type_int, INC_int, INT_int, RTI_int : STD_LOGIC;
    SIGNAL JMP_int, CALL_int, RET_int, POP_int : STD_LOGIC;
    SIGNAL PUSH_int, LDM_int, IN_PORT_int : STD_LOGIC;
    SIGNAL SPInc_internal, SPDec_internal, MEMRd_internal : STD_LOGIC;
    SIGNAL WB_internal, MEMWr_internal, ALUSrc_internal : STD_LOGIC;
    SIGNAL EXE_internal : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
    -- Combinational process for instruction decoding
    PROCESS (opCode)
    BEGIN
        -- Reset all internal signals
        R_Type_int <= '0';
        INC_int <= '0';
        INT_int <= '0';
        RTI_int <= '0';
        JMP_int <= '0';
        CALL_int <= '0';
        RET_int <= '0';
        POP_int <= '0';
        PUSH_int <= '0';
        LDM_int <= '0';
        IN_PORT_int <= '0';

        -- Instruction type detection
        CASE opCode IS
            WHEN "0111001" => INC_int <= '1';
            WHEN "0000100" => INT_int <= '1';
            WHEN "0000110" => RTI_int <= '1';
            WHEN "0010101" => JMP_int <= '1';
            WHEN "0010110" => CALL_int <= '1';
            WHEN "0000111" => RET_int <= '1';
            WHEN "0100001" => POP_int <= '1';
            WHEN "0010111" => PUSH_int <= '1';
            WHEN "1110001" => LDM_int <= '1';
            WHEN "0100000" => IN_PORT_int <= '1';
            WHEN OTHERS => NULL;
        END CASE;

        -- R-Type detection
        IF opCode(6 DOWNTO 3) = "0111" THEN
            R_Type_int <= '1';
        END IF;

        -- Control signals generation
        -- WB, MEMRd, MEMWr
        IF (R_Type_int = '1' OR LDM_int = '1' OR IN_PORT_int = '1') THEN
            WB_internal <= '1';
            MEMRd_internal <= '0';
            MEMWr_internal <= '0';
        ELSIF (PUSH_int = '1' OR CALL_int = '1' OR INT_int = '1') THEN
            WB_internal <= '0';
            MEMRd_internal <= '0';
            MEMWr_internal <= '1';
        ELSIF (RET_int = '1' OR RTI_int = '1') THEN
            WB_internal <= '0';
            MEMRd_internal <= '1';
            MEMWr_internal <= '0';
        ELSIF POP_int = '1' THEN
            WB_internal <= '1';
            MEMRd_internal <= '1';
            MEMWr_internal <= '0';
        ELSE
            WB_internal <= '0';
            MEMRd_internal <= '0';
            MEMWr_internal <= '0';
        END IF;

        -- EXE control
        IF opCode = "0000010" THEN -- SETC instruction
            EXE_internal <= "101"; -- Set Carry Flag
        ELSIF opCode = "0111001" THEN -- INC instruction
            EXE_internal <= "001"; -- Increment
        ELSIF R_Type_int = '1' THEN -- R-type instructions
            CASE opCode(2 DOWNTO 0) IS
                WHEN "000" => EXE_internal <= "001"; -- ADD
                WHEN "010" => EXE_internal <= "011"; -- AND
                WHEN "100" => EXE_internal <= "010"; -- SUB
                WHEN "011" => EXE_internal <= "100"; -- NOT
                WHEN OTHERS => EXE_internal <= "000"; -- Default case
            END CASE;
        ELSE
            EXE_internal <= "000"; -- Default for non-R-type instructions
        END IF;

        -- ALUSrc control
        IF INC_int = '1' OR LDM_int = '1' THEN
            ALUSrc_internal <= '1';
        ELSE
            ALUSrc_internal <= '0';
        END IF;

        -- SP control
        IF (RET_int = '1' OR RTI_int = '1' OR POP_int = '1') THEN
            SPInc_internal <= '1';
        ELSE
            SPInc_internal <= '0';
        END IF;

        IF (PUSH_int = '1' OR CALL_int = '1' OR INT_int = '1') THEN
            SPDec_internal <= '1';
        ELSE
            SPDec_internal <= '0';
        END IF;
    END PROCESS;

    -- Concurrent signal assignments outside the process
    WB <= WB_internal;
    MEMRd <= MEMRd_internal;
    MEMWr <= MEMWr_internal;
    MEMToReg <= MEMRd_internal;
    ALUSrc <= ALUSrc_internal;
    SPInc <= SPInc_internal;
    SPDec <= SPDec_internal;
    EXE <= EXE_internal;

    -- Instruction type outputs
    R_Type <= R_Type_int;
    INC <= INC_int;
    INT <= INT_int;
    RTI <= RTI_int;
    JMP <= JMP_int;
    CALL <= CALL_int;
    RET <= RET_int;
    POP <= POP_int;
    PUSH <= PUSH_int;
    LDM <= LDM_int;
    IN_PORT <= IN_PORT_int;

    -- Memory address selection
    DMAddress <= '1' WHEN (SPInc_internal = '1' OR SPDec_internal = '1') ELSE
        '0';
END Behavioral;

ARCHITECTURE Behavioral OF ControlUnit IS
    SIGNAL SPInc_internal, SPDec_internal, MEMRd_internal : STD_LOGIC;
    SIGNAL R_Type_int, INC_int, INT_int, RTI_int : STD_LOGIC;
    SIGNAL JMP_int, CALL_int, RET_int, POP_int : STD_LOGIC;
    SIGNAL PUSH_int, LDM_int, IN_PORT_int : STD_LOGIC;

BEGIN
    PROCESS (opCode)
    BEGIN
        -- Reset all internal signals
        R_Type_int <= '0';
        INC_int <= '0';
        INT_int <= '0';
        RTI_int <= '0';
        JMP_int <= '0';
        CALL_int <= '0';
        RET_int <= '0';
        POP_int <= '0';
        PUSH_int <= '0';
        LDM_int <= '0';
        IN_PORT_int <= '0';

        -- Instruction type detection
        CASE opCode IS
            WHEN "0111001" => INC_int <= '1';
            WHEN "0000100" => INT_int <= '1';
            WHEN "0000110" => RTI_int <= '1';
            WHEN "0010101" => JMP_int <= '1';
            WHEN "0010110" => CALL_int <= '1';
            WHEN "0000111" => RET_int <= '1';
            WHEN "0100001" => POP_int <= '1';
            WHEN "0010111" => PUSH_int <= '1';
            WHEN "1110001" => LDM_int <= '1';
            WHEN "0100000" => IN_PORT_int <= '1';
            WHEN OTHERS => NULL;
        END CASE;

        -- R-Type detection
        IF opCode(6 DOWNTO 3) = "0111" THEN
            R_Type_int <= '1';
        END IF;
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

    -- Instruction type outputs
    R_Type <= R_Type_int;
    INC <= INC_int;
    INT <= INT_int;
    RTI <= RTI_int;
    JMP <= JMP_int;
    CALL <= CALL_int;
    RET <= RET_int;
    POP <= POP_int;
    PUSH <= PUSH_int;
    LDM <= LDM_int;
    IN_PORT <= IN_PORT_int;
    ------------ MEMToReg ------------
    MEMToReg <= MEMRd_internal;

    ------------ DMAddress ------------
    DMAddress <= '1' WHEN SPInc_internal = '1' OR SPDec_internal = '1' ELSE
        '0';
END Behavioral;