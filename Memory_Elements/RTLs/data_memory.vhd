LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_textio.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.numeric_std.ALL;
USE std.textio.ALL;

ENTITY data_memory IS
    PORT (
        ResetMemory : IN STD_LOGIC;
        MemWrite : IN STD_LOGIC;
        MemRead : IN STD_LOGIC;
        Address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        DataIn : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        DataOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE arch_data_memory OF data_memory IS
    TYPE MemoryArray IS ARRAY(0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Declare signals for the memory and a default initialization
    SIGNAL Ram : MemoryArray := (OTHERS => (OTHERS => '0'));

BEGIN

    data_memory : PROCESS (Address, DataIn, MemWrite, MemRead, ResetMemory, Ram) IS
        FILE memory_file : TEXT;
        VARIABLE fileLineContent : LINE;
        VARIABLE temp_data : STD_LOGIC_VECTOR(15 DOWNTO 0);
    BEGIN
        IF (ResetMemory = '1') THEN
            -- Only open the file once when initializing the memory

            file_open(memory_file, "data.txt");

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
            DataOut <= (OTHERS => '0');
        ELSIF MemWrite = '1' THEN
            Ram(to_integer(unsigned(Address))) <= DataIn(15 DOWNTO 0);
        ELSIF MemRead = '1' THEN
            DataOut <= Ram(to_integer(unsigned(Address)));
        END IF;
    END PROCESS data_memory;

END ARCHITECTURE;