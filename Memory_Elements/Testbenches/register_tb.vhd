LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY general_register_tb IS
END general_register_tb;

ARCHITECTURE Behavioral OF general_register_tb IS
    -- Constants for testing
    CONSTANT REGISTER_SIZE : INTEGER := 16;
    CONSTANT RESET_VALUE : INTEGER := 0;

    -- Testbench signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL write_enable : STD_LOGIC := '0';
    SIGNAL data_in : STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_out : STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);

    -- Clock period constant
    CONSTANT clk_period : TIME := 100 ps;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : ENTITY work.general_register
        GENERIC MAP(
            REGISTER_SIZE => REGISTER_SIZE,
            RESET_VALUE => RESET_VALUE
        )
        PORT MAP(
            clk => clk,
            reset => reset,
            write_enable => write_enable,
            data_in => data_in,
            data_out => data_out
        );

    -- Clock generation process
    clk_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            clk <= '0';
            WAIT FOR clk_period / 2;
            clk <= '1';
            WAIT FOR clk_period / 2;
        END LOOP;
    END PROCESS;

    -- Stimulus process
    stimulus_process : PROCESS
    BEGIN
        -- Test 1: Reset behavior
        reset <= '1';
        WAIT FOR clk_period;
        ASSERT data_out = STD_LOGIC_VECTOR(to_unsigned(RESET_VALUE, REGISTER_SIZE))
        REPORT "Test 1 failed: Reset behavior incorrect";
        reset <= '0';

        -- Test 2: Write behavior
        write_enable <= '1';
        data_in <= X"1234";
        WAIT FOR clk_period;
        ASSERT data_out = X"1234"
        REPORT "Test 2 failed: Write behavior incorrect";

        -- Test 3: No write when write_enable = '0'
        write_enable <= '0';
        data_in <= X"5678";
        WAIT FOR clk_period;
        ASSERT data_out = X"1234"
        REPORT "Test 3 failed: Write enable not functioning correctly";

        -- Test 4: Reset overrides write_enable
        reset <= '1';
        write_enable <= '1';
        data_in <= X"ABCD";
        WAIT FOR clk_period;
        ASSERT data_out = STD_LOGIC_VECTOR(to_unsigned(RESET_VALUE, REGISTER_SIZE))
        REPORT "Test 4 failed: Reset did not override write_enable";
        reset <= '0';

        -- Test 5: Multiple writes
        write_enable <= '1';
        data_in <= X"1111";
        WAIT FOR clk_period;
        ASSERT data_out = X"1111"
        REPORT "Test 5 failed: Write behavior incorrect on first write";
        data_in <= X"2222";
        WAIT FOR clk_period;
        ASSERT data_out = X"2222"
        REPORT "Test 5 failed: Write behavior incorrect on second write";

        -- End simulation
        std.env.stop;
    END PROCESS;

END Behavioral;