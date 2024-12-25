LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY EXE_MEM_tb IS
END EXE_MEM_tb;

ARCHITECTURE behavior OF EXE_MEM_tb IS

    -- Component declaration for EXE_MEM
    COMPONENT EXE_MEM
        PORT (
            clk, rst : IN STD_LOGIC;
            WB_IN, MEMRd_IN, MEMWr_IN, PUSH_IN, CALL_IN, INT_IN, POP_IN, RET_IN, RTI_IN, OUTPORT_IN, LDM_IN, MemToReg_IN : IN STD_LOGIC;
            EXE_IN, Rdst_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            PC_IN, MemAddress_IN, MemoryData_IN, Immediate_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

            WB_OUT, MEMRd_OUT, MEMWr_OUT, PUSH_OUT, CALL_OUT, INT_OUT, POP_OUT, RET_OUT, RTI_OUT, OUTPORT_OUT, LDM_OUT, MemToReg_OUT : OUT STD_LOGIC;
            EXE_OUT, Rdst_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            PC_OUT, MemAddress_OUT, MemoryData_OUT, Immediate_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for the DUT
    SIGNAL clk, rst : STD_LOGIC := '0';
    SIGNAL WB_IN, MEMRd_IN, MEMWr_IN, PUSH_IN, CALL_IN, INT_IN, POP_IN, RET_IN, RTI_IN, OUTPORT_IN, LDM_IN, MemToReg_IN : STD_LOGIC := '0';
    SIGNAL EXE_IN, Rdst_IN : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL PC_IN, MemAddress_IN, MemoryData_IN, Immediate_IN : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    SIGNAL WB_OUT, MEMRd_OUT, MEMWr_OUT, PUSH_OUT, CALL_OUT, INT_OUT, POP_OUT, RET_OUT, RTI_OUT, OUTPORT_OUT, LDM_OUT, MemToReg_OUT : STD_LOGIC;
    SIGNAL EXE_OUT, Rdst_OUT : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL PC_OUT, MemAddress_OUT, MemoryData_OUT, Immediate_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    UUT : EXE_MEM PORT MAP(
        clk => clk,
        rst => rst,
        WB_IN => WB_IN,
        MEMRd_IN => MEMRd_IN,
        MEMWr_IN => MEMWr_IN,
        PUSH_IN => PUSH_IN,
        CALL_IN => CALL_IN,
        POP_IN => POP_IN,
        RET_IN => RET_IN,
        RTI_IN => RTI_IN,
        INT_IN => INT_IN,
        OUTPORT_IN => OUTPORT_IN,
        LDM_IN => LDM_IN,
        MemToReg_IN => MemToReg_IN,
        EXE_IN => EXE_IN,
        Rdst_IN => Rdst_IN,
        PC_IN => PC_IN,
        MemAddress_IN => MemAddress_IN,
        MemoryData_IN => MemoryData_IN,
        Immediate_IN => Immediate_IN,
        WB_OUT => WB_OUT,
        MEMRd_OUT => MEMRd_OUT,
        MEMWr_OUT => MEMWr_OUT,
        PUSH_OUT => PUSH_OUT,
        CALL_OUT => CALL_OUT,
        POP_OUT => POP_OUT,
        RET_OUT => RET_OUT,
        RTI_OUT => RTI_OUT,
        INT_OUT => INT_OUT,
        OUTPORT_OUT => OUTPORT_OUT,
        LDM_OUT => LDM_OUT,
        MemToReg_OUT => MemToReg_OUT,
        EXE_OUT => EXE_OUT,
        Rdst_OUT => Rdst_OUT,
        PC_OUT => PC_OUT,
        MemAddress_OUT => MemAddress_OUT,
        MemoryData_OUT => MemoryData_OUT,
        Immediate_OUT => Immediate_OUT
    );

    -- Clock process
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- Reset the system
        rst <= '1';
        WAIT FOR clk_period * 2;
        rst <= '0';

        -- Apply test vectors
        WB_IN <= '1';
        MEMRd_IN <= '1';
        MEMWr_IN <= '0';
        PUSH_IN <= '1';
        CALL_IN <= '0';
        INT_IN <= '1';
        POP_IN <= '0';
        RET_IN <= '1';
        RTI_IN <= '0';
        OUTPORT_IN <= '1';
        LDM_IN <= '0';
        MemToReg_IN <= '1';
        EXE_IN <= "101";
        Rdst_IN <= "011";
        PC_IN <= X"1234";
        MemAddress_IN <= X"5678";
        MemoryData_IN <= X"9ABC";
        Immediate_IN <= X"DEF0";

        WAIT FOR clk_period * 5;

        -- Change test vectors
        WB_IN <= '0';
        MEMRd_IN <= '0';
        MEMWr_IN <= '1';
        PUSH_IN <= '0';
        CALL_IN <= '1';
        INT_IN <= '0';
        POP_IN <= '1';
        RET_IN <= '0';
        RTI_IN <= '1';
        OUTPORT_IN <= '0';
        LDM_IN <= '1';
        MemToReg_IN <= '0';
        EXE_IN <= "110";
        Rdst_IN <= "100";
        PC_IN <= X"4321";
        MemAddress_IN <= X"8765";
        MemoryData_IN <= X"CBA9";
        Immediate_IN <= X"0FED";

        WAIT FOR clk_period * 5;

        -- End simulation
        WAIT;
    END PROCESS;

END behavior;