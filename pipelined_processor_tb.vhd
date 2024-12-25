LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY pipelined_processor_tb IS
END pipelined_processor_tb;

ARCHITECTURE behavior OF pipelined_processor_tb IS
    -- Component Declaration
    COMPONENT pipelined_processor IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            in_port_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

    -- Signals for connecting to the DUT
    SIGNAL clk_tb : STD_LOGIC := '0';
    SIGNAL rst_tb : STD_LOGIC := '0';
    SIGNAL in_port_data_tb : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

BEGIN
    -- Instantiate the Device Under Test (DUT)
    DUT : pipelined_processor PORT MAP(
        clk => clk_tb,
        rst => rst_tb,
        in_port_data => in_port_data_tb
    );

    -- Clock process
    clk_process : PROCESS
    BEGIN
        clk_tb <= '0';
        WAIT FOR clk_period/2;
        clk_tb <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    -- Stimulus process
    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- Initial reset
        rst_tb <= '1';
        WAIT FOR clk_period * 2;
        rst_tb <= '0';

        -- Test Case 1: Basic input port test
        in_port_data_tb <= x"1234";
        WAIT FOR clk_period * 4;
        ASSERT in_port_data_tb = x"1234"
        REPORT "Test Case 1 Failed: in_port_data_tb is not 0x1234" SEVERITY ERROR;

        -- Test Case 2: Different input value
        in_port_data_tb <= x"5678";
        WAIT FOR clk_period * 4;
        ASSERT in_port_data_tb = x"5678"
        REPORT "Test Case 2 Failed: in_port_data_tb is not 0x5678" SEVERITY ERROR;

        -- Test Case 3: Zero input
        in_port_data_tb <= x"0000";
        WAIT FOR clk_period * 4;
        ASSERT in_port_data_tb = x"0000"
        REPORT "Test Case 3 Failed: in_port_data_tb is not 0x0000" SEVERITY ERROR;

        -- Test Case 4: Maximum value
        in_port_data_tb <= x"FFFF";
        WAIT FOR clk_period * 4;
        ASSERT in_port_data_tb = x"FFFF"
        REPORT "Test Case 4 Failed: in_port_data_tb is not 0xFFFF" SEVERITY ERROR;

        -- Test Case 5: Alternating bits
        in_port_data_tb <= x"AAAA";
        WAIT FOR clk_period * 4;
        ASSERT in_port_data_tb = x"AAAA"
        REPORT "Test Case 5 Failed: in_port_data_tb is not 0xAAAA" SEVERITY ERROR;

        -- Test Case 6: Reset during operation
        in_port_data_tb <= x"BBBB";
        WAIT FOR clk_period * 2;
        rst_tb <= '1';
        WAIT FOR clk_period;
        rst_tb <= '0';
        WAIT FOR clk_period * 4;
        ASSERT rst_tb = '0'
        REPORT "Test Case 6 Failed: Reset signal did not deactivate properly" SEVERITY ERROR;

        -- Test Case 7: Rapid input changes
        in_port_data_tb <= x"1111";
        WAIT FOR clk_period;
        ASSERT in_port_data_tb = x"1111"
        REPORT "Test Case 7 Failed: in_port_data_tb is not 0x1111 after rapid change" SEVERITY ERROR;

        in_port_data_tb <= x"2222";
        WAIT FOR clk_period;
        ASSERT in_port_data_tb = x"2222"
        REPORT "Test Case 7 Failed: in_port_data_tb is not 0x2222 after rapid change" SEVERITY ERROR;

        in_port_data_tb <= x"3333";
        WAIT FOR clk_period;
        ASSERT in_port_data_tb = x"3333"
        REPORT "Test Case 7 Failed: in_port_data_tb is not 0x3333 after rapid change" SEVERITY ERROR;

        in_port_data_tb <= x"4444";
        WAIT FOR clk_period;
        ASSERT in_port_data_tb = x"4444"
        REPORT "Test Case 7 Failed: in_port_data_tb is not 0x4444 after rapid change" SEVERITY ERROR;

        -- Add more test cases with assertions as needed

        -- End simulation
        WAIT FOR clk_period * 10;
        REPORT "Simulation completed successfully" SEVERITY NOTE;
        std.env.stop;
    END PROCESS;
END behavior;