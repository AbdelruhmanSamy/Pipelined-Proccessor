library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ID_EX is
    Port (
        clk : in STD_LOGIC;                 -- Clock signal
        rst : in STD_LOGIC;                 -- Reset signal
        -- Inputs from the previous pipeline stage (ID stage)
        instruction : in STD_LOGIC_VECTOR(15 downto 0); -- Instruction (16-bit opcode)
        Rsrc1_in : in STD_LOGIC_VECTOR(15 downto 0);     -- Source register 1
        Rsrc2_in : in STD_LOGIC_VECTOR(15 downto 0);     -- Source register 2
        Rdst_in : in STD_LOGIC_VECTOR(15 downto 0);      -- Destination register
        -- immediate_in : in STD_LOGIC_VECTOR(15 downto 0); -- Immediate value
        Flags_Sel_in : in STD_LOGIC_VECTOR(1 downto 0);  -- Flag selection signal
        SP_EA_in : in STD_LOGIC_VECTOR(15 downto 0);     -- Stack pointer effective address
        WB_in : in STD_LOGIC;                         -- Write-back signal
        MEMRd_in : in STD_LOGIC;                      -- Memory read signal
        MEMWr_in : in STD_LOGIC;                      -- Memory write signal
        MEMToReg_in : in STD_LOGIC;                    -- Memory to register control signal
        ALUSrc_in : in STD_LOGIC;                     -- ALU source selection
        Inc_in : in STD_LOGIC;                     -- ALU source selection
        SPInc_in : in STD_LOGIC;                      -- Stack pointer increment signal
        SPDec_in : in STD_LOGIC;                      -- Stack pointer decrement signal
        EXE_in : in STD_LOGIC_VECTOR(2 downto 0);     -- Execution operation type

        -- Outputs to the next pipeline stage (EX stage)
        instruction_out : out STD_LOGIC_VECTOR(15 downto 0); -- Instruction
        Rsrc1_out : out STD_LOGIC_VECTOR(15 downto 0);        -- Source register 1
        Rsrc2_out : out STD_LOGIC_VECTOR(15 downto 0);        -- Source register 2
        Rdst_out : out STD_LOGIC_VECTOR(15 downto 0);         -- Destination register
        Flags_Sel_out : out STD_LOGIC_VECTOR(1 downto 0);     -- Flag operation selection
        SP_EA_out : out STD_LOGIC_VECTOR(15 downto 0);        -- Stack pointer effective address
        WB_out : out STD_LOGIC;                            -- Write-back control signal
        MEMRd_out : out STD_LOGIC;                         -- Memory read control signal
        MEMWr_out : out STD_LOGIC;                         -- Memory write control signal
        MEMToReg_out : out STD_LOGIC;                       -- Memory to register control signal
        ALUSrc_out : out STD_LOGIC;                        -- ALU source selection
        Inc_out : out STD_LOGIC;                        -- ALU source selection
        SPInc_out : out STD_LOGIC;                         -- Stack pointer increment signal
        SPDec_out : out STD_LOGIC;                         -- Stack pointer decrement signal
        EXE_out : out STD_LOGIC_VECTOR(2 downto 0)         -- Execution operation type
    );
end ID_EX;

architecture Behavioral of ID_EX is
    -- Internal signals to store values from the ID stage
    signal instruction_sig : STD_LOGIC_VECTOR(15 downto 0);
    signal Rsrc1_sig, Rsrc2_sig, Rdst_sig : STD_LOGIC_VECTOR(15 downto 0);
    signal Flags_Sel_sig : STD_LOGIC_VECTOR(1 downto 0);
    signal SP_EA_sig : STD_LOGIC_VECTOR(15 downto 0);
    signal WB_sig, MEMRd_sig, MEMWr_sig, MEMToReg_sig : STD_LOGIC;
    signal ALUSrc_sig, Inc_sig, SPInc_sig, SPDec_sig : STD_LOGIC;
    signal EXE_sig : STD_LOGIC_VECTOR(2 downto 0);

begin
    -- Process to update the pipeline registers at each clock cycle
    process(clk, rst)
    begin
        if rst = '1' then
            -- Reset the pipeline registers
            instruction_sig <= (others => '0');
            Rsrc1_sig <= (others => '0');
            Rsrc2_sig <= (others => '0');
            Rdst_sig <= (others => '0');
            Flags_Sel_sig <= (others => '0');
            SP_EA_sig <= (others => '0');
            WB_sig <= '0';
            MEMRd_sig <= '0';
            MEMWr_sig <= '0';
            MEMToReg_sig <= '0';
            ALUSrc_sig <= '0';
            Inc_sig <= '0';
            SPInc_sig <= '0';
            SPDec_sig <= '0';
            EXE_sig <= "000"; -- Default execution operation
        elsif rising_edge(clk) then
            -- Capture inputs on rising edge of clock
            instruction_sig <= instruction;
            Rsrc1_sig <= Rsrc1_in;
            Rsrc2_sig <= Rsrc2_in;
            Rdst_sig <= Rdst_in;
            Flags_Sel_sig <= Flags_Sel_in;
            SP_EA_sig <= SP_EA_in;
            WB_sig <= WB_in;
            MEMRd_sig <= MEMRd_in;
            MEMWr_sig <= MEMWr_in;
            MEMToReg_sig <= MEMToReg_in;
            ALUSrc_sig <= ALUSrc_in;
            Inc_sig <= Inc_in;
            SPInc_sig <= SPInc_in;
            SPDec_sig <= SPDec_in;
            EXE_sig <= EXE_in;
        end if;
    end process;

    -- Assign internal signals to the outputs for the next pipeline stage (EX)
    instruction_out <= instruction_sig;
    Rsrc1_out <= Rsrc1_sig;
    Rsrc2_out <= Rsrc2_sig;
    Rdst_out <= Rdst_sig;
    Flags_Sel_out <= Flags_Sel_sig;
    SP_EA_out <= SP_EA_sig;
    WB_out <= WB_sig;
    MEMRd_out <= MEMRd_sig;
    MEMWr_out <= MEMWr_sig;
    MEMToReg_out <= MEMToReg_sig;
    ALUSrc_out <= ALUSrc_sig;
    Inc_out <= Inc_sig;
    SPInc_out <= SPInc_sig;
    SPDec_out <= SPDec_sig;
    EXE_out <= EXE_sig;

end Behavioral;
