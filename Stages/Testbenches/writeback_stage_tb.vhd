-- Testbench for writeback_stage
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY writeback_stage_tb IS
END ENTITY writeback_stage_tb;

ARCHITECTURE Behavioral OF writeback_stage_tb IS
    COMPONENT writeback_stage
        PORT (
            MemtoReg   : IN  STD_LOGIC;
            WB_data_in : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
            WB_address : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
            Rdst_in    : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
            WB_data    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            WB_data_out: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            Rdst_out   : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL MemtoReg   : STD_LOGIC;
    SIGNAL WB_data_in : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL WB_address : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Rdst_in    : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL WB_data    : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL WB_data_out: STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Rdst_out   : STD_LOGIC_VECTOR(2 DOWNTO 0);

    CONSTANT CLK_PERIOD : TIME := 10 ns;
BEGIN
    UUT : writeback_stage
        PORT MAP (
            MemtoReg   => MemtoReg,
            WB_data_in => WB_data_in,
            WB_address => WB_address,
            Rdst_in    => Rdst_in,
            WB_data    => WB_data,
            WB_data_out=> WB_data_out,
            Rdst_out   => Rdst_out
        );

    STIMULUS : PROCESS
    BEGIN
        -- Test 1: MemtoReg = '0', pass WB_address
        MemtoReg <= '0';
        WB_data_in <= x"1234";
        WB_address <= x"5678";
        Rdst_in <= "001";
        WAIT FOR CLK_PERIOD;
        ASSERT WB_data = x"5678" AND WB_data_out = x"1234" AND Rdst_out = "001"
            REPORT "Test 1 failed: MemtoReg = '0'" SEVERITY ERROR;

        -- Test 2: MemtoReg = '1', pass WB_data_in
        MemtoReg <= '1';
        WB_data_in <= x"9ABC";
        WB_address <= x"DEF0";
        Rdst_in <= "010";
        WAIT FOR CLK_PERIOD;
        ASSERT WB_data = x"9ABC" AND WB_data_out = x"9ABC" AND Rdst_out = "010"
            REPORT "Test 2 failed: MemtoReg = '1'" SEVERITY ERROR;

        -- Test 3: Change Rdst_in, ensure proper propagation
        Rdst_in <= "101";
        WAIT FOR CLK_PERIOD;
        ASSERT WB_data = x"9ABC" AND WB_data_out = x"9ABC" AND Rdst_out = "101"
            REPORT "Test 3 failed: Rdst propagation" SEVERITY ERROR;

        -- Test 4: Verify multiple changes in inputs
        MemtoReg <= '0';
        WB_data_in <= x"1111";
        WB_address <= x"2222";
        Rdst_in <= "011";
        WAIT FOR CLK_PERIOD;
        ASSERT WB_data = x"2222" AND WB_data_out = x"1111" AND Rdst_out = "011"
            REPORT "Test 4 failed: Multiple changes" SEVERITY ERROR;

        WAIT;
    END PROCESS;

END ARCHITECTURE Behavioral;
