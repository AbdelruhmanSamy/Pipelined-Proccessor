library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity memory_stage is
    Port (
        --==================================================================
        -- instruction memory related
        ResetMemory : IN STD_LOGIC;
        MemWrite : IN STD_LOGIC;
        MemRead : IN STD_LOGIC;
        MemoryDataOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        --==================================================================
        -- control signals 
        POP : in STD_LOGIC;
        RET : in STD_LOGIC;
        PUSH : in STD_LOGIC;
        CALL : in STD_LOGIC;
        INT : in STD_LOGIC;
        RTI : in STD_LOGIC;

        --==================================================================
        -- rest of inputs 
        PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        SP : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        FlagsAddress : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        MemoryAddress : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        MemoryDataIn : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
end memory_stage;

architecture memory_stage_architecture of memory_stage is

    component data_memory is
        PORT (
        ResetMemory : IN STD_LOGIC;
        MemWrite : IN STD_LOGIC;
        MemRead : IN STD_LOGIC;
        Address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        DataIn : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        DataOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
    end component;

    -- Signal Declarations
    signal memory_data_out : std_logic_vector(15 downto 0);
    signal selected_address : std_logic_vector(11 downto 0);
    signal selected_memory_in : std_logic_vector(15 downto 0);
    signal stack_pointer : std_logic_vector(11 downto 0);

    -- 2-bit MUX Selector Signals
    signal mux1_selector : std_logic_vector(1 downto 0);

begin
    -- ==================================== Wires Connection ====================================

    -- Extract the lower 12 bits of SP for the stack pointer
    stack_pointer <= SP(11 downto 0);

    -- First MUX: selects between MemoryAddress, FlagsAddress, and lower 12 bits of SP
    mux1_selector(0) <= POP or RET or PUSH or CALL or INT;  -- First bit: OR of control signals
    mux1_selector(1) <= RTI;  -- Second bit: RTI signal

    with mux1_selector select
        selected_address <= 
            MemoryAddress when "00",  -- Both control signals are 0: select MemoryAddress
            FlagsAddress when "01",   -- Control signal is 1, RTI is 0: select FlagsAddress
            stack_pointer when "10",  -- RTI = 1, control signals = 0: select SP lower 12 bits
            MemoryAddress when others; -- For the remaining cases (i.e., RTI = 1, control signals = 1): select MemoryAddress

    -- Second MUX: selects between PC and MemoryDataIn based on INT signal
    selected_memory_in <= MemoryDataIn when INT = '0' else PC;

    -- ==================================== Data Memory Instantiation ====================================
    data_memory_unit : data_memory port map (
        ResetMemory => ResetMemory,
        MemWrite => MemWrite,
        MemRead => MemRead,
        Address => selected_address,
        DataIn => selected_memory_in,
        DataOut => memory_data_out
    );

    MemoryDataOut <= memory_data_out;

end memory_stage_architecture;
