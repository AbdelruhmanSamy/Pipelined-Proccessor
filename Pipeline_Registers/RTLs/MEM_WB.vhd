LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MEM_WB_Register IS
    PORT (
        CLK : IN STD_LOGIC;
        RESET : IN STD_LOGIC;
        WRITE_EN : IN STD_LOGIC;
        WB_IN : IN STD_LOGIC;
        WB_DATA_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        WB_ADDR_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Rdst_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WB_OUT : OUT STD_LOGIC;
        WB_DATA_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        WB_ADDR_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Rdst_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END MEM_WB_Register;

ARCHITECTURE Behavioral OF MEM_WB_Register IS

    SIGNAL WB_REG : STD_LOGIC;
    SIGNAL WB_DATA_REG : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL WB_ADDR_REG : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Rdst_REG : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN

    WB_OUT <= WB_REG;
    WB_DATA_OUT <= WB_DATA_REG;
    WB_ADDR_OUT <= WB_ADDR_REG;
    Rdst_OUT <= Rdst_REG;

    PROCESS (CLK, RESET)
    BEGIN
        IF RESET = '1' THEN

            WB_REG <= '0';
            WB_DATA_REG <= (OTHERS => '0');
            WB_ADDR_REG <= (OTHERS => '0');
            Rdst_REG <= (OTHERS => '0');
        ELSIF rising_edge(CLK) THEN
            IF WRITE_EN = '1' THEN
                WB_REG <= WB_IN;
                WB_DATA_REG <= WB_DATA_IN;
                WB_ADDR_REG <= WB_ADDR_IN;
                Rdst_REG <= Rdst_IN;
            END IF;
        END IF;
    END PROCESS;

END Behavioral;