LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE STD.TEXTIO.ALL;

ENTITY instruction_memory IS
    PORT (
        reset : IN STD_LOGIC;
        Address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        DataOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY instruction_memory;

ARCHITECTURE arch_instruction_memory OF instruction_memory IS
    TYPE MemoryArray IS ARRAY (0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Ram : MemoryArray := (OTHERS => (OTHERS => '0'));

    -- Helper function to convert STRING to STD_LOGIC_VECTOR with correct bit order
    FUNCTION TO_STDLOGICVECTOR(str : STRING) RETURN STD_LOGIC_VECTOR IS
        VARIABLE result : STD_LOGIC_VECTOR(str'LENGTH - 1 DOWNTO 0);
    BEGIN
        FOR i IN str'RANGE LOOP
            IF str(i) = '0' THEN
                result(str'LENGTH - (i - str'LOW) - 1) := '0';
            ELSE
                result(str'LENGTH - (i - str'LOW) - 1) := '1';
            END IF;
        END LOOP;
        RETURN result;
    END FUNCTION;

BEGIN

    PROCESS (reset, Address)
        FILE memory_file : TEXT;
        VARIABLE file_line : LINE;
        VARIABLE temp_data : STRING(1 TO 16);
    BEGIN
        IF reset = '1' THEN
            -- Load instructions from file
            file_open(memory_file, "instructions.txt", READ_MODE);
            FOR i IN Ram'RANGE LOOP
                IF NOT ENDFILE(memory_file) THEN
                    readline(memory_file, file_line);
                    -- Read the line as a string
                    read(file_line, temp_data);
                    -- Convert string to STD_LOGIC_VECTOR
                    Ram(i) <= TO_STDLOGICVECTOR(temp_data);
                ELSE
                    EXIT;
                END IF;
            END LOOP;
            file_close(memory_file);
        END IF;

        -- Output data from memory
        DataOut <= Ram(to_integer(unsigned(Address)));
    END PROCESS;

END ARCHITECTURE arch_instruction_memory;