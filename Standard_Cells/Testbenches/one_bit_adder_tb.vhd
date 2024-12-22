LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY one_bit_adder_tb IS
END ENTITY one_bit_adder_tb;

ARCHITECTURE behavior OF one_bit_adder_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT one_bit_adder
        PORT (
            a, b, carry_in : IN STD_LOGIC;
            sum, carry_out : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Signals to connect to UUT
    SIGNAL a, b, carry_in : STD_LOGIC := '0';
    SIGNAL sum, carry_out : STD_LOGIC;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut : one_bit_adder
    PORT MAP(
        a => a,
        b => b,
        carry_in => carry_in,
        sum => sum,
        carry_out => carry_out
    );

    -- Test process
    PROCESS
    BEGIN
        -- Test 1: a = 0, b = 0, carry_in = 0
        a <= '0';
        b <= '0';
        carry_in <= '0';
        WAIT FOR 10 ns; -- Wait for 10 ns
        ASSERT (sum = '0' AND carry_out = '0') REPORT "Test 1 Failed" SEVERITY FAILURE;

        -- Test 2: a = 0, b = 0, carry_in = 1
        a <= '0';
        b <= '0';
        carry_in <= '1';
        WAIT FOR 10 ns; -- Wait for 10 ns
        ASSERT (sum = '1' AND carry_out = '0') REPORT "Test 2 Failed" SEVERITY FAILURE;

        -- Test 3: a = 0, b = 1, carry_in = 0
        a <= '0';
        b <= '1';
        carry_in <= '0';
        WAIT FOR 10 ns; -- Wait for 10 ns
        ASSERT (sum = '1' AND carry_out = '0') REPORT "Test 3 Failed" SEVERITY FAILURE;

        -- Test 4: a = 1, b = 0, carry_in = 0
        a <= '1';
        b <= '0';
        carry_in <= '0';
        WAIT FOR 10 ns; -- Wait for 10 ns
        ASSERT (sum = '1' AND carry_out = '0') REPORT "Test 4 Failed" SEVERITY FAILURE;

        -- Test 5: a = 1, b = 1, carry_in = 0
        a <= '1';
        b <= '1';
        carry_in <= '0';
        WAIT FOR 10 ns; -- Wait for 10 ns
        ASSERT (sum = '0' AND carry_out = '1') REPORT "Test 5 Failed" SEVERITY FAILURE;

        -- Test 6: a = 1, b = 1, carry_in = 1
        a <= '1';
        b <= '1';
        carry_in <= '1';
        WAIT FOR 10 ns; -- Wait for 10 ns
        ASSERT (sum = '1' AND carry_out = '1') REPORT "Test 6 Failed" SEVERITY FAILURE;

        -- Test 7: a = 0, b = 1, carry_in = 1
        a <= '0';
        b <= '1';
        carry_in <= '1';
        WAIT FOR 10 ns; -- Wait for 10 ns
        ASSERT (sum = '0' AND carry_out = '1') REPORT "Test 7 Failed" SEVERITY FAILURE;

        -- Test 8: a = 1, b = 0, carry_in = 1
        a <= '1';
        b <= '0';
        carry_in <= '1';
        WAIT FOR 10 ns; -- Wait for 10 ns
        ASSERT (sum = '0' AND carry_out = '1') REPORT "Test 8 Failed" SEVERITY FAILURE;

        -- End of simulation
        REPORT "All Tests Passed" SEVERITY NOTE;
        WAIT;
    END PROCESS;

END ARCHITECTURE behavior;