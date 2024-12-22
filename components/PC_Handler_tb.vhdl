LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY PC_Handler_tb IS
END PC_Handler_tb;

ARCHITECTURE Behavioral OF PC_Handler_tb IS
    COMPONENT PC_Handler
        PORT (
            NOP : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            INT : IN STD_LOGIC;
            RTI : IN STD_LOGIC;
            JMP : IN STD_LOGIC;
            RET : IN STD_LOGIC;
            InvMemAddress : IN STD_LOGIC;
            EmptySP : IN STD_LOGIC;
            HLT : IN STD_LOGIC;
            CALL : IN STD_LOGIC;
            JCond : IN STD_LOGIC;
            Selector : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL NOP : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL INT : STD_LOGIC := '0';
    SIGNAL RTI : STD_LOGIC := '0';
    SIGNAL JMP : STD_LOGIC := '0';
    SIGNAL RET : STD_LOGIC := '0';
    SIGNAL InvMemAddress : STD_LOGIC := '0';
    SIGNAL EmptySP : STD_LOGIC := '0';
    SIGNAL HLT : STD_LOGIC := '0';
    SIGNAL CALL : STD_LOGIC := '0';
    SIGNAL JCond : STD_LOGIC := '0';
    SIGNAL Selector : STD_LOGIC_VECTOR (2 DOWNTO 0);

BEGIN
    uut : PC_Handler
    PORT MAP(
        NOP => NOP,
        reset => reset,
        INT => INT,
        RTI => RTI,
        JMP => JMP,
        RET => RET,
        InvMemAddress => InvMemAddress,
        EmptySP => EmptySP,
        HLT => HLT,
        CALL => CALL,
        JCond => JCond,
        Selector => Selector
    );

    PROCESS
    BEGIN
        -- Test Case 1: JMP active
        JMP <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector = "000" REPORT "Test Case 1 Failed: Expected 000" SEVERITY error;
        JMP <= '0';

        -- Test Case 2: HLT active
        HLT <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector = "001" REPORT "Test Case 2 Failed: Expected 001" SEVERITY error;
        HLT <= '0';

        -- Test Case 3: reset active
        reset <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector = "010" REPORT "Test Case 3 Failed: Expected 010" SEVERITY error;
        reset <= '0';

        -- Test Case 4: InvMemAddress active
        InvMemAddress <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector = "011" REPORT "Test Case 4 Failed: Expected 011" SEVERITY error;
        InvMemAddress <= '0';

        -- Test Case 5: EmptySP active
        EmptySP <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector = "100" REPORT "Test Case 5 Failed: Expected 100" SEVERITY error;
        EmptySP <= '0';

        -- Test Case 6: RET active
        RET <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector = "101" REPORT "Test Case 6 Failed: Expected 101" SEVERITY error;
        RET <= '0';

        -- Test Case 7: RTI active
        RTI <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector = "101" REPORT "Test Case 7 Failed: Expected 101" SEVERITY error;
        RTI <= '0';

        -- Test Case 8: INT active
        INT <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector = "110" REPORT "Test Case 8 Failed: Expected 110" SEVERITY error;
        INT <= '0';

        -- Test Case 9: NOP active
        NOP <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector = "111" REPORT "Test Case 9 Failed: Expected 111" SEVERITY error;
        NOP <= '0';

        JCond <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector = "000" REPORT "Test Case 10 Failed: Expected 000" SEVERITY error;
        JCond <= '0';

        CALL <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector = "000" REPORT "Test Case 11 Failed: Expected 000" SEVERITY error;
        CALL <= '0';

        -- Default Case: No signal active
        WAIT FOR 10 ns;
        ASSERT Selector = "111" REPORT "Default Case Failed: Expected 111" SEVERITY error;

        -- End simulation
        WAIT;
    END PROCESS;

END Behavioral;