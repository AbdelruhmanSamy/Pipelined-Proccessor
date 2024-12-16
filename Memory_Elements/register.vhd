LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY generic_register IS
    GENERIC (
        REGISTER_SIZE : INTEGER := 16;
        RESET_VALUE : INTEGER := 0
    );
    PORT (
        write_enable, clk, reset : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0)
    );
END generic_register;

ARCHITECTURE Behavioral OF generic_register IS
    SIGNAL temp_data_out : STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
BEGIN
    data_out <= temp_data_out;

    PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            temp_data_out <= STD_LOGIC_VECTOR(to_unsigned(RESET_VALUE, REGISTER_SIZE));
        ELSIF rising_edge(clk) THEN
            IF (write_enable = '1') THEN
                temp_data_out <= data_in;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;