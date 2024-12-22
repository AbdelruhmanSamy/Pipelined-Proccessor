LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_instruction_memory IS
END ENTITY tb_instruction_memory;

ARCHITECTURE behavior OF tb_instruction_memory IS

    -- Component declaration of the unit under test (UUT)
    COMPONENT instruction_memory
        PORT (
            reset : IN STD_LOGIC;
            Address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            DataOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -- Testbench signals
    SIGNAL tb_reset : STD_LOGIC := '0';
    SIGNAL tb_Address : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tb_DataOut : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut : instruction_memory
    PORT MAP(
        reset => tb_reset,
        Address => tb_Address,
        DataOut => tb_DataOut
    );

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- Initialize signals
        tb_Address <= (OTHERS => '0'); -- Start at address 0
        tb_reset <= '1'; -- Reset memory and initialize
        WAIT FOR 100 ps; -- Wait for the memory initialization

        -- Test memory initialization
        tb_reset <= '0'; -- Release reset

        -- Test for Address 2 (expected: 0010010000000111)
        tb_Address <= "000000000010"; -- Address 2
        WAIT FOR 100 ps;
        ASSERT tb_DataOut = "0010010000000111" REPORT "Error at Address 2: DataOut = " SEVERITY ERROR;

        -- Test for Address 3 (expected: 0010011000011111)
        tb_Address <= "000000000011"; -- Address 3
        WAIT FOR 100 ps;
        ASSERT tb_DataOut = "0010011000011111" REPORT "Error at Address 3: DataOut = " SEVERITY ERROR;

        -- Test for Address 4 (expected: 0010011001111101)
        tb_Address <= "000000000100"; -- Address 4
        WAIT FOR 100 ps;
        ASSERT tb_DataOut = "0010011001111101" REPORT "Error at Address 4: DataOut = " SEVERITY ERROR;

        -- Test for Address 5 (expected: 0010001001110101)
        tb_Address <= "000000000101"; -- Address 5
        WAIT FOR 100 ps;
        ASSERT tb_DataOut = "0010001001110101" REPORT "Error at Address 5: DataOut = " SEVERITY ERROR;

        -- Test for Address 6 (expected: 0010001001110101)
        tb_Address <= "000000000110"; -- Address 6
        WAIT FOR 100 ps;
        ASSERT tb_DataOut = "0010001001110101" REPORT "Error at Address 6: DataOut = " SEVERITY ERROR;

        -- Test resetting memory again
        tb_reset <= '1'; -- Assert reset to reinitialize memory
        tb_Address <= "000000000101"; -- Address 5
        WAIT FOR 100 ps;
        ASSERT tb_DataOut = "0000000000000001" REPORT "Error at Reset: DataOut = " SEVERITY ERROR;
        tb_reset <= '0'; -- Release reset
        -- Test for Address 2 (expected: 0010010000000111)
        tb_Address <= "000000000010"; -- Address 2
        WAIT FOR 100 ps;
        ASSERT tb_DataOut = "0010010000000111" REPORT "Error at Address 2 after releasing reset: DataOut = " SEVERITY ERROR;
        -- Finish simulation after reading a few addresses
        WAIT FOR 500 ps;
        REPORT "Test finished";

        -- End the simulation
        ASSERT FALSE REPORT "End of simulation" SEVERITY NOTE;
        WAIT; -- Wait indefinitely
    END PROCESS stim_proc;

END ARCHITECTURE behavior;