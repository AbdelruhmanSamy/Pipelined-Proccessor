LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ALU_tb IS
END ALU_tb;

ARCHITECTURE Behavioral OF ALU_tb IS
    COMPONENT ALU
        PORT (
            Operand1 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            Operand2 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            ALU_Sel : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            Flags_Sel : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            Result : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
            ZeroFlag : OUT STD_LOGIC;
            NegFlag : OUT STD_LOGIC;
            CarryFlag : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL Operand1 : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Operand2 : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ALU_Sel : STD_LOGIC_VECTOR (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Flags_Sel : STD_LOGIC_VECTOR (2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL Result : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL ZeroFlag : STD_LOGIC;
    SIGNAL NegFlag : STD_LOGIC;
    SIGNAL CarryFlag : STD_LOGIC;

BEGIN
    uut : ALU
    PORT MAP(
        Operand1 => Operand1,
        Operand2 => Operand2,
        ALU_Sel => ALU_Sel,
        Flags_Sel => Flags_Sel,
        Result => Result,
        ZeroFlag => ZeroFlag,
        NegFlag => NegFlag,
        CarryFlag => CarryFlag
    );

    PROCESS
    BEGIN
        -- Test Case 1: NOT Operand1
        Operand1 <= "0000000000001111"; -- Operand1 = 15
        ALU_Sel <= "000";
        WAIT FOR 10 ns;
        ASSERT Result = "1111111111110000" REPORT "Test Case 1 Failed" SEVERITY error;
        ASSERT ZeroFlag = '0' REPORT "Test Case 1 Zero Flag Failed" SEVERITY error;
        ASSERT NegFlag = '1' REPORT "Test Case 1 Negative Flag Failed" SEVERITY error;

        -- Test Case 2: Add Operand1 and Operand2
        Operand1 <= "0000000000010101"; -- Operand1 = 21
        Operand2 <= "0000000000001010"; -- Operand2 = 10
        ALU_Sel <= "001";
        WAIT FOR 10 ns;
        ASSERT Result = "0000000000011111" REPORT "Test Case 2 Failed" SEVERITY error;
        ASSERT CarryFlag = '0' REPORT "Test Case 2 Carry Flag Failed" SEVERITY error;
        ASSERT ZeroFlag = '0' REPORT "Test Case 2 Zero Flag Failed" SEVERITY error;
        ASSERT NegFlag = '0' REPORT "Test Case 2 Negative Flag Failed" SEVERITY error;

        -- Test Case 3: Subtract Operand2 from Operand1
        Operand1 <= "0000000000010101"; -- Operand1 = 21
        Operand2 <= "0000000000001010"; -- Operand2 = 10
        ALU_Sel <= "010";
        WAIT FOR 10 ns;
        ASSERT Result = "0000000000001011" REPORT "Test Case 3 Failed" SEVERITY error;
        ASSERT CarryFlag = '0' REPORT "Test Case 3 Carry Flag Failed" SEVERITY error;
        ASSERT ZeroFlag = '0' REPORT "Test Case 3 Zero Flag Failed" SEVERITY error;
        ASSERT NegFlag = '0' REPORT "Test Case 3 Negative Flag Failed" SEVERITY error;


        -- Test Case 4: Pass Operand1
        Operand1 <= "1111000011110000"; -- Operand1 = -3856 (signed)
        ALU_Sel <= "011";
        WAIT FOR 10 ns;
        ASSERT Result = "1111000011110000" REPORT "Test Case 4 Failed" SEVERITY error;
        ASSERT ZeroFlag = '0' REPORT "Test Case 4 Zero Flag Failed" SEVERITY error;
        ASSERT NegFlag = '1' REPORT "Test Case 4 Negative Flag Failed" SEVERITY error;

        -- Test Case 5: Pass Operand2
        Operand2 <= "0000111100001111"; -- Operand2 = 3855
        ALU_Sel <= "100";
        WAIT FOR 10 ns;
        ASSERT Result = "0000111100001111" REPORT "Test Case 5 Failed" SEVERITY error;
        ASSERT ZeroFlag = '0' REPORT "Test Case 5 Zero Flag Failed" SEVERITY error;
        ASSERT NegFlag = '0' REPORT "Test Case 5 Negative Flag Failed" SEVERITY error;

        -- Test Case 6: AND Operand1 and Operand2
        Operand1 <= "1111111100000000";
        Operand2 <= "0000111111111111";
        ALU_Sel <= "101";
        WAIT FOR 10 ns;
        ASSERT Result = "0000111100000000" REPORT "Test Case 6 Failed" SEVERITY error;
        ASSERT ZeroFlag = '0' REPORT "Test Case 6 Zero Flag Failed" SEVERITY error;
        ASSERT NegFlag = '0' REPORT "Test Case 6 Negative Flag Failed" SEVERITY error;

        -- Test Case 7: Set Carry Flag
        Flags_Sel <= "001";
        WAIT FOR 10 ns;
        ASSERT CarryFlag = '1' REPORT "Test Case 7 Failed" SEVERITY error;
        Flags_Sel <= "111";

        -- Test Case 8: Reset Zero Flag
        Flags_Sel <= "010";
        WAIT FOR 10 ns;
        ASSERT ZeroFlag = '0' REPORT "Test Case 8 Failed" SEVERITY error;
        Flags_Sel <= "111";

        -- Test Case 9: Reset Carry flag
        Flags_Sel <= "011";
        WAIT FOR 10 ns;
        ASSERT CarryFlag = '0' REPORT "Test Case 9 Carry Flag Failed" SEVERITY error;
        Flags_Sel <= "111";

        -- Test Case 9: Reset Negative Flag
        Flags_Sel <= "100";
        WAIT FOR 10 ns;
        ASSERT NegFlag = '0' REPORT "Test Case 9 Negative Flag Failed" SEVERITY error;
        Flags_Sel <= "111";

        -- Test Case 11: Overflow in addition
        Operand1 <= "0111111111111111"; -- Max positive number
        Operand2 <= "0000000000000001"; -- Small positive number
        ALU_Sel <= "001";
        WAIT FOR 20 ns;
        ASSERT Result = "1000000000000000" REPORT "Test Case 11 Addition Overflow Failed" SEVERITY error;
        ASSERT CarryFlag = '1' REPORT "Test Case 11 OverflowFlag Failed" SEVERITY error;
        ASSERT NegFlag = '1' REPORT "Test Case 11 Negative Flag Failed" SEVERITY error;
        ASSERT ZeroFlag = '0' REPORT "Test Case 11 Zero Flag Failed" SEVERITY error;

        -- Test Case 12: Overflow in subtraction
        Operand1 <= "1000000000000000"; -- Max negative number
        Operand2 <= "0000000000000001"; -- Small positive number
        ALU_Sel <= "010";
        WAIT FOR 10 ns;
        ASSERT Result = "0111111111111111" REPORT "Test Case 12 Subtraction Overflow Failed" SEVERITY error;
        ASSERT CarryFlag = '1' REPORT "Test Case 12 OverflowFlag Failed" SEVERITY error;
        ASSERT NegFlag = '0' REPORT "Test Case 12 Negative Flag Failed" SEVERITY error;
        ASSERT ZeroFlag = '0' REPORT "Test Case 12 Zero Flag Failed" SEVERITY error;

        WAIT;
    END PROCESS;

END Behavioral;