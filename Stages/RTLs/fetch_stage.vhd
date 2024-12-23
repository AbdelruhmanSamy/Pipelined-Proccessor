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
        is_INT : IN STD_LOGIC;
        is_RTI : IN STD_LOGIC;
        is_HLT : IN STD_LOGIC;
        is_JCond : IN STD_LOGIC;
        is_JMP : IN STD_LOGIC;
        is_CALL : IN STD_LOGIC;
        is_RET : IN STD_LOGIC;
        is_EmptySP : IN STD_LOGIC;
        is_InvMemAddress : IN STD_LOGIC;
        is_NOP : IN STD_LOGIC;
        address_to_jump : IN STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
        popped_address_to_jump : IN STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
        first_mem_address : IN STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
        fourth_mem_address : IN STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
        second_mem_address : IN STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
        instruction : OUT STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0)
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

    SIGNAL next_pc : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL pc_reg_out : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0) := (OTHERS => '0');
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

    SIGNAL sixth_instruction : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
    SIGNAL eigth_instruction : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);

BEGIN

    pc_handler_instance : pc_handler
    PORT MAP(
        INT => is_INT,
        RESET => reset,
        RTI => is_RTI,
        HLT => is_HLT,
        JCond => is_JCond,
        JMP => is_JMP,
        CALL => is_CALL,
        RET => is_RET,
        EmptySP => is_EmptySP,
        InvMemAddress => is_InvMemAddress,
        NOP => is_NOP,
        Selector => pc_handler_selector
    );

    pc_instance : general_register
    PORT MAP(
        data_in => next_pc,
        write_enable => pc_register_enable,
        clk => clk,
        reset => reset,
        data_out => pc_reg_out
    );

    current_pc <= pc_reg_out;

    pc_adder_instance : n_bit_adder
    PORT MAP(
        a => current_pc,
        b => adder_added_value,
        carry_in => adder_carry_in,
        sum => next_pc,
        carry_out => adder_carry_out
    );

    boomb_mux_in <= second_mem_address & fourth_mem_address & first_mem_address & popped_address_to_jump & address_to_jump & memory_mux_out & current_pc & next_pc;

    boomb_mux_instance : generic_mux
    PORT MAP(
        inputs => boomb_mux_in,
        sel => pc_handler_selector,
        outputs => boomb_mux_out
    );

    instruction_memory_instance : instruction_memory
    PORT MAP(
        Address => boomb_mux_out(11 DOWNTO 0),
        reset => reset,
        DataOut => fetched_instruction,
        Sixth_DataOut => sixth_instruction,
        Eigth_DataOut => eigth_instruction
    );

    memory_mux_in <= eigth_instruction & sixth_instruction;

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

END ARCHITECTURE fetch_stage_architecture;