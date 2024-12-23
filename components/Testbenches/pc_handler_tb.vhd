LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY pc_handler_tb IS
END ENTITY pc_handler_tb;

ARCHITECTURE Behavioral OF pc_handler_tb IS
    -- Component declaration for pc_handler
    COMPONENT pc_handler
        PORT (
            INT : IN STD_LOGIC;
            RESET : IN STD_LOGIC;
            RTI : IN STD_LOGIC;
            HLT : IN STD_LOGIC;
            JCond : IN STD_LOGIC;
            JMP : IN STD_LOGIC;
            CALL : IN STD_LOGIC;
            RET : IN STD_LOGIC;
            EmptySP : IN STD_LOGIC;
            InvMemAddress : IN STD_LOGIC;
            NOP : IN STD_LOGIC;
            Selector : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for connecting to the pc_handler
    SIGNAL INT_tb : STD_LOGIC := '0';
    SIGNAL RESET_tb : STD_LOGIC := '0';
    SIGNAL RTI_tb : STD_LOGIC := '0';
    SIGNAL HLT_tb : STD_LOGIC := '0';
    SIGNAL JCond_tb : STD_LOGIC := '0';
    SIGNAL JMP_tb : STD_LOGIC := '0';
    SIGNAL CALL_tb : STD_LOGIC := '0';
    SIGNAL RET_tb : STD_LOGIC := '0';
    SIGNAL EmptySP_tb : STD_LOGIC := '0';
    SIGNAL InvMemAddress_tb : STD_LOGIC := '0';
    SIGNAL NOP_tb : STD_LOGIC := '0';
    SIGNAL Selector_tb : STD_LOGIC_VECTOR (2 DOWNTO 0);

BEGIN
    -- Instantiate the pc_handler
    UUT : pc_handler
    PORT MAP(
        INT => INT_tb,
        RESET => RESET_tb,
        RTI => RTI_tb,
        HLT => HLT_tb,
        JCond => JCond_tb,
        JMP => JMP_tb,
        CALL => CALL_tb,
        RET => RET_tb,
        EmptySP => EmptySP_tb,
        InvMemAddress => InvMemAddress_tb,
        NOP => NOP_tb,
        Selector => Selector_tb
    );

    -- Stimulus process
    PROCESS
    BEGIN
        -- Test NOP
        NOP_tb <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector_tb = "000" REPORT "NOP failed" SEVERITY ERROR;
        NOP_tb <= '0';

        -- Test JMP
        JMP_tb <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector_tb = "011" REPORT "JMP failed" SEVERITY ERROR;
        JMP_tb <= '0';

        -- Test CALL
        CALL_tb <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector_tb = "011" REPORT "CALL failed" SEVERITY ERROR;
        CALL_tb <= '0';

        -- Test JCond
        JCond_tb <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector_tb = "011" REPORT "JCond failed" SEVERITY ERROR;
        JCond_tb <= '0';

        -- Test HLT
        HLT_tb <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector_tb = "001" REPORT "HLT failed" SEVERITY ERROR;
        HLT_tb <= '0';

        -- Test RESET
        RESET_tb <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector_tb = "101" REPORT "RESET failed" SEVERITY ERROR;
        RESET_tb <= '0';

        -- Test InvMemAddress
        InvMemAddress_tb <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector_tb = "110" REPORT "InvMemAddress failed" SEVERITY ERROR;
        InvMemAddress_tb <= '0';

        -- Test EmptySP
        EmptySP_tb <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector_tb = "111" REPORT "EmptySP failed" SEVERITY ERROR;
        EmptySP_tb <= '0';

        -- Test RET
        RET_tb <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector_tb = "100" REPORT "RET failed" SEVERITY ERROR;
        RET_tb <= '0';

        -- Test RTI
        RTI_tb <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector_tb = "100" REPORT "RTI failed" SEVERITY ERROR;
        RTI_tb <= '0';

        -- Test INT
        INT_tb <= '1';
        WAIT FOR 10 ns;
        ASSERT Selector_tb = "010" REPORT "INT failed" SEVERITY ERROR;
        INT_tb <= '0';

        -- Default case
        WAIT FOR 10 ns;
        ASSERT Selector_tb = "000" REPORT "Default case failed" SEVERITY ERROR;

        WAIT; -- Stop simulation
    END PROCESS;
END Behavioral;