LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY EXE_MEM IS
    PORT (
        clk, rst : IN STD_LOGIC;
        --  Inputs
        WB_IN, MEMRd_IN, MEMWr_IN, PUSH_IN, CALL_IN, INT_IN, POP_IN, RET_IN, RTI_IN, OUTPORT_IN, LDM_IN, MemToReg_IN : IN STD_LOGIC;
        EXE_IN, Rdst_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        PC_IN, MemAddress_IN, MemoryData_IN, Immediate_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        -- Outputs
        WB_OUT, MEMRd_OUT, MEMWr_OUT, PUSH_OUT, CALL_OUT, INT_OUT, POP_OUT, RET_OUT, RTI_OUT, OUTPORT_OUT, LDM_OUT, MemToReg_OUT : OUT STD_LOGIC;
        EXE_OUT, Rdst_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        PC_OUT, MemAddress_OUT, MemoryData_OUT, Immediate_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );
END EXE_MEM;

ARCHITECTURE RTL OF EXE_MEM IS

    SIGNAL WB_Signal, MEMRd_Signal, MEMWr_Signal, PUSH_Signal, CALL_Signal, INT_signal, POP_Signal, RET_Signal, RTI_Signal, OUTPORT_Signal, LDM_Signal, MemToReg_Signal : STD_LOGIC;
    SIGNAL EXE_Signal, Rdst_Signal : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL PC_Signal, MemAddress_Signal, MemoryData_Signal, Immediate_Signal : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN

    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            WB_Signal <= '0';
            MEMRd_Signal <= '0';
            MEMWr_Signal <= '0';
            PUSH_Signal <= '0';
            CALL_Signal <= '0';
            INT_signal <= '0';
            POP_Signal <= '0';
            RET_Signal <= '0';
            RTI_Signal <= '0';
            OUTPORT_Signal <= '0';
            LDM_Signal <= '0';
            MemToReg_Signal <= '0';
            EXE_Signal <= (OTHERS => '0');
            Rdst_Signal <= (OTHERS => '0');
            PC_Signal <= (OTHERS => '0');
            MemAddress_Signal <= (OTHERS => '0');
            MemoryData_Signal <= (OTHERS => '0');
            Immediate_Signal <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            WB_Signal <= WB_IN;
            MEMRd_Signal <= MEMRd_IN;
            MEMWr_Signal <= MEMWr_IN;
            PUSH_Signal <= PUSH_IN;
            CALL_Signal <= CALL_IN;
            POP_Signal <= POP_IN;
            RET_Signal <= RET_IN;
            RTI_Signal <= RTI_IN;
            INT_signal <= INT_IN;
            OUTPORT_Signal <= OUTPORT_IN;
            LDM_Signal <= LDM_IN;
            MemToReg_Signal <= MemToReg_IN;
            EXE_Signal <= EXE_IN;
            Rdst_Signal <= Rdst_IN;
            PC_Signal <= PC_IN;
            MemAddress_Signal <= MemAddress_IN;
            MemoryData_Signal <= MemoryData_IN;
            Immediate_Signal <= Immediate_IN;
        END IF;
    END PROCESS;

    WB_OUT <= WB_Signal;
    MEMRd_OUT <= MEMRd_Signal;
    MEMWr_OUT <= MEMWr_Signal;
    PUSH_OUT <= PUSH_Signal;
    CALL_OUT <= CALL_Signal;
    POP_OUT <= POP_Signal;
    RET_OUT <= RET_Signal;
    RTI_OUT <= RTI_Signal;
    INT_OUT <= INT_signal;
    OUTPORT_OUT <= OUTPORT_Signal;
    LDM_OUT <= LDM_Signal;
    MemToReg_OUT <= MemToReg_Signal;
    EXE_OUT <= EXE_Signal;
    Rdst_OUT <= Rdst_Signal;
    PC_OUT <= PC_Signal;
    MemAddress_OUT <= MemAddress_Signal;
    MemoryData_OUT <= MemoryData_Signal;
    Immediate_OUT <= Immediate_Signal;

END ARCHITECTURE;