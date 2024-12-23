LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ALU IS
    PORT (
        Operand1 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        Operand2 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        ALU_Sel : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        Flags_Data : IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- passed as Zero &  Neg & Carry
        Flags_Sel : IN STD_LOGIC;
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
        VARIABLE Zero : STD_LOGIC := '0';
        VARIABLE Negative : STD_LOGIC := '0';
        VARIABLE Carry : STD_LOGIC := '0';
    BEGIN
        TempResult := (OTHERS => '0');
        Carry := '0';

        -- ALU Operations
        CASE ALU_Sel IS
            WHEN "000" => -- Pass Operand1
                TempResult := Operand1;

            WHEN "001" => -- Add Operand1 and Operand2
                TempResult := STD_LOGIC_VECTOR(resize(signed(Operand1), 16) + resize(signed(Operand2), 16));
                IF (Operand1(15) = Operand2(15)) AND (Operand1(15) /= TempResult(15)) THEN
                    Carry := '1';
                ELSE
                    Carry := '0';
                END IF;
            WHEN "010" => -- Subtract Operand2 from Operand1
                TempResult := STD_LOGIC_VECTOR(resize(signed(Operand1), 16) - resize(signed(Operand2), 16));
                IF (Operand1(15) /= Operand2(15)) AND (Operand1(15) /= TempResult(15)) THEN
                    Carry := '1';
                ELSE
                    Carry := '0';
                END IF;
            WHEN "011" => -- AND Operand1 and Operand2
                TempResult := Operand1 AND Operand2;

            WHEN "100" => -- NOT Operand1
                TempResult := NOT Operand1;
            WHEN OTHERS =>
                TempResult := (OTHERS => '0');
        END CASE;

        CASE ALU_SEl IS
            WHEN "101" => -- Set Carry Flag
                Carry := '1';
            WHEN OTHERS =>
                NULL;
        END CASE;

        IF to_integer(signed(TempResult)) = 0 THEN
            Zero := '1';
        ELSE
            Zero := '0';
        END IF;

        Negative := TempResult(15);

        -- Flag Operations
        CASE Flags_Sel IS
            WHEN '1' =>
                Zero := Flags_Data(0);
                Negative := Flags_Data(1);
                Carry := Flags_Data(2);
            WHEN OTHERS =>
                NULL;
        END CASE;

        Result <= TempResult;
        ZeroFlag <= Zero;
        NegFlag <= Negative;
        CarryFlag <= Carry;
    END PROCESS;
END Behavioral;