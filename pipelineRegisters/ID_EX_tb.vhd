library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ID_EX is
end tb_ID_EX;

architecture behavior of tb_ID_EX is
    -- Component declaration for the Unit Under Test (UUT)
    component ID_EX
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            instruction : in STD_LOGIC_VECTOR(15 downto 0);
            Rsrc1_in : in STD_LOGIC_VECTOR(15 downto 0);
            Rsrc2_in : in STD_LOGIC_VECTOR(15 downto 0);
            Rdst_in : in STD_LOGIC_VECTOR(15 downto 0);
            Flags_Sel_in : in STD_LOGIC_VECTOR(1 downto 0);
            SP_EA_in : in STD_LOGIC_VECTOR(15 downto 0);
            WB_in : in STD_LOGIC;
            MEMRd_in : in STD_LOGIC;
            MEMWr_in : in STD_LOGIC;
            MEMToReg_in : in STD_LOGIC;
            ALUSrc_in : in STD_LOGIC;
            Inc_in : in STD_LOGIC;
            SPInc_in : in STD_LOGIC;
            SPDec_in : in STD_LOGIC;
            EXE_in : in STD_LOGIC_VECTOR(2 downto 0);
            instruction_out : out STD_LOGIC_VECTOR(15 downto 0);
            Rsrc1_out : out STD_LOGIC_VECTOR(15 downto 0);
            Rsrc2_out : out STD_LOGIC_VECTOR(15 downto 0);
            Rdst_out : out STD_LOGIC_VECTOR(15 downto 0);
            Flags_Sel_out : out STD_LOGIC_VECTOR(1 downto 0);
            SP_EA_out : out STD_LOGIC_VECTOR(15 downto 0);
            WB_out : out STD_LOGIC;
            MEMRd_out : out STD_LOGIC;
            MEMWr_out : out STD_LOGIC;
            MEMToReg_out : out STD_LOGIC;
            ALUSrc_out : out STD_LOGIC;
            Inc_out : out STD_LOGIC;
            SPInc_out : out STD_LOGIC;
            SPDec_out : out STD_LOGIC;
            EXE_out : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    -- Signal declarations for UUT connections
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    signal instruction : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal Rsrc1_in : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal Rsrc2_in : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal Rdst_in : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal Flags_Sel_in : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal SP_EA_in : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal WB_in : STD_LOGIC := '0';
    signal MEMRd_in : STD_LOGIC := '0';
    signal MEMWr_in : STD_LOGIC := '0';
    signal MEMToReg_in : STD_LOGIC := '0';
    signal ALUSrc_in : STD_LOGIC := '0';
    signal Inc_in : STD_LOGIC := '0';
    signal SPInc_in : STD_LOGIC := '0';
    signal SPDec_in : STD_LOGIC := '0';
    signal EXE_in : STD_LOGIC_VECTOR(2 downto 0) := "000";

    -- Outputs from UUT
    signal instruction_out : STD_LOGIC_VECTOR(15 downto 0);
    signal Rsrc1_out : STD_LOGIC_VECTOR(15 downto 0);
    signal Rsrc2_out : STD_LOGIC_VECTOR(15 downto 0);
    signal Rdst_out : STD_LOGIC_VECTOR(15 downto 0);
    signal Flags_Sel_out : STD_LOGIC_VECTOR(1 downto 0);
    signal SP_EA_out : STD_LOGIC_VECTOR(15 downto 0);
    signal WB_out : STD_LOGIC;
    signal MEMRd_out : STD_LOGIC;
    signal MEMWr_out : STD_LOGIC;
    signal MEMToReg_out : STD_LOGIC;
    signal ALUSrc_out : STD_LOGIC;
    signal Inc_out : STD_LOGIC;
    signal SPInc_out : STD_LOGIC;
    signal SPDec_out : STD_LOGIC;
    signal EXE_out : STD_LOGIC_VECTOR(2 downto 0);

    -- Clock generation
    constant clk_period : time := 100 ps;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: ID_EX
        Port map (
            clk => clk,
            rst => rst,
            instruction => instruction,
            Rsrc1_in => Rsrc1_in,
            Rsrc2_in => Rsrc2_in,
            Rdst_in => Rdst_in,
            Flags_Sel_in => Flags_Sel_in,
            SP_EA_in => SP_EA_in,
            WB_in => WB_in,
            MEMRd_in => MEMRd_in,
            MEMWr_in => MEMWr_in,
            MEMToReg_in => MEMToReg_in,
            ALUSrc_in => ALUSrc_in,
            Inc_in => Inc_in,
            SPInc_in => SPInc_in,
            SPDec_in => SPDec_in,
            EXE_in => EXE_in,
            instruction_out => instruction_out,
            Rsrc1_out => Rsrc1_out,
            Rsrc2_out => Rsrc2_out,
            Rdst_out => Rdst_out,
            Flags_Sel_out => Flags_Sel_out,
            SP_EA_out => SP_EA_out,
            WB_out => WB_out,
            MEMRd_out => MEMRd_out,
            MEMWr_out => MEMWr_out,
            MEMToReg_out => MEMToReg_out,
            ALUSrc_out => ALUSrc_out,
            Inc_out => Inc_out,
            SPInc_out => SPInc_out,
            SPDec_out => SPDec_out,
            EXE_out => EXE_out
        );

    -- Clock process
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Test case 1: Reset the pipeline register
        -- Apply reset to check if all outputs are cleared
        rst <= '1';
        wait for 200 ps;
        rst <= '0';
        wait for clk_period;

        -- Assertion for Reset Test Case
        assert (instruction_out = "0000000000000000") report "Reset: instruction_out failed" severity error;
        assert (Rsrc1_out = "0000000000000000") report "Reset: Rsrc1_out failed" severity error;
        assert (Rsrc2_out = "0000000000000000") report "Reset: Rsrc2_out failed" severity error;
        assert (Rdst_out = "0000000000000000") report "Reset: Rdst_out failed" severity error;
        assert (Flags_Sel_out = "00") report "Reset: Flags_Sel_out failed" severity error;
        assert (SP_EA_out = "0000000000000000") report "Reset: SP_EA_out failed" severity error;
        assert (WB_out = '0') report "Reset: WB_out failed" severity error;

        -- Test case 2: Provide instruction and control signals after reset
        instruction <= "0000000000001001"; -- Some opcode
        Rsrc1_in <= "0000000000000010";   -- Source Register 1
        Rsrc2_in <= "0000000000000011";   -- Source Register 2
        Rdst_in <= "0000000000000100";    -- Destination Register
        Flags_Sel_in <= "01";             -- Flag selection
        SP_EA_in <= "0000000000001010";   -- Stack Pointer Effective Address
        WB_in <= '1';
        MEMRd_in <= '0';
        MEMWr_in <= '1';
        MEMToReg_in <= '0';
        ALUSrc_in <= '1';
        Inc_in <= '0';
        SPInc_in <= '1';
        SPDec_in <= '0';
        EXE_in <= "101";                 -- Some execution type

        wait for clk_period;

        -- Assertions for Instruction and Control Signals
        assert (instruction_out = "0000000000001001") report "Test 2: instruction_out failed" severity error;
        assert (Rsrc1_out = "0000000000000010") report "Test 2: Rsrc1_out failed" severity error;
        assert (Rsrc2_out = "0000000000000011") report "Test 2: Rsrc2_out failed" severity error;
        assert (Rdst_out = "0000000000000100") report "Test 2: Rdst_out failed" severity error;
        assert (Flags_Sel_out = "01") report "Test 2: Flags_Sel_out failed" severity error;
        assert (SP_EA_out = "0000000000001010") report "Test 2: SP_EA_out failed" severity error;
        assert (WB_out = '1') report "Test 2: WB_out failed" severity error;
        
        -- Test case 3: Check No Operation (NOP)
        WB_in <= '0';
        MEMRd_in <= '0';
        MEMWr_in <= '0';
        MEMToReg_in <= '0';
        ALUSrc_in <= '0';
        Inc_in <= '0';
        SPInc_in <= '0';
        SPDec_in <= '0';
        EXE_in <= "000";  -- NOP
        
        wait for clk_period;
        
        -- Assertions for NOP Test
        assert (instruction_out = "0000000000001001") report "Test 3: instruction_out failed" severity error;
        assert (Rsrc1_out = "0000000000000010") report "Test 3: Rsrc1_out failed" severity error;
        assert (Rsrc2_out = "0000000000000011") report "Test 3: Rsrc2_out failed" severity error;
        
        -- Add similar assertions for other test cases
        
        -- Test case 4: Stack pointer increment and decrement signals
        SPInc_in <= '1';
        SPDec_in <= '1';
        wait for clk_period;

        assert (SPInc_out = '1') report "Test 4: SPInc_out failed" severity error;
        assert (SPDec_out = '1') report "Test 4: SPDec_out failed" severity error;

        -- Test case 5: ALU source selection toggling
        ALUSrc_in <= '1';  -- Use immediate value for ALU
        wait for clk_period;
        ALUSrc_in <= '0';  -- Use registers for ALU
        wait for clk_period;

        -- Test case 6: Multiple control signals
        WB_in <= '1';
        MEMRd_in <= '1';
        MEMWr_in <= '0';
        MEMToReg_in <= '1';
        ALUSrc_in <= '1';
        Inc_in <= '1';
        SPInc_in <= '1';
        SPDec_in <= '0';
        EXE_in <= "110";  -- Some operation
        wait for clk_period;

        -- Test case 7: Change instruction and control signals
        instruction <= "0000000000001111"; -- Another opcode
        Rsrc1_in <= "0000000000001010";   -- Another register
        Rsrc2_in <= "0000000000001100";   -- Another register
        Rdst_in <= "0000000000001110";    -- Another destination register
        Flags_Sel_in <= "11";             -- Another flag selection
        SP_EA_in <= "0000000000001111";   -- Another stack pointer address
        WB_in <= '1';
        MEMRd_in <= '0';
        MEMWr_in <= '0';
        MEMToReg_in <= '0';
        ALUSrc_in <= '0';
        Inc_in <= '0';
        SPInc_in <= '1';
        SPDec_in <= '0';
        EXE_in <= "001";                 -- Some execution type

        wait for clk_period;

        -- Test complete, stop the simulation
        assert false report "Test completed successfully" severity note;
        wait;
    end process;

end behavior;
