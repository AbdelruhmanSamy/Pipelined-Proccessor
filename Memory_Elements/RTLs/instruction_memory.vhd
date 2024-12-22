LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

ENTITY instruction_memory IS
    PORT (
        ResetMemory : IN STD_LOGIC;
        Address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        DataOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch_instruction_memory OF instruction_memory IS
    TYPE MemoryArray IS ARRAY(0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Declare signals for the memory and a default initialization
    SIGNAL Ram : MemoryArray := (OTHERS => (OTHERS => '0'));
    SIGNAL FirstAddress : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');

BEGIN

    instruction_memory : PROCESS (Address, ResetMemory, FirstAddress, Ram) IS
        FILE memory_file : TEXT;
        VARIABLE fileLineContent : LINE;

        VARIABLE temp_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN
        IF (ResetMemory = '1') THEN
            -- Only open the file once when initializing the memory
            file_open(memory_file, "instructions.txt");

            FOR i IN Ram'RANGE LOOP
                IF NOT ENDFILE(memory_file) THEN
                    readline(memory_file, fileLineContent);
                    read(fileLineContent, temp_data);
                    Ram(i) <= temp_data;
                ELSE
                    -- If the file ends before loading all memory, close the file
                    file_close(memory_file);
                    EXIT;
                END IF;
            END LOOP;
            DataOut <= Ram(to_integer(unsigned(FirstAddress)));

        ELSE
            DataOut <= Ram(to_integer(unsigned(Address)));
        END IF;
    END PROCESS instruction_memory;

END ARCHITECTURE;