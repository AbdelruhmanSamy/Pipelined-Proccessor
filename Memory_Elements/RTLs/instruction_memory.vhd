Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

Entity InstructionMem is 
port(
    PC            : inout std_logic_vector(15 downto 0); 
    ResetSignal   : in std_logic;                         
    InstructionOut: out std_logic_vector(15 downto 0)     
);
end Entity InstructionMem;

Architecture InstructionMemarch of InstructionMem is

    Type MemoryArray is Array(0 to 4095) of std_logic_vector(15 downto 0);

    Signal InstructionMemory, DefaultMemory : MemoryArray := (others => (others => '0'));
    Signal IsFirstLoad   : std_logic := '1';

begin

    process (ResetSignal)
        FILE instructionFile : TEXT OPEN READ_MODE IS "instructions.txt";
        variable fileLineContent : line := null;
        variable instructionData : std_logic_vector(15 downto 0);
        variable memoryAddress   : integer := 0;
        variable tempMemory      : MemoryArray := (others => (others => '0'));
    begin
        if (ResetSignal = '1') then  
            if (IsFirstLoad = '1') then  -- If it's the first load of instructions
                IsFirstLoad <= '0';  -- Mark as first load complete
                report "Loading Instruction Memory";

                -- Load instructions from the file
                while not EndFile(instructionFile) loop
                    readline(instructionFile, fileLineContent);  
                    read(fileLineContent, instructionData);    
                    tempMemory(memoryAddress) := instructionData;  
                    memoryAddress := memoryAddress + 1;  
                end loop;

                file_close(instructionFile);

                -- Copy the loaded data to the actual memory and default memory
                InstructionMemory <= tempMemory;
                DefaultMemory <= tempMemory;
            else
                -- If not the first load, keep the memory contents the same as default
                InstructionMemory <= DefaultMemory;
            end if;

            PC <= (others => '0');  -- Point PC to the first instruction (address 0)

            report "Reset Complete";
        end if;
    end process;

    InstructionOut <= InstructionMemory(to_integer(unsigned(PC(11 downto 0))));  -- Fetch instruction from memory

end Architecture InstructionMemarch;
