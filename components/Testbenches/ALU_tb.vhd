library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_tb is
-- Testbench has no ports
end ALU_tb;

architecture Behavioral of ALU_tb is
    -- Component Declaration
    component ALU
        Port (
            Operand1  : in  STD_LOGIC_VECTOR (15 downto 0);
            Operand2  : in  STD_LOGIC_VECTOR (15 downto 0);
            ALU_Sel   : in  STD_LOGIC_VECTOR (2 downto 0);
            Flags_Sel : in  STD_LOGIC_VECTOR (1 downto 0);
            Result    : out STD_LOGIC_VECTOR (15 downto 0);
            ZeroFlag  : out STD_LOGIC;
            NegFlag   : out STD_LOGIC;
            CarryFlag : out STD_LOGIC
        );
    end component;

    -- Signals to connect to the ALU
    signal Operand1  : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal Operand2  : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal ALU_Sel   : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    signal Flags_Sel : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
    signal Result    : STD_LOGIC_VECTOR (15 downto 0);
    signal ZeroFlag  : STD_LOGIC;
    signal NegFlag   : STD_LOGIC;
    signal CarryFlag : STD_LOGIC;

begin
    -- Instantiate the ALU
    uut: ALU
        Port map (
            Operand1 => Operand1,
            Operand2 => Operand2,
            ALU_Sel => ALU_Sel,
            Flags_Sel => Flags_Sel,
            Result => Result,
            ZeroFlag => ZeroFlag,
            NegFlag => NegFlag,
            CarryFlag => CarryFlag
        );

    -- Test Process
    process
    begin
        -- Test Case 1: NOT Operand1
        Operand1 <= "0000000000001111";  -- Operand1 = 15
        ALU_Sel <= "000";
        wait for 10 ns;
        assert Result = "1111111111110000" report "Test Case 1 Failed" severity error;

        -- Test Case 2: Add Operand1 and Operand2
        Operand1 <= "0000000000010101"; -- Operand1 = 21
        Operand2 <= "0000000000001010"; -- Operand2 = 10
        ALU_Sel <= "001";
        wait for 10 ns;
        assert Result = "0000000000011111" report "Test Case 2 Failed" severity error;
        assert CarryFlag = '0' report "Test Case 2 Carry Flag Failed" severity error;

        -- Test Case 3: Subtract Operand2 from Operand1
        Operand1 <= "0000000000010101"; -- Operand1 = 21
        Operand2 <= "0000000000001010"; -- Operand2 = 10
        ALU_Sel <= "010";
        wait for 10 ns;
        assert Result = "0000000000001011" report "Test Case 3 Failed" severity error;
        assert CarryFlag = '0' report "Test Case 3 Carry Flag Failed" severity error;

        -- Test Case 4: Pass Operand1
        Operand1 <= "1111000011110000";  -- Operand1 = -3856 (signed)
        ALU_Sel <= "011";
        wait for 10 ns;
        assert Result = "1111000011110000" report "Test Case 4 Failed" severity error;

        -- Test Case 5: Pass Operand2
        Operand2 <= "0000111100001111";  -- Operand2 = 3855
        ALU_Sel <= "100";
        wait for 10 ns;
        assert Result = "0000111100001111" report "Test Case 5 Failed" severity error;

        -- Test Case 6: AND Operand1 and Operand2
        Operand1 <= "1111111100000000";
        Operand2 <= "0000111111111111";
        ALU_Sel <= "101";
        wait for 10 ns;
        assert Result = "0000111100000000" report "Test Case 6 Failed" severity error;

        -- Test Case 7: Set Carry Flag
        Flags_Sel <= "01";
        wait for 10 ns;
        assert CarryFlag = '1' report "Test Case 7 Failed" severity error;

        -- Test Case 8: Reset Zero Flag
        Flags_Sel <= "10";
        wait for 10 ns;
        assert ZeroFlag = '0' report "Test Case 8 Failed" severity error;

        -- Test Case 9: Reset Carry and Negative Flags
        Flags_Sel <= "11";
        wait for 10 ns;
        assert CarryFlag = '0' report "Test Case 9 Carry Flag Failed" severity error;
        assert NegFlag = '0' report "Test Case 9 Negative Flag Failed" severity error;

        -- Stop Simulation
        wait;
    end process;

end Behavioral;
