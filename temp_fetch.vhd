LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY fetch_stage IS
    GENERIC (
        DATA_SIZE : INTEGER := 16
    );
    PORT (
        clk : IN STD_LOGIC;
        pc_register_enable : IN STD_LOGIC;
        index : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        reset : IN STD_LOGIC;
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

        -- Outputs
        instruction : OUT STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
        PC_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );
END ENTITY fetch_stage;

ARCHITECTURE fetch_stage_architecture OF fetch_stage IS

    COMPONENT general_register IS
        GENERIC (
            REGISTER_SIZE : INTEGER := DATA_SIZE;
            RESET_VALUE : INTEGER := 0
        );
        PORT (
            write_enable, clk, reset : IN STD_LOGIC;
            data_in : IN STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT instruction_memory IS
        PORT (
            reset : IN STD_LOGIC;
            Address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            DataOut : OUT STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
            Sixth_DataOut : OUT STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
            Eigth_DataOut : OUT STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT n_bit_adder IS
        GENERIC (
            n : INTEGER := DATA_SIZE
        );
        PORT (
            a, b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            carry_in : IN STD_LOGIC;
            carry_out : OUT STD_LOGIC;
            sum : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT generic_mux IS
        GENERIC (
            M : INTEGER := DATA_SIZE;
            N : INTEGER := 8;
            K : INTEGER := 3
        );
        PORT (
            inputs : IN STD_LOGIC_VECTOR(M * N - 1 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR(K - 1 DOWNTO 0);
            outputs : OUT STD_LOGIC_VECTOR(M - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT pc_handler IS
        PORT (
            INT : IN STD_LOGIC;
            RESET : IN STD_LOGIC;
            RTI : IN STD_LOGIC;
            HLT : IN STD_LOGIC;
            JCond : IN STD_LOGIC;
            JMP : IN STD_LOGIC;
            CALL : IN STD_LOGIC;
            RET : IN STD_LOGIC;
            EmptySP : IN STD_LOGIC;
            InvMemAddress : IN STD_LOGIC;
            NOP : IN STD_LOGIC;
            Selector : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL next_pc : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
    SIGNAL pc_reg_out : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
    SIGNAL current_pc : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);

    SIGNAL adder_carry_out : STD_LOGIC;
    SIGNAL adder_carry_in : STD_LOGIC := '0';
    SIGNAL adder_added_value : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0) := "0000000000000001";
    SIGNAL fetched_instruction : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);

    SIGNAL boomb_mux_out : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
    SIGNAL boomb_mux_in : STD_LOGIC_VECTOR(8 * DATA_SIZE - 1 DOWNTO 0);

    SIGNAL memory_mux_out : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
    SIGNAL memory_mux_in : STD_LOGIC_VECTOR(2 * DATA_SIZE - 1 DOWNTO 0);

    SIGNAL pc_handler_selector : STD_LOGIC_VECTOR(2 DOWNTO 0);

    SIGNAL IM_6 : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
    SIGNAL IM_8 : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
BEGIN

    PROCESS (reset)
    BEGIN
        IF reset = '1' THEN
            next_pc <= (OTHERS => '0');
            pc_reg_out <= (OTHERS => '0');
            current_pc <= (OTHERS => '0');
            fetched_instruction <= (OTHERS => '0');
            boomb_mux_out <= (OTHERS => '0');
            boomb_mux_in <= (OTHERS => '0');
            memory_mux_out <= (OTHERS => '0');
            memory_mux_in <= (OTHERS => '0');
            pc_handler_selector <= (OTHERS => '0');
            IM_6 <= (OTHERS => '0');
            IM_8 <= (OTHERS => '0');
        END IF;
    END PROCESS;

    pc_handler_instance : pc_handler
    PORT MAP(
        INT => INT,
        RESET => reset,
        RTI => RTI,
        HLT => HLT,
        JCond => JCond,
        JMP => JMP,
        CALL => CALL,
        RET => RET,
        EmptySP => empty_SP,
        InvMemAddress => invalid_mem_address,
        NOP => NOP,
        Selector => pc_handler_selector
    );

    boomb_mux_in <= IM_2 & IM_4 & IM_0 & DM_SP & Rsrc1 & memory_mux_out & current_pc & next_pc;

    boomb_mux_instance : generic_mux
    PORT MAP(
        inputs => boomb_mux_in,
        sel => pc_handler_selector,
        outputs => boomb_mux_out
    );

    pc_instance : general_register
    PORT MAP(
        data_in => boomb_mux_out,
        write_enable => pc_register_enable,
        clk => clk,
        reset => reset,
        data_out => current_pc
    );

    pc_adder_instance : n_bit_adder
    PORT MAP(
        a => current_pc,
        b => adder_added_value,
        carry_in => adder_carry_in,
        sum => next_pc,
        carry_out => adder_carry_out
    );

    instruction_memory_instance : instruction_memory
    PORT MAP(
        Address => current_pc(11 DOWNTO 0),
        reset => reset,
        DataOut => fetched_instruction,
        Sixth_DataOut => IM_6,
        Eigth_DataOut => IM_8
    );

    memory_mux_in <= IM_8 & IM_6;

    instruction_mem_mux_instance : generic_mux
    GENERIC MAP(
        M => DATA_SIZE,
        N => 2,
        K => 1
    )
    PORT MAP(
        inputs => memory_mux_in,
        sel => index,
        outputs => memory_mux_out
    );

    instruction <= fetched_instruction;
    PC_OUT <= current_pc;

END ARCHITECTURE fetch_stage_architecture;