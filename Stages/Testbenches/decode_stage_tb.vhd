LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY decode_stage_tb IS
END ENTITY decode_stage_tb;

ARCHITECTURE behavior OF decode_stage_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT decode_stage
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

            -- input signals from control unit
            IN_PORT_IN : IN STD_LOGIC_VECTOR(0 DOWNTO 0);

            -- TODO: integrate JMP and CALL instructions
            -- JMP_IN : IN STD_LOGIC;
            -- CALL_IN : IN STD_LOGIC;

            -- Outputs
            read_data_1 : OUT STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
            read_data_2 : OUT STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0)

        );
    END COMPONENT;

    -- Signals for the testbench
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL fetched_instruction : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reg_write : STD_LOGIC := '0';
    SIGNAL write_back_address : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL write_back_data : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL input_for_input_port : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL is_input_port : STD_LOGIC_VECTOR(0 DOWNTO 0) := (OTHERS => '0');
    SIGNAL read_data_1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL read_data_2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut : decode_stage
    GENERIC MAP(
        REGISTER_SIZE => 16,
        REGISTER_NUMBER => 8
    )
    PORT MAP(
        clk => clk,
        reset => reset,
        fetched_instruction => fetched_instruction,
        reg_write => reg_write,
        write_back_address => write_back_address,
        write_back_data => write_back_data,
        input_port_data => input_for_input_port,
        IN_PORT_IN => is_input_port,
        read_data_1 => read_data_1,
        read_data_2 => read_data_2
    );

    -- Clock generation process
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Stimulus process
    stimulus_process : PROCESS
    BEGIN
        -- Reset the system
        reset <= '1';
        WAIT FOR clk_period * 2;
        reset <= '0';
        WAIT FOR clk_period * 2;

        -- Test Case 1: Write data to register file and verify output
        reg_write <= '1';
        write_back_address <= "001";
        write_back_data <= X"00FF";
        WAIT FOR clk_period;

        ASSERT read_data_1 = X"0000" AND read_data_2 = X"0000"
        REPORT "Test Case 1 Failed: Register write not reflected in read data."
        SEVERITY ERROR;

        -- Test Case 2: Read data from register file
        fetched_instruction <= X"0001";
        reg_write <= '0';
        WAIT FOR clk_period;

        ASSERT read_data_1 = X"00FF"
        REPORT "Test Case 2 Failed: Read data 1 does not match expected value."
        SEVERITY ERROR;

        -- Test Case 3: Test input port functionality
        input_for_input_port <= X"AAAA";
        is_input_port <= "1";
        WAIT FOR clk_period;

        ASSERT read_data_1 = X"AAAA"
        REPORT "Test Case 3 Failed: Input port data not reflected in read data 1."
        SEVERITY ERROR;

        -- Test Case 4: Test mux selection
        is_input_port <= "0";
        WAIT FOR clk_period;

        ASSERT read_data_1 = X"00FF"
        REPORT "Test Case 4 Failed: Mux did not select register file data."
        SEVERITY ERROR;

        -- Stop simulation
        std.env.stop;
    END PROCESS;

END ARCHITECTURE behavior;