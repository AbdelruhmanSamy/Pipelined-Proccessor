LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY general_register_file IS
    GENERIC (
        REGISTER_SIZE : INTEGER := 16;
        REGISTER_NUMBER : INTEGER := 8
    );
    PORT (
        write_enable, clk, reset : IN STD_LOGIC;
        read_address1, read_address2, write_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_data : IN STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
        read_data1, read_data2 : OUT STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0)
    );
END ENTITY general_register_file;

ARCHITECTURE Behavioral OF general_register_file IS
    TYPE register_array IS ARRAY(NATURAL RANGE <>) OF STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
    SIGNAL general_register : register_array(0 TO REGISTER_NUMBER - 1) := (OTHERS => (OTHERS => '0'));
BEGIN

    read_data1 <= general_register(to_integer(unsigned(read_address1)));
    read_data2 <= general_register(to_integer(unsigned(read_address2)));

    PROCESS (clk)
    BEGIN
        IF falling_edge(clk) THEN -- For making the reading always with the positive edge, and the write at the falling edge
            IF (reset = '1') THEN
                FOR i IN 0 TO REGISTER_NUMBER - 1 LOOP
                    general_register(i) <= (OTHERS => '0');
                END LOOP;

            ELSE
                IF (write_enable = '1') THEN
                    general_register(to_integer(unsigned(write_address))) <= write_data;
                END IF;
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE Behavioral;