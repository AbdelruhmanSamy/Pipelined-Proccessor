LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY exe_stage IS
    PORT (
        EXE_IN : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        operand1, operand2, immediate_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ALUSrc, Inc : IN STD_LOGIC;

        memory_address, memory_data, immediate_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END exe_stage;

ARCHITECTURE rtl OF exe_stage IS

    COMPONENT generic_mux IS
        GENERIC (
            M : POSITIVE := 2; -- Width of each input, default is 2 bits
            N : POSITIVE := 4; -- Number of inputs, default is 4 inputs
            K : POSITIVE := 2 -- Number of select lines, default is 2
        );
        PORT (
            inputs : IN STD_LOGIC_VECTOR(M * N - 1 DOWNTO 0); -- Concatenated input signals
            sel : IN STD_LOGIC_VECTOR(K - 1 DOWNTO 0); -- Select lines
            outputs : OUT STD_LOGIC_VECTOR(M - 1 DOWNTO 0) -- Output signal
        );
    END COMPONENT;

    COMPONENT ALU IS
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
    END COMPONENT;

    SIGNAL one : STD_LOGIC_VECTOR(15 DOWNTO 0) := (0 => '1', OTHERS => '0');
    SIGNAL inc_mux_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL second_operand_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL alu_result_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL output_flags_sig : STD_LOGIC_VECTOR(2 DOWNTO 0);

    SIGNAL inc_mux_inputs : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL second_operand_mux_inputs : STD_LOGIC_VECTOR(31 DOWNTO 0);

    SIGNAL Inc_vector : STD_LOGIC_VECTOR(0 DOWNTO 0);
    SIGNAL ALUSrc_vector : STD_LOGIC_VECTOR(0 DOWNTO 0);
BEGIN
    -- Fixed signal assignments
    Inc_vector(0) <= Inc;
    ALUSrc_vector(0) <= ALUSrc;

    -- Fixed concatenation order
    inc_mux_inputs <= one & immediate_IN;
    second_operand_mux_inputs <= inc_mux_out & operand2;

    inc_mux : generic_mux
    GENERIC MAP(
        M => 16,
        N => 2,
        K => 1
    )
    PORT MAP(
        inputs => inc_mux_inputs,
        sel => Inc_vector,
        outputs => inc_mux_out
    );

    second_operand_mux : generic_mux
    GENERIC MAP(
        M => 16,
        N => 2,
        K => 1
    )
    PORT MAP(
        inputs => second_operand_mux_inputs,
        sel => ALUSrc_vector,
        outputs => second_operand_sig
    );

    alu_instance : ALU PORT MAP(
        Operand1 => operand1,
        Operand2 => second_operand_sig,
        ALU_Sel => EXE_IN,
        Flags_Sel => '0',
        Flags_Data => (OTHERS => '0'),
        Result => alu_result_sig,
        ZeroFlag => output_flags_sig(0),
        NegFlag => output_flags_sig(1),
        CarryFlag => output_flags_sig(2)
    );

    memory_address <= alu_result_sig;
    memory_data <= operand2;
    immediate_OUT <= immediate_IN;
END ARCHITECTURE;