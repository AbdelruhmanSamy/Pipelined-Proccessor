LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY fetch_stage IS
    GENERIC (
        DATA_SIZE : INTEGER := 16
    );
    PORT (
        clk, reset, pc_register_enable : IN STD_LOGIC;
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
            DataOut : OUT STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0)
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

    SIGNAL next_pc : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL pc_reg_out : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL current_pc : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);

    SIGNAL adder_carry_out : STD_LOGIC;
    SIGNAL adder_carry_in : STD_LOGIC := '0';
    SIGNAL adder_added_value : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0) := "0000000000000001";
    SIGNAL fetched_instruction : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
BEGIN

    -- PC Register Instance
    pc_instance : general_register
    PORT MAP(
        data_in => next_pc,
        write_enable => pc_register_enable,
        clk => clk,
        reset => reset,
        data_out => pc_reg_out
    );

    current_pc <= pc_reg_out;

    -- PC Incrementer
    pc_adder_instance : n_bit_adder
    PORT MAP(
        a => current_pc,
        b => adder_added_value,
        carry_in => adder_carry_in,
        sum => next_pc,
        carry_out => adder_carry_out
    );

    -- Instruction Memory Instance
    instruction_memory_instance : instruction_memory
    PORT MAP(
        Address => current_pc(11 DOWNTO 0),
        reset => reset,
        DataOut => fetched_instruction
    );

    -- Assign fetched instruction to output
    instruction <= fetched_instruction;

END ARCHITECTURE fetch_stage_architecture;