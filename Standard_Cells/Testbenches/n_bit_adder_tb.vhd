LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY n_bit_adder_tb IS
END ENTITY n_bit_adder_tb;

ARCHITECTURE behavior OF n_bit_adder_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT n_bit_adder
        GENERIC (
            n : INTEGER := 16
        );
        PORT (
            a, b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            carry_in : IN STD_LOGIC;
            carry_out : OUT STD_LOGIC;
            sum : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals to connect to UUT
    SIGNAL a, b : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL carry_in, carry_out : STD_LOGIC := '0';
    SIGNAL sum : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    -- Ipstantiate the Unit Under Test (UUT)
    uut : n_bit_adder
    GENERIC MAP(
        n => 16
    )
    PORT MAP(
        a => a,
        b => b,
        carry_in => carry_in,
        carry_out => carry_out,
        sum => sum
    );

    -- Test process
    PROCESS
    BEGIN
        -- Test 1: a = 0, b = 0, carry_in = 0
        a <= (OTHERS => '0');
        b <= (OTHERS => '0');
        carry_in <= '0';
        WAIT FOR 10 ps;
        ASSERT (sum = "0000000000000000" AND carry_out = '0') REPORT "Test 1 Failed" SEVERITY FAILURE;

        -- Test 2: a = 1, b = 0, carry_in = 0
        a <= "0000000000000001";
        b <= (OTHERS => '0');
        carry_in <= '0';
        WAIT FOR 10 ps;
        ASSERT (sum = "0000000000000001" AND carry_out = '0') REPORT "Test 2 Failed" SEVERITY FAILURE;

        -- Test 3: a = 1, b = 1, carry_in = 0
        a <= "0000000000000001";
        b <= "0000000000000001";
        carry_in <= '0';
        WAIT FOR 10 ps;
        ASSERT (sum = "0000000000000010" AND carry_out = '0') REPORT "Test 3 Failed" SEVERITY FAILURE;

        -- Test 4: a = 1, b = 1, carry_in = 1
        a <= "0000000000000001";
        b <= "0000000000000001";
        carry_in <= '1';
        WAIT FOR 10 ps;
        ASSERT (sum = "0000000000000011" AND carry_out = '0') REPORT "Test 4 Failed" SEVERITY FAILURE;

        -- Test 5: a = 1, b = 1, carry_in = 1 (with carry out)
        a <= "1111111111111111";
        b <= "1111111111111111";
        carry_in <= '1';
        WAIT FOR 10 ps;
        ASSERT (sum = "1111111111111111" AND carry_out = '1') REPORT "Test 5 Failed" SEVERITY FAILURE;

        -- Test 6: a = 0xFFFF, b = 0x0001, carry_in = 1 (testing carry)
        a <= "1111111111111111";
        b <= "0000000000000001";
        carry_in <= '1';
        WAIT FOR 10 ps;
        ASSERT (sum = "0000000000000001" AND carry_out = '1') REPORT "Test 6 Failed" SEVERITY FAILURE;

        -- Test 7: a = 0xAAAA, b = 0x5555, carry_in = 0
        a <= "1010101010101010";
        b <= "0101010101010101";
        carry_in <= '0';
        WAIT FOR 10 ps;
        ASSERT (sum = "1111111111111111" AND carry_out = '0') REPORT "Test 7 Failed" SEVERITY FAILURE;

        -- Test 8: a = 0x5555, b = 0x5555, carry_in = 1
        a <= "0101010101010101";
        b <= "0101010101010101";
        carry_in <= '1';
        WAIT FOR 10 ps;
        ASSERT (sum = "1010101010101011" AND carry_out = '0') REPORT "Test 8 Failed" SEVERITY FAILURE;

        -- End of simulation
        REPORT "All Tests Passed" SEVERITY NOTE;
        WAIT;
    END PROCESS;

END ARCHITECTURE behavior;