
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY IF_ID_Register_TB IS
END IF_ID_Register_TB;

ARCHITECTURE Behavioral OF IF_ID_Register_TB IS
    COMPONENT IF_ID_Register
        PORT (
            CLK : IN STD_LOGIC;
            RESET : IN STD_LOGIC;
            WRITE_EN : IN STD_LOGIC;
            FLUSH_IN : IN STD_LOGIC;
            PC_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            INSTR_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            FLUSH_OUT : OUT STD_LOGIC;
            PC_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            INSTR_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL CLK : STD_LOGIC := '0';
    SIGNAL RESET : STD_LOGIC := '0';
    SIGNAL WRITE_EN : STD_LOGIC := '0';
    SIGNAL FLUSH_IN : STD_LOGIC := '0';
    SIGNAL PC_IN : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL INSTR_IN : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL FLUSH_OUT : STD_LOGIC;
    SIGNAL PC_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL INSTR_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);

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

    UUT_IF_ID : IF_ID_Register
    PORT MAP(
        CLK => CLK,
        RESET => RESET,
        WRITE_EN => WRITE_EN,
        FLUSH_IN => FLUSH_IN,
        PC_IN => PC_IN,
        INSTR_IN => INSTR_IN,
        FLUSH_OUT => FLUSH_OUT,
        PC_OUT => PC_OUT,
        INSTR_OUT => INSTR_OUT
    );

    STIMULUS_PROCESS_IF_ID : PROCESS
    BEGIN
        -- Reset test
        RESET <= '1';
        WAIT FOR CLK_PERIOD;
        RESET <= '0';
        ASSERT PC_OUT = x"0000" AND INSTR_OUT = x"0000" AND FLUSH_OUT = '0'
        REPORT "Reset failed" SEVERITY error;

        -- Write test
        PC_IN <= x"1234";
        INSTR_IN <= x"5678";
        FLUSH_IN <= '1';
        WRITE_EN <= '1';
        WAIT FOR CLK_PERIOD;
        WRITE_EN <= '0';
        ASSERT PC_OUT = x"1234" AND INSTR_OUT = x"5678" AND FLUSH_OUT = '1'
        REPORT "Write test failed" SEVERITY error;

        -- Test 3: No write when write_enable = '0'
        PC_IN <= x"ABCD";
        INSTR_IN <= x"EF01";
        FLUSH_IN <= '0';
        WRITE_EN <= '0';
        WAIT FOR CLK_PERIOD;
        ASSERT PC_OUT = x"1234" AND INSTR_OUT = x"5678" AND FLUSH_OUT = '1'
        REPORT "No-write test failed" SEVERITY error;

        -- Test 4: Reset overrides write_enable
        RESET <= '1';
        PC_IN <= x"ABCD";
        INSTR_IN <= x"EF01";
        FLUSH_IN <= '1';
        WRITE_EN <= '1';
        wait for CLK_PERIOD;
        RESET <= '0';
        assert PC_OUT = x"0000" and INSTR_OUT = x"0000" and FLUSH_OUT = '0'
            report "Reset override test failed" severity error;

         -- Test 5: Multiple writes
         PC_IN <= x"1111";
         INSTR_IN <= x"2222";
         FLUSH_IN <= '0';
         WRITE_EN <= '1';
         wait for CLK_PERIOD;
         PC_IN <= x"3333";
         INSTR_IN <= x"4444";
         FLUSH_IN <= '1';
         wait for CLK_PERIOD;
         WRITE_EN <= '0';
         assert PC_OUT = x"3333" and INSTR_OUT = x"4444" and FLUSH_OUT = '1'
             report "Multiple writes test failed" severity error;

        WAIT;
    END PROCESS;
END Behavioral;