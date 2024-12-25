LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ID_EXE IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;

        -- Inputs from the previous pipeline stage (ID stage)
        PC_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Rsrc1_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Rsrc2_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Rdst_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        -- Inputs from  control unit
        Flags_Sel_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        SP_EA_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEMRd_in : IN STD_LOGIC;
        MEMWr_in : IN STD_LOGIC;
        MEMToReg_in : IN STD_LOGIC;
        ALUSrc_in : IN STD_LOGIC;
        Inc_in : IN STD_LOGIC;
        SPInc_in : IN STD_LOGIC;
        SPDec_in : IN STD_LOGIC;
        EXE_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        -- Newly Added Signals -- 

        ---- inputs
        WB_IN : IN STD_LOGIC;
        INT_IN : IN STD_LOGIC;
        RTI_IN : IN STD_LOGIC;
        JMP_IN : IN STD_LOGIC;
        CALL_IN : IN STD_LOGIC;
        RET_IN : IN STD_LOGIC;
        POP_IN : IN STD_LOGIC;
        PUSH_IN : IN STD_LOGIC;
        LDM_IN : IN STD_LOGIC;
        R_Type_IN : IN STD_LOGIC;
        ---- outputs
        WB_OUT : OUT STD_LOGIC;
        INT_OUT : OUT STD_LOGIC;
        RTI_OUT : OUT STD_LOGIC;
        JMP_OUT : OUT STD_LOGIC;
        CALL_OUT : OUT STD_LOGIC;
        RET_OUT : OUT STD_LOGIC;
        POP_OUT : OUT STD_LOGIC;
        PUSH_OUT : OUT STD_LOGIC;
        LDM_OUT : OUT STD_LOGIC;
        R_Type_OUT : OUT STD_LOGIC;

        -- Outputs to the next pipeline stage (EX stage)
        PC_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Rsrc1_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Rsrc2_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Rdst_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Flags_Sel_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        SP_EA_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEMRd_out : OUT STD_LOGIC;
        MEMWr_out : OUT STD_LOGIC;
        MEMToReg_out : OUT STD_LOGIC;
        ALUSrc_out : OUT STD_LOGIC;
        Inc_out : OUT STD_LOGIC;
        SPInc_out : OUT STD_LOGIC;
        SPDec_out : OUT STD_LOGIC;
        EXE_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ID_EXE;

ARCHITECTURE Behavioral OF ID_EXE IS
    -- Internal signals to store values from the ID stage
    SIGNAL PC_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Rsrc1_sig, Rsrc2_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Rdst_sig : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Flags_Sel_sig : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL SP_EA_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL WB_sig, MEMRd_sig, MEMWr_sig, MEMToReg_sig : STD_LOGIC;
    SIGNAL ALUSrc_sig, Inc_sig, SPInc_sig, SPDec_sig : STD_LOGIC;
    SIGNAL EXE_sig : STD_LOGIC_VECTOR(2 DOWNTO 0);

    -- Newly Added Signals --
    SIGNAL INT_sig : STD_LOGIC;
    SIGNAL RTI_sig : STD_LOGIC;
    SIGNAL JMP_sig : STD_LOGIC;
    SIGNAL CALL_sig : STD_LOGIC;
    SIGNAL RET_sig : STD_LOGIC;
    SIGNAL POP_sig : STD_LOGIC;
    SIGNAL PUSH_sig : STD_LOGIC;
    SIGNAL LDM_sig : STD_LOGIC;
    SIGNAL R_Type_sig : STD_LOGIC;

BEGIN
    -- Process to update the pipeline registers at each clock cycle
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            -- Reset the pipeline registers
            PC_sig <= (OTHERS => '0');
            Rsrc1_sig <= (OTHERS => '0');
            Rsrc2_sig <= (OTHERS => '0');
            Rdst_sig <= (OTHERS => '0');
            Flags_Sel_sig <= (OTHERS => '0');
            SP_EA_sig <= (OTHERS => '0');
            WB_sig <= '0';
            MEMRd_sig <= '0';
            MEMWr_sig <= '0';
            MEMToReg_sig <= '0';
            ALUSrc_sig <= '0';
            Inc_sig <= '0';
            SPInc_sig <= '0';
            SPDec_sig <= '0';
            EXE_sig <= "000"; -- Default execution operation
            ELSIF rising_edge(clk) THEN
            -- Capture inputs on rising edge of clock
            PC_sig <= PC_IN;
            Rsrc1_sig <= Rsrc1_in;
            Rsrc2_sig <= Rsrc2_in;
            Rdst_sig <= Rdst_in;
            Flags_Sel_sig <= Flags_Sel_in;
            SP_EA_sig <= SP_EA_in;
            WB_sig <= WB_IN;
            MEMRd_sig <= MEMRd_in;
            MEMWr_sig <= MEMWr_in;
            MEMToReg_sig <= MEMToReg_in;
            ALUSrc_sig <= ALUSrc_in;
            Inc_sig <= Inc_in;
            SPInc_sig <= SPInc_in;
            SPDec_sig <= SPDec_in;
            EXE_sig <= EXE_in;

            -- Newly Added Signals --
            INT_sig <= INT_IN;
            RTI_sig <= RTI_IN;
            JMP_sig <= JMP_IN;
            CALL_sig <= CALL_IN;
            RET_sig <= RET_IN;
            POP_sig <= POP_IN;
            PUSH_sig <= PUSH_IN;
            LDM_sig <= LDM_IN;
            R_Type_sig <= R_Type_IN;

        END IF;
    END PROCESS;

    -- Assign internal signals to the outputs for the next pipeline stage (EX)
    PC_out <= PC_sig;
    Rsrc1_out <= Rsrc1_sig;
    Rsrc2_out <= Rsrc2_sig;
    Rdst_out <= Rdst_sig;
    Flags_Sel_out <= Flags_Sel_sig;
    SP_EA_out <= SP_EA_sig;
    MEMRd_out <= MEMRd_sig;
    MEMWr_out <= MEMWr_sig;
    MEMToReg_out <= MEMToReg_sig;
    ALUSrc_out <= ALUSrc_sig;
    Inc_out <= Inc_sig;
    SPInc_out <= SPInc_sig;
    SPDec_out <= SPDec_sig;
    EXE_out <= EXE_sig;

    WB_OUT <= WB_sig;
    INT_OUT <= INT_sig;
    RTI_OUT <= RTI_sig;
    JMP_OUT <= JMP_sig;
    CALL_OUT <= CALL_sig;
    RET_OUT <= RET_sig;
    POP_OUT <= POP_sig;
    PUSH_OUT <= PUSH_sig;
    LDM_OUT <= LDM_sig;
    R_Type_OUT <= R_Type_sig;
END Behavioral;