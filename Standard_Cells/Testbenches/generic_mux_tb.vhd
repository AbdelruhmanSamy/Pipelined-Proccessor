LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY generic_mux_tb IS
END ENTITY generic_mux_tb;

ARCHITECTURE behavior OF generic_mux_tb IS
    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT generic_mux
        GENERIC (
            M : POSITIVE := 2; -- Width of each input
            N : POSITIVE := 4; -- Number of inputs
            K : POSITIVE := 2 -- Number of select lines
        );
        PORT (
            inputs : IN STD_LOGIC_VECTOR(M * N - 1 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR(K - 1 DOWNTO 0);
            outputs : OUT STD_LOGIC_VECTOR(M - 1 DOWNTO 0)
        );
    END COMPONENT;

    -- Testbench signals
    SIGNAL inputs_tb : STD_LOGIC_VECTOR(7 DOWNTO 0); -- 4 inputs, each 2 bits wide
    SIGNAL sel_tb : STD_LOGIC_VECTOR(1 DOWNTO 0); -- 2 select lines
    SIGNAL outputs_tb : STD_LOGIC_VECTOR(1 DOWNTO 0); -- Output signal

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : generic_mux
    GENERIC MAP(
        M => 2,
        N => 4,
        K => 2
    )
    PORT MAP(
        inputs => inputs_tb,
        sel => sel_tb,
        outputs => outputs_tb
    );

    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- Test case 1: Select input 0
        inputs_tb <= "00011011"; -- Concatenated inputs: 00, 01, 10, 11
        sel_tb <= "00"; -- Select input 0 ("00")
        WAIT FOR 10 ns;

        -- Test case 2: Select input 1
        sel_tb <= "01"; -- Select input 1 ("01")
        WAIT FOR 10 ns;

        -- Test case 3: Select input 2
        sel_tb <= "10"; -- Select input 2 ("10")
        WAIT FOR 10 ns;

        -- Test case 4: Select input 3
        sel_tb <= "11"; -- Select input 3 ("11")
        WAIT FOR 10 ns;

        -- End simulation
        WAIT;
    END PROCESS;

END ARCHITECTURE behavior;