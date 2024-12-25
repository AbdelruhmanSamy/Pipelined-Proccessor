LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY pipelined_processor IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        in_port_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END pipelined_processor;

ARCHITECTURE RTL OF pipelined_processor IS
    COMPONENT ControlUnit IS
        PORT (
            opCode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            WB, MEMRd, MEMWr, MEMToReg, ALUSrc, SPInc, SPDec, DMAddress : OUT STD_LOGIC;
            INC, INT, RTI, JMP, CALL, RET, POP, PUSH, LDM, R_Type, IN_PORT : OUT STD_LOGIC;
            EXE : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT fetch_stage IS
        GENERIC (
            DATA_SIZE : INTEGER := 16
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            pc_register_enable : IN STD_LOGIC;
            index : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            INT : IN STD_LOGIC;
            RTI : IN STD_LOGIC;
            HLT : IN STD_LOGIC;
            JCond : IN STD_LOGIC;
            JMP : IN STD_LOGIC;
            CALL : IN STD_LOGIC;
            RET : IN STD_LOGIC;
            empty_SP : IN STD_LOGIC;
            invalid_mem_address : IN STD_LOGIC;
            NOP : IN STD_LOGIC;
            Rsrc1 : IN STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
            DM_SP : IN STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
            IM_0 : IN STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
            IM_4 : IN STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
            IM_2 : IN STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
            instruction, PC_OUT : OUT STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT IF_ID_Register IS
        PORT (
            CLK : IN STD_LOGIC;
            RESET : IN STD_LOGIC;
            WRITE_EN : IN STD_LOGIC;
            FLUSH_IN : IN STD_LOGIC;
            PC_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            INSTR_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            FLUSH_OUT : OUT STD_LOGIC;
            PC_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            INSTR_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT decode_stage IS
        GENERIC (
            REGISTER_SIZE : INTEGER := 16;
            REGISTER_NUMBER : INTEGER := 8
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            fetched_instruction : IN STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
            reg_write : IN STD_LOGIC;
            write_back_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_back_data : IN STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
            input_port_data : IN STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
            IN_PORT_IN : IN STD_LOGIC;
            read_data_1 : OUT STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
            read_data_2 : OUT STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT ID_EXE IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            PC_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Rsrc1_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Rsrc2_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Rdst_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
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
            EXE_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            WB_OUT : OUT STD_LOGIC;
            INT_OUT : OUT STD_LOGIC;
            RTI_OUT : OUT STD_LOGIC;
            JMP_OUT : OUT STD_LOGIC;
            CALL_OUT : OUT STD_LOGIC;
            RET_OUT : OUT STD_LOGIC;
            POP_OUT : OUT STD_LOGIC;
            PUSH_OUT : OUT STD_LOGIC;
            LDM_OUT : OUT STD_LOGIC;
            R_Type_OUT : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT exe_stage IS
        PORT (
            EXE_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            operand1, operand2, immediate_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            ALUSrc, Inc : IN STD_LOGIC;
            memory_address, memory_data, immediate_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT EXE_MEM IS
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

    COMPONENT memory_stage IS
        PORT (
            ResetMemory : IN STD_LOGIC;
            MemWrite : IN STD_LOGIC;
            MemRead : IN STD_LOGIC;
            POP : IN STD_LOGIC;
            RET : IN STD_LOGIC;
            PUSH : IN STD_LOGIC;
            CALL : IN STD_LOGIC;
            INT : IN STD_LOGIC;
            RTI : IN STD_LOGIC;
            LDM : IN STD_LOGIC;
            PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            SP : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            FlagsAddress : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            MemoryAddress : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            MemoryDataIn : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Immediate : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            MemoryDataOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            memory_address_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT MEM_WB_Register IS
        PORT (
            CLK : IN STD_LOGIC;
            RESET : IN STD_LOGIC;
            WRITE_EN : IN STD_LOGIC;
            WB_IN : IN STD_LOGIC;
            WB_DATA_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            WB_ADDR_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Rdst_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            MemToReg_IN : IN STD_LOGIC;
            WB_OUT : OUT STD_LOGIC;
            WB_DATA_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            WB_ADDR_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            Rdst_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            MemToReg_OUT : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT writeback_stage IS
        PORT (
            MemtoReg : IN STD_LOGIC;
            WB_data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            WB_address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            Rdst_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            WB_data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            Rdst_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

    -- Signal declarations
    SIGNAL instruction_fetch_stage_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL PC_fetch_stage_out : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- IF/ID Register Signals
    SIGNAL pc_signal : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL instr_signal : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Control Unit Signals
    SIGNAL WB_signal : STD_LOGIC;
    SIGNAL MEMRd_signal : STD_LOGIC;
    SIGNAL MEMWr_signal : STD_LOGIC;
    SIGNAL MEMToReg_signal : STD_LOGIC;
    SIGNAL AlUSrc_signal : STD_LOGIC;
    SIGNAL SPInc_signal : STD_LOGIC;
    SIGNAL SPDec_signal : STD_LOGIC;
    SIGNAL INC_signal : STD_LOGIC;
    SIGNAL DMAddress_signal : STD_LOGIC;
    SIGNAL INT_signal : STD_LOGIC;
    SIGNAL RTI_signal : STD_LOGIC;
    SIGNAL JMP_signal : STD_LOGIC;
    SIGNAL CALL_signal : STD_LOGIC;
    SIGNAL RET_signal : STD_LOGIC;
    SIGNAL POP_signal : STD_LOGIC;
    SIGNAL PUSH_signal : STD_LOGIC;
    SIGNAL LDM_signal : STD_LOGIC;
    SIGNAL R_Type_signal : STD_LOGIC;
    SIGNAL IN_PORT_signal : STD_LOGIC;
    SIGNAL EXE_signal : STD_LOGIC_VECTOR(2 DOWNTO 0);

    -- Decode Stage Signals
    SIGNAL operand1_signal : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL operand2_signal : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- ID/EXE Register Output Signals
    SIGNAL WB_ID_EXE_out : STD_LOGIC;
    SIGNAL INT_ID_EXE_out : STD_LOGIC;
    SIGNAL RTI_ID_EXE_out : STD_LOGIC;
    SIGNAL JMP_ID_EXE_out : STD_LOGIC;
    SIGNAL CALL_ID_EXE_out : STD_LOGIC;
    -- ID/EXE Register Output Signals (continued)
    SIGNAL RET_ID_EXE_out : STD_LOGIC;
    SIGNAL POP_ID_EXE_out : STD_LOGIC;
    SIGNAL PUSH_ID_EXE_out : STD_LOGIC;
    SIGNAL LDM_ID_EXE_out : STD_LOGIC;
    SIGNAL R_Type_ID_EXE_out : STD_LOGIC;
    SIGNAL OUTPORT_ID_EXE_out : STD_LOGIC;
    SIGNAL PC_ID_EXE_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL operand1_ID_EXE_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL operand2_ID_EXE_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Rdst_ID_EXE_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Flags_Sel_ID_EXE_out : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL SP_EA_ID_EXE_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MEMRd_ID_EXE_out : STD_LOGIC;
    SIGNAL MEMWr_ID_EXE_out : STD_LOGIC;
    SIGNAL MEMToReg_ID_EXE_out : STD_LOGIC;
    SIGNAL ALUSrc_ID_EXE_out : STD_LOGIC;
    SIGNAL Inc_ID_EXE_out : STD_LOGIC;
    SIGNAL SPInc_ID_EXE_out : STD_LOGIC;
    SIGNAL SPDec_ID_EXE_out : STD_LOGIC;
    SIGNAL EXE_ID_EXE_out : STD_LOGIC_VECTOR(2 DOWNTO 0);

    -- Execute Stage Signals
    SIGNAL memory_address_exe_stage_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL memory_data_exe_stage_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL immediate_exe_stage_out : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- EXE/MEM Register Output Signals
    SIGNAL WB_EXE_MEM_out : STD_LOGIC;
    SIGNAL MEMRd_EXE_MEM_out : STD_LOGIC;
    SIGNAL MEMWr_EXE_MEM_out : STD_LOGIC;
    SIGNAL PUSH_EXE_MEM_out : STD_LOGIC;
    SIGNAL CALL_EXE_MEM_out : STD_LOGIC;
    SIGNAL INT_EXE_MEM_out : STD_LOGIC;
    SIGNAL POP_EXE_MEM_out : STD_LOGIC;
    SIGNAL RET_EXE_MEM_out : STD_LOGIC;
    SIGNAL RTI_EXE_MEM_out : STD_LOGIC;
    SIGNAL OUTPORT_EXE_MEM_out : STD_LOGIC;
    SIGNAL LDM_EXE_MEM_out : STD_LOGIC;
    SIGNAL MemToReg_EXE_MEM_out : STD_LOGIC;
    SIGNAL EXE_EXE_MEM_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Rdst_EXE_MEM_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL PC_EXE_MEM_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL memory_address_EXE_MEM_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL memory_data_EXE_MEM_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL immediate_EXE_MEM_out : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Memory Stage Signals
    SIGNAL data_memory_stage_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL address_memory_stage_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL SP : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- MEM/WB Register Output Signals
    SIGNAL WB_MEM_WB_out : STD_LOGIC;
    SIGNAL MemToReg_MEM_WB_out : STD_LOGIC;
    SIGNAL memory_data_MEM_WB_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL memory_address_MEM_WB_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Rdst_MEM_WB_out : STD_LOGIC_VECTOR(2 DOWNTO 0);

    -- Writeback Stage Signals
    SIGNAL data_writeback_stage_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL address_writeback_stage_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL memory_address_memory_stage_in : STD_LOGIC_VECTOR(11 DOWNTO 0);

BEGIN
    -- Fetch Stage
    fetch_stage_inst : fetch_stage PORT MAP(
        clk => clk,
        reset => rst,
        pc_register_enable => '1',
        index => "0",
        INT => '0',
        RTI => '0',
        HLT => '0',
        JCond => '0',
        JMP => '0',
        CALL => '0',
        RET => '0',
        empty_SP => '0',
        invalid_mem_address => '0',
        NOP => '0',
        Rsrc1 => (OTHERS => '0'),
        DM_SP => (OTHERS => '0'),
        IM_0 => (OTHERS => '0'),
        IM_4 => (OTHERS => '0'),
        IM_2 => (OTHERS => '0'),
        instruction => instruction_fetch_stage_out,
        PC_OUT => PC_fetch_stage_out
    );

    -- IF/ID Register
    IF_ID_Reg_inst : IF_ID_Register PORT MAP(
        CLK => clk,
        RESET => rst,
        WRITE_EN => '1',
        FLUSH_IN => '0',
        PC_IN => PC_fetch_stage_out,
        INSTR_IN => instruction_fetch_stage_out,
        -- TODO: Change on integrating hazard unit
        FLUSH_OUT => OPEN,
        PC_OUT => pc_signal,
        INSTR_OUT => instr_signal
    );

    -- Control Unit
    control_unit_inst : ControlUnit PORT MAP(
        opCode => instr_signal(15 DOWNTO 9),
        WB => WB_signal,
        MEMRd => MEMRd_signal,
        MEMWr => MEMWr_signal,
        MEMToReg => MEMToReg_signal,
        ALUSrc => AlUSrc_signal,
        SPInc => SPInc_signal,
        SPDec => SPDec_signal,
        INC => INC_signal,
        DMAddress => DMAddress_signal,
        INT => INT_signal,
        RTI => RTI_signal,
        JMP => JMP_signal,
        CALL => CALL_signal,
        RET => RET_signal,
        POP => POP_signal,
        PUSH => PUSH_signal,
        LDM => LDM_signal,
        R_Type => R_Type_signal,
        IN_PORT => IN_PORT_signal,
        EXE => EXE_signal
    );

    -- Decode Stage
    decode_inst : decode_stage PORT MAP(
        clk => clk,
        reset => rst,
        fetched_instruction => instr_signal,
        reg_write => WB_MEM_WB_out,
        write_back_address => address_writeback_stage_out,
        write_back_data => data_writeback_stage_out,
        input_port_data => in_port_data,
        IN_PORT_IN => IN_PORT_signal,
        read_data_1 => operand1_signal,
        read_data_2 => operand2_signal
    );

    -- ID/EXE Register
    ID_EXE_inst : ID_EXE PORT MAP(
        clk => clk,
        rst => rst,
        PC_IN => pc_signal,
        Rsrc1_in => operand1_signal,
        Rsrc2_in => operand2_signal,
        Rdst_in => instr_signal(8 DOWNTO 6),
        Flags_Sel_in => "00",
        SP_EA_in => (OTHERS => '0'),
        MEMRd_in => MEMRd_signal,
        MEMWr_in => MEMWr_signal,
        MEMToReg_in => MEMToReg_signal,
        ALUSrc_in => AlUSrc_signal,
        Inc_in => INC_signal,
        SPInc_in => SPInc_signal,
        SPDec_in => SPDec_signal,
        EXE_in => EXE_signal,
        WB_IN => WB_signal,
        INT_IN => INT_signal,
        RTI_IN => RTI_signal,
        JMP_IN => JMP_signal,
        CALL_IN => CALL_signal,
        RET_IN => RET_signal,
        POP_IN => POP_signal,
        PUSH_IN => PUSH_signal,
        LDM_IN => LDM_signal,
        R_Type_IN => R_Type_signal,
        PC_out => PC_ID_EXE_out,
        Rsrc1_out => operand1_ID_EXE_out,
        Rsrc2_out => operand2_ID_EXE_out,
        Rdst_out => Rdst_ID_EXE_out,
        Flags_Sel_out => Flags_Sel_ID_EXE_out,
        SP_EA_out => SP_EA_ID_EXE_out,
        MEMRd_out => MEMRd_ID_EXE_out,
        MEMWr_out => MEMWr_ID_EXE_out,
        MEMToReg_out => MEMToReg_ID_EXE_out,
        ALUSrc_out => ALUSrc_ID_EXE_out,
        Inc_out => Inc_ID_EXE_out,
        SPInc_out => SPInc_ID_EXE_out,
        SPDec_out => SPDec_ID_EXE_out,
        EXE_out => EXE_ID_EXE_out,
        WB_OUT => WB_ID_EXE_out,
        INT_OUT => INT_ID_EXE_out,
        RTI_OUT => RTI_ID_EXE_out,
        JMP_OUT => JMP_ID_EXE_out,
        CALL_OUT => CALL_ID_EXE_out,
        RET_OUT => RET_ID_EXE_out,
        POP_OUT => POP_ID_EXE_out,
        PUSH_OUT => PUSH_ID_EXE_out,
        LDM_OUT => LDM_ID_EXE_out,
        R_Type_OUT => R_Type_ID_EXE_out
    );

    -- Execute Stage
    exe_stage_inst : exe_stage PORT MAP(
        EXE_IN => EXE_ID_EXE_out,
        operand1 => operand1_ID_EXE_out,
        operand2 => operand2_ID_EXE_out,
        immediate_IN => instr_signal,
        ALUSrc => ALUSrc_ID_EXE_out,
        Inc => Inc_ID_EXE_out,
        memory_address => memory_address_exe_stage_out,
        memory_data => memory_data_exe_stage_out,
        immediate_OUT => immediate_exe_stage_out
    );

    -- EXE/MEM Register
    EXE_MEM_inst : EXE_MEM PORT MAP(
        clk => clk,
        rst => rst,
        WB_IN => WB_ID_EXE_out,
        MEMRd_IN => MEMRd_ID_EXE_out,
        MEMWr_IN => MEMWr_ID_EXE_out,
        PUSH_IN => PUSH_ID_EXE_out,
        CALL_IN => CALL_ID_EXE_out,
        INT_IN => INT_ID_EXE_out,
        POP_IN => POP_ID_EXE_out,
        RET_IN => RET_ID_EXE_out,
        RTI_IN => RTI_ID_EXE_out,
        OUTPORT_IN => OUTPORT_ID_EXE_out,
        LDM_IN => LDM_ID_EXE_out,
        MemToReg_IN => MEMToReg_ID_EXE_out,
        EXE_IN => EXE_ID_EXE_out,
        Rdst_IN => Rdst_ID_EXE_out,
        PC_IN => PC_ID_EXE_out,
        MemAddress_IN => memory_address_exe_stage_out,
        MemoryData_IN => memory_data_exe_stage_out,
        Immediate_IN => immediate_exe_stage_out,
        WB_OUT => WB_EXE_MEM_out,
        MEMRd_OUT => MEMRd_EXE_MEM_out,
        MEMWr_OUT => MEMWr_EXE_MEM_out,
        PUSH_OUT => PUSH_EXE_MEM_out,
        CALL_OUT => CALL_EXE_MEM_out,
        INT_OUT => INT_EXE_MEM_out,
        POP_OUT => POP_EXE_MEM_out,
        RET_OUT => RET_EXE_MEM_out,
        RTI_OUT => RTI_EXE_MEM_out,
        OUTPORT_OUT => OUTPORT_EXE_MEM_out,
        LDM_OUT => LDM_EXE_MEM_out,
        MemToReg_OUT => MemToReg_EXE_MEM_out,
        EXE_OUT => EXE_EXE_MEM_out,
        Rdst_OUT => Rdst_EXE_MEM_out,
        PC_OUT => PC_EXE_MEM_out,
        MemAddress_OUT => memory_address_EXE_MEM_out,
        MemoryData_OUT => memory_data_EXE_MEM_out,
        Immediate_OUT => immediate_EXE_MEM_out
    );

    memory_address_memory_stage_in <= STD_LOGIC_VECTOR(resize(signed(memory_address_EXE_MEM_out), 12));

    memory_stage_inst : memory_stage PORT MAP(
        ResetMemory => rst,
        MemWrite => MEMWr_EXE_MEM_out,
        MemRead => MEMRd_EXE_MEM_out,
        POP => POP_EXE_MEM_out,
        RET => RET_EXE_MEM_out,
        PUSH => PUSH_EXE_MEM_out,
        CALL => CALL_EXE_MEM_out,
        INT => INT_EXE_MEM_out,
        RTI => RTI_EXE_MEM_out,
        PC => PC_EXE_MEM_out,
        SP => SP,
        LDM => LDM_EXE_MEM_out,

        -- 
        FlagsAddress => (OTHERS => '0'),
        MemoryAddress => memory_address_memory_stage_in,
        MemoryDataIn => memory_data_EXE_MEM_out,
        Immediate => immediate_EXE_MEM_out,

        -- Outputs
        MemoryDataOut => data_memory_stage_out,
        memory_address_out => address_memory_stage_out
    );

    MEM_WB_Reg_inst : MEM_WB_Register PORT MAP(
        CLK => clk,
        RESET => rst,
        WRITE_EN => '1', -- TODO: Change later
        WB_IN => WB_EXE_MEM_out,
        WB_DATA_IN => data_memory_stage_out,
        WB_ADDR_IN => address_memory_stage_out,
        Rdst_IN => Rdst_EXE_MEM_out,

        MemToReg_IN => MemToReg_EXE_MEM_out,
        MemToReg_OUT => MemToReg_MEM_WB_out,

        -- Outputs
        WB_OUT => WB_MEM_WB_out,
        WB_DATA_OUT => memory_data_MEM_WB_out,
        WB_ADDR_OUT => memory_address_MEM_WB_out,
        Rdst_OUT => Rdst_MEM_WB_out
    );

    writeback_inst : writeback_stage PORT MAP(
        MemtoReg => MemToReg_MEM_WB_out,
        WB_data_in => memory_data_MEM_WB_out,
        WB_address => memory_address_MEM_WB_out,
        Rdst_in => Rdst_MEM_WB_out,

        -- Outputs
        WB_data_out => data_writeback_stage_out,
        Rdst_out => address_writeback_stage_out
    );

END ARCHITECTURE;