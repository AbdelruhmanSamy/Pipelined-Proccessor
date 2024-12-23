ARCHITECTURE behavior OF fetch_stage_tb IS

    -- Component declaration for the Unit Under Test (UUT)
    COMPONENT fetch_stage
        GENERIC (
            DATA_SIZE : INTEGER := 16
        );
        PORT (
            clk : IN STD_LOGIC;
            pc_register_enable : IN STD_LOGIC;
            index : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            reset : IN STD_LOGIC;
            is_INT : IN STD_LOGIC;
            is_RTI : IN STD_LOGIC;
            is_HLT : IN STD_LOGIC;
            is_JCond : IN STD_LOGIC;
            is_JMP : IN STD_LOGIC;
            is_CALL : IN STD_LOGIC;
            is_RET : IN STD_LOGIC;
            is_EmptySP : IN STD_LOGIC;
            is_InvMemAddress : IN STD_LOGIC;
            is_NOP : IN STD_LOGIC;
            address_to_jump : IN STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
            popped_address_to_jump : IN STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
            first_mem_address : IN STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
            fourth_mem_address : IN STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
            second_mem_address : IN STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
            instruction : OUT STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0)
        );
    END COMPONENT;

    -- Testbench signals
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL pc_register_enable : STD_LOGIC := '0';
    SIGNAL index : STD_LOGIC_VECTOR(0 DOWNTO 0) := (OTHERS => '0'); -- Fixed type
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL is_INT : STD_LOGIC := '0';
    SIGNAL is_RTI : STD_LOGIC := '0';
    SIGNAL is_HLT : STD_LOGIC := '0';
    SIGNAL is_JCond : STD_LOGIC := '0';
    SIGNAL is_JMP : STD_LOGIC := '0';
    SIGNAL is_CALL : STD_LOGIC := '0';
    SIGNAL is_RET : STD_LOGIC := '0';
    SIGNAL is_EmptySP : STD_LOGIC := '0';
    SIGNAL is_InvMemAddress : STD_LOGIC := '0';
    SIGNAL is_NOP : STD_LOGIC := '0';
    SIGNAL address_to_jump : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL popped_address_to_jump : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL first_mem_address : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL fourth_mem_address : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0010011000011111";
    SIGNAL second_mem_address : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0010001000000011";
    SIGNAL instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- Clock generation process
    CONSTANT clk_period : TIME := 100 ps;

BEGIN

    clk_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            clk <= '0';
            WAIT FOR clk_period / 2;
            clk <= '1';
            WAIT FOR clk_period / 2;
        END LOOP;
    END PROCESS;

    -- Instantiate the Unit Under Test (UUT)
    uut : fetch_stage
    GENERIC MAP(
        DATA_SIZE => 16
    )
    PORT MAP(
        clk => clk,
        pc_register_enable => pc_register_enable,
        index => index,
        reset => reset,
        is_INT => is_INT,
        is_RTI => is_RTI,
        is_HLT => is_HLT,
        is_JCond => is_JCond,
        is_JMP => is_JMP,
        is_CALL => is_CALL,
        is_RET => is_RET,
        is_EmptySP => is_EmptySP,
        is_InvMemAddress => is_InvMemAddress,
        is_NOP => is_NOP,
        address_to_jump => address_to_jump,
        popped_address_to_jump => popped_address_to_jump,
        first_mem_address => first_mem_address,
        fourth_mem_address => fourth_mem_address,
        second_mem_address => second_mem_address,
        instruction => instruction
    );

    -- Test process
    PROCESS
    BEGIN
        -- Reset the system
        reset <= '1';
        WAIT FOR clk_period;
        reset <= '0';

        -- Enable PC register and simulate normal operation
        pc_register_enable <= '1';
        WAIT FOR clk_period * 5;

        -- Simulate a jump instruction
        is_JMP <= '1';
        address_to_jump <= X"0010"; -- Jump to address 16
        WAIT FOR clk_period;
        is_JMP <= '0';

        -- Simulate an interrupt
        is_INT <= '1';
        WAIT FOR clk_period;
        is_INT <= '0';

        -- Simulate a NOP operation
        is_NOP <= '1';
        WAIT FOR clk_period;
        is_NOP <= '0';

        -- End simulation
        WAIT FOR clk_period * 10;
        std.env.stop;
    END PROCESS;

END ARCHITECTURE behavior;