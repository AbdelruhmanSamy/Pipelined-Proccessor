LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY general_register_file_tb IS
END general_register_file_tb;

ARCHITECTURE Behavioral OF general_register_file_tb IS
    -- Constants for testing
    CONSTANT REGISTER_SIZE : INTEGER := 16; -- Updated to 16
    CONSTANT REGISTER_NUMBER : INTEGER := 8;

    -- Testbench signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL write_enable : STD_LOGIC := '0';
    SIGNAL read_address1, read_address2, write_address : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL write_data : STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL read_data1, read_data2 : STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0) := (OTHERS => '0');

    -- Clock period constant
    CONSTANT clk_period : TIME := 100 ps;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : ENTITY work.general_register_file
        GENERIC MAP(
            REGISTER_SIZE => REGISTER_SIZE,
            REGISTER_NUMBER => REGISTER_NUMBER
        )
        PORT MAP(
            clk => clk,
            reset => reset,
            write_enable => write_enable,
            read_address1 => read_address1,
            read_address2 => read_address2,
            write_address => write_address,
            write_data => write_data,
            read_data1 => read_data1,
            read_data2 => read_data2
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
        -- Test 1: Reset all registers
        reset <= '1';
        WAIT FOR clk_period;
        WAIT FOR clk_period/2;
        reset <= '0';
        WAIT FOR clk_period;
        -- Check if all registers are reset to zero
        FOR i IN 0 TO REGISTER_NUMBER - 1 LOOP
            read_address1 <= STD_LOGIC_VECTOR(to_unsigned(i, 3)); -- Read each register
            WAIT FOR clk_period;
            ASSERT read_data1 = "0000000000000000"
            REPORT "Test 1 failed: Reset did not initialize register " & INTEGER'image(i) & " to zero" SEVERITY ERROR;
        END LOOP;

        -- Test 2: Write data to a register
        write_enable <= '1';
        write_address <= "000"; -- Write to register 0
        write_data <= X"AAAA"; -- Data to write (16 bits)
        WAIT FOR clk_period;
        write_enable <= '0'; -- Disable write
        read_address1 <= "000"; -- Read from register 0
        WAIT FOR clk_period;
        ASSERT read_data1 = X"AAAA"
        REPORT "Test 2 failed: Write operation did not update register correctly" SEVERITY ERROR;

        -- Test 3: Read data from registers
        write_enable <= '0';
        read_address1 <= "000"; -- Read from register 0
        read_address2 <= "001"; -- Read from register 1 (should be 0)
        WAIT FOR clk_period;
        ASSERT read_data1 = X"AAAA"
        REPORT "Test 3 failed: Read operation from register 0 incorrect" SEVERITY ERROR;
        ASSERT read_data2 = X"0000"
        REPORT "Test 3 failed: Read operation from register 1 incorrect" SEVERITY ERROR;

        -- Test 4: Overwrite data in a register
        write_enable <= '1';
        write_address <= "000"; -- Overwrite register 0
        write_data <= X"BBBB"; -- New data
        WAIT FOR clk_period;
        write_enable <= '0'; -- Disable write
        read_address1 <= "000"; -- Read from register 0
        WAIT FOR clk_period;
        ASSERT read_data1 = X"BBBB"
        REPORT "Test 4 failed: Overwrite operation did not update register correctly" SEVERITY ERROR;

        -- Test 5: Write to and read from multiple registers
        write_address <= "001"; -- Write to register 1
        write_data <= X"CCCC"; -- Data to write
        WAIT FOR clk_period;
        write_enable <= '0'; -- Disable write
        read_address1 <= "000"; -- Read from register 0
        read_address2 <= "001"; -- Read from register 1
        WAIT FOR clk_period;
        ASSERT read_data1 = X"BBBB"
        REPORT "Test 5 failed: Read operation from register 0 incorrect after overwrite" SEVERITY ERROR;
        ASSERT read_data2 = X"CCCC"
        REPORT "Test 5 failed: Read operation from register 1 incorrect after write" SEVERITY ERROR;

        -- End simulation
        std.env.stop;
    END PROCESS;

END Behavioral;