library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_memory_stage is
end tb_memory_stage;

architecture behavior of tb_memory_stage is

    component memory_stage is
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
    end component;

    -- Signals to drive the UUT
    signal ResetMemory : STD_LOGIC := '0';
    signal MemWrite : STD_LOGIC := '0';
    signal MemRead : STD_LOGIC := '0';
    signal Address : STD_LOGIC_VECTOR(11 DOWNTO 0) := (others => '0');
    signal MemoryDataOut : STD_LOGIC_VECTOR(15 DOWNTO 0);

    signal POP : STD_LOGIC := '0';
    signal RET : STD_LOGIC := '0';
    signal PUSH : STD_LOGIC := '0';
    signal CALL : STD_LOGIC := '0';
    signal INT : STD_LOGIC := '0';
    signal RTI : STD_LOGIC := '0';

    signal PC : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    signal SP : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    signal FlagsAddress : STD_LOGIC_VECTOR(11 DOWNTO 0) := (others => '0');
    signal MemoryAddress : STD_LOGIC_VECTOR(11 DOWNTO 0) := (others => '0');
    signal MemoryDataIn : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    

    signal clk : STD_LOGIC := '0';
    CONSTANT clk_period : TIME := 100 ps;

    -- data memory contents for the test in case of changes in data.txt
    constant MEMORY_DATA0 : std_logic_vector(15 downto 0) := "0000000000000001";
    constant MEMORY_DATA1 : std_logic_vector(15 downto 0) := "0010001000000011";
    constant MEMORY_DATA2 : std_logic_vector(15 downto 0) := "0010010000000111";
    constant MEMORY_DATA3 : std_logic_vector(15 downto 0) := "0010011000011111";
    constant MEMORY_DATA4 : std_logic_vector(15 downto 0) := "0010011001111101";
    constant MEMORY_DATA5 : std_logic_vector(15 downto 0) := "0010001001110101";
    constant MEMORY_DATA6 : std_logic_vector(15 downto 0) := "0010001001110101";
    

begin
    uut: memory_stage port map (
        ResetMemory => ResetMemory,
        MemWrite => MemWrite,
        MemRead => MemRead,
        MemoryDataOut => MemoryDataOut,
        POP => POP,
        RET => RET,
        PUSH => PUSH,
        CALL => CALL,
        INT => INT,
        RTI => RTI,
        PC => PC,
        SP => SP,
        FlagsAddress => FlagsAddress,
        MemoryAddress => MemoryAddress,
        MemoryDataIn => MemoryDataIn
    );

    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;


    stimulus: process
    begin
        -- Apply reset
        ResetMemory <= '1';
        wait for 100 ps;
        ResetMemory <= '0';

        -- Test Case 1: Check initial values after reset
        assert (MemoryDataOut = "0000000000000000") report "Initial output error" severity error;

        
        -- Test Case 2: Test memory read
        MemRead <= '1';
        MemWrite <= '0';
        MemoryAddress <= "000000000011"; 
        MemoryDataIn <= "0000000000000001"; 
        wait for 100 ps;
        assert (MemoryDataOut = MEMORY_DATA3) report "Memory read failed" severity error;
        
        -- Test Case 3: Test memory write
        MemRead <= '0';
        MemWrite <= '1';
        MemoryAddress <= "000001000010"; -- Write address
        MemoryDataIn <= "0000000000001010"; -- Data to write
        wait for 100 ps;

        MemRead <= '1';
        MemWrite <= '0';
        wait for 100 ps;

        assert (MemoryDataOut = MemoryDataIn) report "Memory write failed" severity error;

        -- Test Case 4: Test control signals for MUX selection
        -- Case 1: POP, RET, PUSH, CALL, INT = '0' and RTI = '0' should select MemoryAddress
        POP <= '0'; RET <= '0'; PUSH <= '0'; CALL <= '0'; INT <= '0'; RTI <= '0';
        MemoryAddress <= "000000000001"; 
        FlagsAddress <= "000000000101";
        SP <= "0000000000000010"; 
        wait for 100 ps;
        assert (MemoryDataOut = MEMORY_DATA1) report "MUX selection failed for MemoryAddress" severity error;

        -- Case 2: RTI = '1' should select SP lower 12 bits
        POP <= '0'; RET <= '0'; PUSH <= '0'; CALL <= '0'; INT <= '0'; RTI <= '1';
        wait for 100 ps;
        assert (MemoryDataOut = MEMORY_DATA2) report "MUX selection failed for SP lower 12 bits" severity error;

        -- Case 3: INT = '1' and others = '0' should select FlagsAddress
        POP <= '0'; RET <= '0'; PUSH <= '0'; CALL <= '0'; INT <= '1'; RTI <= '0';
        wait for 100 ps;
        assert (MemoryDataOut = MEMORY_DATA5) report "MUX selection failed for FlagsAddress" severity error;


        -- Test Case 5: Test INT selector for memory input (second MUX)
        PC <= "1111000011110000";
        MemoryDataIn <= "0010111100001111"; 
        
        POP <= '0'; RET <= '0'; PUSH <= '0'; CALL <= '0'; INT <= '1'; RTI <= '0';
        MemRead <= '0';
        MemWrite <= '1';
        wait for 100 ps;

        MemRead <= '1';
        MemWrite <= '0';
        wait for 100 ps;

        assert (MemoryDataOut = PC) report "Second MUX selection failed for PC" severity error;

        INT <= '0';
        MemRead <= '0';
        MemWrite <= '1';
        wait for 100 ps;

        MemRead <= '1';
        MemWrite <= '0';
        wait for 100 ps;

        assert (MemoryDataOut = MemoryDataIn) report "Second MUX selection failed for PC" severity error;

        -- Finish simulation
        wait for 100 ps;
        assert false report "End of simulation" severity note;
    end process;
end behavior;
