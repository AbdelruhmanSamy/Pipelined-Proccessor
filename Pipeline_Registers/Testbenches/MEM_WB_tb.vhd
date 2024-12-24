LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MEM_WB_Register_TB IS
END MEM_WB_Register_TB;

ARCHITECTURE Behavioral OF MEM_WB_Register_TB IS
    COMPONENT MEM_WB_Register
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
    END COMPONENT;

    SIGNAL CLK : STD_LOGIC := '0';
    SIGNAL RESET : STD_LOGIC := '0';
    SIGNAL WRITE_EN : STD_LOGIC := '0';
    SIGNAL WB_IN : STD_LOGIC := '0';
    SIGNAL WB_DATA_IN : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL WB_ADDR_IN : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Rdst_IN : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL WB_OUT : STD_LOGIC;
    SIGNAL WB_DATA_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL WB_ADDR_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Rdst_OUT : STD_LOGIC_VECTOR(2 DOWNTO 0);

    CONSTANT CLK_PERIOD : TIME := 10 ns;

BEGIN
    CLK_PROCESS : PROCESS
    BEGIN
        WHILE true LOOP
            CLK <= '0';
            WAIT FOR CLK_PERIOD / 2;
            CLK <= '1';
            WAIT FOR CLK_PERIOD / 2;
        END LOOP;
    END PROCESS;

    UUT_MEM_WB : MEM_WB_Register
    PORT MAP(
        CLK => CLK,
        RESET => RESET,
        WRITE_EN => WRITE_EN,
        WB_IN => WB_IN,
        WB_DATA_IN => WB_DATA_IN,
        WB_ADDR_IN => WB_ADDR_IN,
        Rdst_IN => Rdst_IN,
        WB_OUT => WB_OUT,
        WB_DATA_OUT => WB_DATA_OUT,
        WB_ADDR_OUT => WB_ADDR_OUT,
        Rdst_OUT => Rdst_OUT
    );

    STIMULUS_PROCESS_MEM_WB : PROCESS
    BEGIN
        -- Reset test
        RESET <= '1';
        WAIT FOR CLK_PERIOD;
        RESET <= '0';
        ASSERT WB_OUT = '0' AND WB_DATA_OUT = x"0000" AND WB_ADDR_OUT = x"0000" AND Rdst_OUT = "000"
        REPORT "Reset failed" SEVERITY error;

        -- Write test
        WB_IN <= '1';
        WB_DATA_IN <= x"9ABC";
        WB_ADDR_IN <= x"DEF0";
        Rdst_IN <= "101";
        WRITE_EN <= '1';
        WAIT FOR CLK_PERIOD;
        WRITE_EN <= '0';
        ASSERT WB_OUT = '1' AND WB_DATA_OUT = x"9ABC" AND WB_ADDR_OUT = x"DEF0" AND Rdst_OUT = "101"
        REPORT "Write test failed" SEVERITY error;

        -- Test 3: No write when write_enable = '0'
        WB_IN <= '0';
        WB_DATA_IN <= x"AAAA";
        WB_ADDR_IN <= x"BBBB";
        Rdst_IN <= "110";
        WRITE_EN <= '0';
        WAIT FOR CLK_PERIOD;
        ASSERT WB_OUT = '1' AND WB_DATA_OUT = x"9ABC" AND WB_ADDR_OUT = x"DEF0" AND Rdst_OUT = "101"
        REPORT "No-write test failed" SEVERITY error;

        -- Test 4: Reset overrides write_enable
        RESET <= '1';
        WB_IN <= '1';
        WB_DATA_IN <= x"CCCC";
        WB_ADDR_IN <= x"DDDD";
        Rdst_IN <= "111";
        WRITE_EN <= '1';
        WAIT FOR CLK_PERIOD;
        RESET <= '0';
        ASSERT WB_OUT = '0' AND WB_DATA_OUT = x"0000" AND WB_ADDR_OUT = x"0000" AND Rdst_OUT = "000"
        REPORT "Reset override test failed" SEVERITY error;

        -- Test 5: Multiple writes
        WB_IN <= '1';
        WB_DATA_IN <= x"1111";
        WB_ADDR_IN <= x"2222";
        Rdst_IN <= "001";
        WRITE_EN <= '1';
        WAIT FOR CLK_PERIOD;
        WB_IN <= '0';
        WB_DATA_IN <= x"3333";
        WB_ADDR_IN <= x"4444";
        Rdst_IN <= "010";
        WAIT FOR CLK_PERIOD;
        WRITE_EN <= '0';
        ASSERT WB_OUT = '0' AND WB_DATA_OUT = x"3333" AND WB_ADDR_OUT = x"4444" AND Rdst_OUT = "010"
        REPORT "Multiple writes test failed" SEVERITY error;

        WAIT;
    END PROCESS;
END Behavioral;