LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ALU IS
    PORT (
        Operand1 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        Operand2 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        ALU_Sel : IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- 3-bit signal for operation selection
        Flags_Sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0); -- 2-bit signal for flag operations
        Result : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        ZeroFlag : OUT STD_LOGIC;
        NegFlag : OUT STD_LOGIC;
        CarryFlag : OUT STD_LOGIC
    );
END ALU;

ARCHITECTURE Behavioral OF ALU IS

BEGIN
    PROCESS (Operand1, Operand2, ALU_Sel, Flags_Sel)
        VARIABLE TempResult : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
        VARIABLE TempCarry : STD_LOGIC := '0';
        VARIABLE Zero : STD_LOGIC := '0';
        VARIABLE Negative : STD_LOGIC := '0';
        VARIABLE Carry : STD_LOGIC := '0';
    BEGIN
        -- Initialize temporary result and carry
        TempResult := (OTHERS => '0');
        TempCarry := '0';

        -- ALU Operations
        CASE ALU_Sel IS
            WHEN "000" => -- NOT Operand1
                TempResult := NOT Operand1;
            WHEN "001" => -- Add Operand1 and Operand2
                TempResult := STD_LOGIC_VECTOR(resize(signed(Operand1), 16) + resize(signed(Operand2), 16));
                IF (Operand1(15) = Operand2(15)) AND (Operand1(15) /= TempResult(15)) THEN
                    TempCarry := '1';
                ELSE
                    TempCarry := '0';
                END IF;
            WHEN "010" => -- Subtract Operand2 from Operand1
                TempResult := STD_LOGIC_VECTOR(resize(signed(Operand1), 16) - resize(signed(Operand2), 16));
                IF (Operand1(15) /= Operand2(15)) AND (Operand1(15) /= TempResult(15)) THEN
                    TempCarry := '1';
                ELSE
                    TempCarry := '0';
                END IF;
            WHEN "011" => -- Pass Operand1
                TempResult := Operand1;
            WHEN "100" => -- Pass Operand2
                TempResult := Operand2;
            WHEN "101" => -- AND Operand1 and Operand2
                TempResult := Operand1 AND Operand2;
            WHEN OTHERS =>
                TempResult := (OTHERS => '0');
        END CASE;

        IF to_integer(signed(TempResult)) = 0 THEN
            Zero := '1';
        ELSE
            Zero := '0';
        END IF;
        Negative := TempResult(15);

        -- Flag Operations
        CASE Flags_Sel IS
            WHEN "00" => -- No change to flags
                NULL;
            WHEN "01" => -- Set Carry Flag
                Carry := '1';
            WHEN "10" => -- Reset Zero Flag
                Zero := '0';
            WHEN "11" => -- Reset Carry and Negative Flags
                Carry := '0';
                Negative := '0';
            WHEN OTHERS =>
                NULL;
        END CASE;

        Result <= TempResult;
        ZeroFlag <= Zero;
        NegFlag <= Negative;
        CarryFlag <= Carry;
    END PROCESS;
END Behavioral;