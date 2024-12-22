LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY fetch_stage_tb IS
END ENTITY fetch_stage_tb;

ARCHITECTURE behavior OF fetch_stage_tb IS
    -- Component Declaration
    COMPONENT fetch_stage
        GENERIC (
            DATA_SIZE : INTEGER := 16
        );
        PORT (
            clk, reset, pc_register_enable : IN STD_LOGIC;
            instruction : OUT STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL pc_register_enable : STD_LOGIC := '0';
    SIGNAL instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period
    CONSTANT clk_period : TIME := 100 ps;

BEGIN
    -- Instantiate the Fetch Stage
    uut : fetch_stage
    GENERIC MAP(
        DATA_SIZE => 16
    )
    PORT MAP(
        clk => clk,
        reset => reset,
        pc_register_enable => pc_register_enable,
        instruction => instruction
    );

    -- Clock Generation
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Stimulus Process
    stimulus : PROCESS
    BEGIN
        -- Reset the system
        reset <= '1';
        WAIT FOR clk_period * 2;
        reset <= '0';

        -- Enable PC Register and simulate instruction fetching
        pc_register_enable <= '1';
        WAIT FOR clk_period * 10;

        -- Disable PC Register
        pc_register_enable <= '0';
        WAIT FOR clk_period * 5;

        pc_register_enable <= '1';
        -- End simulation
        WAIT FOR clk_period * 50;

        std.env.stop;
    END PROCESS;

END ARCHITECTURE behavior;