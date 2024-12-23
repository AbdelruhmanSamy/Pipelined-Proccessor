LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY input_port_tb IS
END ENTITY input_port_tb;

ARCHITECTURE behavior OF input_port_tb IS

    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT input_port -- Assuming the UUT entity is input_port
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            INPUT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            OUTPUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -- Testbench signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL INPUT : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL OUTPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock period definition
    CONSTANT clk_period : TIME := 100 ps;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut : input_port
    PORT MAP(
        clk => clk,
        reset => reset,
        INPUT => INPUT,
        OUTPUT => OUTPUT
    );

    -- Clock generation process
    clk_process : PROCESS
    BEGIN
        -- Generate clock signal with period defined by clk_period
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Test process
    stimulus_process : PROCESS
    BEGIN
        -- Apply reset
        reset <= '1';
        WAIT FOR clk_period;
        reset <= '0';
        WAIT FOR clk_period;

        -- Test case 1: Pass a value to INPUT (16-bit value)
        INPUT <= X"0055"; -- Hexadecimal 55 = 01010101 in binary (16 bits)
        WAIT FOR clk_period;

        -- Test case 2: Change the INPUT value (16-bit value)
        INPUT <= X"00AA"; -- Hexadecimal AA = 10101010 in binary (16 bits)
        WAIT FOR clk_period;

        -- Test case 3: Reset the system
        reset <= '1';
        WAIT FOR clk_period;
        reset <= '0';
        WAIT FOR clk_period;

        -- Test case 4: Pass another value to INPUT (16-bit value)
        INPUT <= X"00FF"; -- Hexadecimal FF = 11111111 in binary (16 bits)
        WAIT FOR clk_period;

        -- End simulation after a few cycles
        WAIT FOR clk_period * 10;
        -- End simulation by waiting for a long enough time
        std.env.stop;
    END PROCESS;

END ARCHITECTURE behavior;