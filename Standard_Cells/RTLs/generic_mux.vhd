LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY generic_mux IS
    GENERIC (
        M : POSITIVE := 2; -- Width of each input, default is 2 bits
        N : POSITIVE := 4; -- Number of inputs, default is 4 inputs
        K : POSITIVE := 2 -- Number of select lines, default is 2
    );
    PORT (
        inputs : IN STD_LOGIC_VECTOR(M * N - 1 DOWNTO 0); -- Concatenated input signals
        sel : IN STD_LOGIC_VECTOR(K - 1 DOWNTO 0); -- Select lines
        outputs : OUT STD_LOGIC_VECTOR(M - 1 DOWNTO 0) -- Output signal
    );
END ENTITY generic_mux;

ARCHITECTURE Structural OF generic_mux IS
    SIGNAL selected_index : INTEGER RANGE 0 TO N - 1 := 0; -- Index of the selected input
BEGIN
    -- Convert binary select signal to an integer index
    PROCESS (sel)
    BEGIN
        selected_index <= TO_INTEGER(UNSIGNED(sel)); -- Using numeric_std's to_integer
    END PROCESS;

    -- Process to select the appropriate input and assign it to the output
    PROCESS (inputs, selected_index)
    BEGIN
        -- Extract the selected input vector from the concatenated inputs
        outputs <= inputs(((selected_index + 1) * M - 1) DOWNTO selected_index * M); -- Select M bits based on index
    END PROCESS;
END ARCHITECTURE Structural;