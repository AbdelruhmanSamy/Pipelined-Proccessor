LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY decode_stage_tb IS
END ENTITY decode_stage_tb;

ARCHITECTURE behavior OF decode_stage_tb IS

    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT decode_stage IS
        GENERIC (
            REGISTER_SIZE : INTEGER := 16;
            REGISTER_NUMBER : INTEGER := 8
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            fetched_opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            fetched_instruction : IN STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
            reg_write : IN STD_LOGIC;
            write_back_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_back_data : IN STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
            input_for_input_port : IN STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
            is_input_port : IN STD_LOGIC_VECTOR(0 DOWNTO 0); -- Match the type here
            read_data_1 : OUT STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
            read_data_2 : OUT STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals to connect to the UUT
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL fetched_opcode : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fetched_instruction : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reg_write : STD_LOGIC := '0';
    SIGNAL write_back_address : STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
    SIGNAL write_back_data : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL input_for_input_port : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL is_input_port : STD_LOGIC_VECTOR(0 DOWNTO 0) := "0"; -- Match the type here
    SIGNAL read_data_1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL read_data_2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock generation process
    CONSTANT clk_period : TIME := 100 ps;
BEGIN

    clk_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            clk <= '0';
            WAIT FOR clk_period / 2;
            clk <= '1';
            WAIT FOR clk_period / 2;
        END LOOP;
    END PROCESS;

    -- Instantiate the Unit Under Test (UUT)
    uut : decode_stage
    PORT MAP(
        clk => clk,
        reset => reset,
        fetched_opcode => fetched_opcode,
        fetched_instruction => fetched_instruction,
        reg_write => reg_write,
        write_back_address => write_back_address,
        write_back_data => write_back_data,
        input_for_input_port => input_for_input_port,
        is_input_port => is_input_port, -- Pass the correct signal type
        read_data_1 => read_data_1,
        read_data_2 => read_data_2
    );

    -- Stimulus process
    stimulus_process : PROCESS
    BEGIN
        -- Apply reset
        reset <= '1';
        WAIT FOR clk_period;
        reset <= '0';

        -- Test Case 1: Test with some values for the input
        fetched_opcode <= "1010101"; -- Some opcode value
        fetched_instruction <= "0000000000000010"; -- Instruction with some address
        reg_write <= '1';
        write_back_address <= "010";
        write_back_data <= "0000000000001010"; -- Some data to write
        input_for_input_port <= "0000000000001011"; -- Some input data for the input port
        is_input_port <= "1"; -- Select input port for `read_data_1`

        WAIT FOR clk_period;

        -- Test Case 2: Switch to register file data
        is_input_port <= "0"; -- Select register file data for `read_data_1`
        fetched_instruction <= "0000000000000110"; -- Another instruction
        WAIT FOR clk_period;

        -- Test Case 3: Reset the system again
        reset <= '1';
        WAIT FOR clk_period;
        reset <= '0';

        -- Test Case 4: Test with different values for the input
        fetched_opcode <= "1110001"; -- Another opcode value
        fetched_instruction <= "0000000000001001"; -- Another instruction with address
        reg_write <= '1';
        write_back_address <= "001";
        write_back_data <= "0000000000001100"; -- Another data to write
        input_for_input_port <= "0000000000001111"; -- Another input data
        is_input_port <= "1"; -- Select input port for `read_data_1`

        WAIT FOR clk_period;

        -- End of simulation
        std.env.stop;
    END PROCESS;

END ARCHITECTURE behavior;