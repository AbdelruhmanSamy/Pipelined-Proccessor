LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY memory_stage IS
    PORT (
        -- instruction memory related
        ResetMemory : IN STD_LOGIC;
        MemWrite : IN STD_LOGIC;
        MemRead : IN STD_LOGIC;

        -- control signals 
        POP : IN STD_LOGIC;
        RET : IN STD_LOGIC;
        PUSH : IN STD_LOGIC;
        CALL : IN STD_LOGIC;
        INT : IN STD_LOGIC;
        RTI : IN STD_LOGIC;
        LDM : IN STD_LOGIC;

        -- rest of inputs 
        PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        SP : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        FlagsAddress : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        MemoryAddress : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        MemoryDataIn : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Immediate : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        -- Outputs
        MemoryDataOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        memory_address_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END memory_stage;

ARCHITECTURE memory_stage_architecture OF memory_stage IS

    COMPONENT data_memory IS
        PORT (
            ResetMemory : IN STD_LOGIC;
            MemWrite : IN STD_LOGIC;
            MemRead : IN STD_LOGIC;
            Address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            DataIn : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            DataOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -- Signal Declarations
    SIGNAL memory_data_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL selected_address : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL selected_memory_in : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL stack_pointer : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL memory_address_signal : STD_LOGIC_VECTOR(15 DOWNTO 0);
    -- 2-bit MUX Selector Signals
    SIGNAL mux1_selector : STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN

    stack_pointer <= SP(11 DOWNTO 0);

    mux1_selector(0) <= POP OR RET OR PUSH OR CALL OR INT;
    mux1_selector(1) <= RTI;

    WITH mux1_selector SELECT
    selected_address <=
    MemoryAddress WHEN "00",
    FlagsAddress WHEN "01",
    stack_pointer WHEN "10",
    MemoryAddress WHEN OTHERS;

    selected_memory_in <= MemoryDataIn WHEN INT = '0' ELSE
    PC;

    memory_address_signal <= STD_LOGIC_VECTOR(RESIZE(SIGNED(MemoryAddress), 16)) WHEN LDM = '0' ELSE
    Immediate;

    data_memory_unit : data_memory PORT MAP(
        ResetMemory => ResetMemory,
        MemWrite => MemWrite,
        MemRead => MemRead,
        Address => selected_address,
        DataIn => selected_memory_in,
        DataOut => memory_data_out
    );

    MemoryDataOut <= memory_data_out;
    memory_address_out <= memory_address_signal;

END memory_stage_architecture;