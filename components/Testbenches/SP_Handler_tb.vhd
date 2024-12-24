LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY SP_Handler_TB IS

END SP_Handler_TB;

ARCHITECTURE Behavioral OF SP_Handler_TB IS

    COMPONENT SP_Handler
        PORT (
            CLK : IN STD_LOGIC;
            RESET : IN STD_LOGIC;
            POP : IN STD_LOGIC;
            RET : IN STD_LOGIC;
            RTI : IN STD_LOGIC;
            PUSH : IN STD_LOGIC;
            CALL : IN STD_LOGIC;
            INT : IN STD_LOGIC;
            SP_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL CLK : STD_LOGIC := '0';
    SIGNAL RESET : STD_LOGIC := '0';
    SIGNAL POP : STD_LOGIC := '0';
    SIGNAL RET : STD_LOGIC := '0';
    SIGNAL RTI : STD_LOGIC := '0';
    SIGNAL PUSH : STD_LOGIC := '0';
    SIGNAL CALL : STD_LOGIC := '0';
    SIGNAL INT : STD_LOGIC := '0';
    SIGNAL SP_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);

    CONSTANT CLK_PERIOD : TIME := 10 ns;

BEGIN

    UUT : SP_Handler
    PORT MAP(
        CLK => CLK,
        RESET => RESET,
        POP => POP,
        RET => RET,
        RTI => RTI,
        PUSH => PUSH,
        CALL => CALL,
        INT => INT,
        SP_OUT => SP_OUT
    );

    CLK_PROCESS : PROCESS
    BEGIN
        WHILE true LOOP
            CLK <= '0';
            WAIT FOR CLK_PERIOD / 2;
            CLK <= '1';
            WAIT FOR CLK_PERIOD / 2;
        END LOOP;
    END PROCESS;

    STIMULUS_PROCESS : PROCESS
    BEGIN
        RESET <= '1';
        WAIT FOR CLK_PERIOD;
        RESET <= '0';

        -- Case 1: PUSH operation
        PUSH <= '1';
        WAIT FOR CLK_PERIOD;
        PUSH <= '0';
        ASSERT SP_OUT = STD_LOGIC_VECTOR(to_unsigned(4094, 16))
        REPORT "PUSH failed" SEVERITY error;

        -- Case 2: CALL operation
        CALL <= '1';
        WAIT FOR CLK_PERIOD;
        CALL <= '0';
        ASSERT SP_OUT = STD_LOGIC_VECTOR(to_unsigned(4093, 16))
        REPORT "CALL failed" SEVERITY error;

        -- Case 3: INT operation
        INT <= '1';
        WAIT FOR CLK_PERIOD;
        INT <= '0';
        ASSERT SP_OUT = STD_LOGIC_VECTOR(to_unsigned(4092, 16))
        REPORT "INT failed" SEVERITY error;

        -- Case 4: POP operation
        POP <= '1';
        WAIT FOR CLK_PERIOD;
        POP <= '0';
        ASSERT SP_OUT = STD_LOGIC_VECTOR(to_unsigned(4093, 16))
        REPORT "POP failed" SEVERITY error;

        -- Case 5: RET operation
        RET <= '1';
        WAIT FOR CLK_PERIOD;
        RET <= '0';
        ASSERT SP_OUT = STD_LOGIC_VECTOR(to_unsigned(4094, 16))
        REPORT "RET failed" SEVERITY error;

        -- Case 6: RTI operation
        RTI <= '1';
        WAIT FOR CLK_PERIOD;
        RTI <= '0';
        ASSERT SP_OUT = STD_LOGIC_VECTOR(to_unsigned(4095, 16))
        REPORT "RTI failed" SEVERITY error;
        -- Case 7: Default operation

        WAIT FOR CLK_PERIOD;
        ASSERT SP_OUT = STD_LOGIC_VECTOR(to_unsigned(4095, 16))
        REPORT "Default failed" SEVERITY error;

        WAIT;
    END PROCESS;

END Behavioral;