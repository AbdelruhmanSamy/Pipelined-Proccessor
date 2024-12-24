LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY SP_Handler IS
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
END SP_Handler;

-- Value of SP is updated according to input signals on Rising edge of clk (new value is at rising edge) but data memory must read old value DM[SP]

ARCHITECTURE Behavioral OF SP_Handler IS
    SIGNAL SP : unsigned(15 DOWNTO 0) := to_unsigned(4095, 16); -- SP register initialized to 4095
    SIGNAL SP_NEXT : unsigned(15 DOWNTO 0); -- Next state of SP
BEGIN

    SP_OUT <= STD_LOGIC_VECTOR(SP);

    PROCESS (CLK, RESET)
    BEGIN
        IF RESET = '1' THEN

            SP <= to_unsigned(4095, 16);
        ELSIF rising_edge(CLK) THEN

            SP <= SP_NEXT;
        END IF;
    END PROCESS;

    PROCESS (SP, POP, RET, RTI, PUSH, CALL, INT)
    BEGIN
        -- Default: No change
        SP_NEXT <= SP;

        -- Decrement SP
        IF PUSH = '1' OR CALL = '1' OR INT = '1' THEN
            SP_NEXT <= SP - 1;
        END IF;

        -- Increment SP
        IF POP = '1' OR RET = '1' OR RTI = '1' THEN
            SP_NEXT <= SP + 1;
        END IF;
    END PROCESS;

END Behavioral;