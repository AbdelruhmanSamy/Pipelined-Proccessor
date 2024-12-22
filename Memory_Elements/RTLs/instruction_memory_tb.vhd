LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY InstructionMem_tb IS
END ENTITY InstructionMem_tb;

ARCHITECTURE behavior OF InstructionMem_tb IS

    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT InstructionMem
        PORT (
            PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            ResetSignal : IN STD_LOGIC;
            InstructionOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for the UUT
    SIGNAL PC : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ResetSignal : STD_LOGIC := '0';
    SIGNAL InstructionOut : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    -- Instantiate the UUT
    UUT : InstructionMem
    PORT MAP(
        PC => PC,
        ResetSignal => ResetSignal,
        InstructionOut => InstructionOut
    );

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- Test 1: Reset the memory and load instructions
        -- Apply reset signal
        ResetSignal <= '1';
        WAIT FOR 20 ns; -- Wait for the reset to propagate
        ResetSignal <= '0';
        WAIT FOR 20 ns;

        -- Test 2: Check the instruction output for different PC values
        -- Simulate PC changes
        PC <= "0000000000000001"; -- Address 1
        WAIT FOR 20 ns;
        ASSERT (InstructionOut = "0000000000000000") -- Expected instruction from file (example)
        REPORT "Test 2 Failed" SEVERITY ERROR;

        PC <= "0000000000000010"; -- Address 2
        WAIT FOR 20 ns;
        ASSERT (InstructionOut = "0000000000000001") -- Expected instruction from file (example)
        REPORT "Test 3 Failed" SEVERITY ERROR;

        -- Add more tests for different PC values if needed

        -- Test 3: Reset again and verify memory contents
        ResetSignal <= '1';
        WAIT FOR 20 ns;
        ResetSignal <= '0';
        WAIT FOR 20 ns;

        -- Simulate another PC access after reset
        PC <= X"0003"; -- Address 3
        WAIT FOR 20 ns;
        ASSERT (InstructionOut = "0000000000000010") -- Expected instruction from file (example)
        REPORT "Test 4 Failed" SEVERITY ERROR;

        -- End simulation
        WAIT;
    END PROCESS;

END ARCHITECTURE behavior;