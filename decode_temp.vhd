LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY decode_stage_temp IS
    GENERIC (
        REGISTER_SIZE : INTEGER := 16;
        REGISTER_NUMBER : INTEGER := 8
    );
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        fetched_instruction : IN STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
        reg_write : IN STD_LOGIC;
        write_back_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_back_data : IN STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
        input_port_data : IN STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);

        -- input signals from control unit
        IN_PORT_IN : IN STD_LOGIC_VECTOR(0 DOWNTO 0);

        -- TODO: integrate JMP and CALL instructions
        -- JMP_IN : IN STD_LOGIC;
        -- CALL_IN : IN STD_LOGIC;

        -- Outputs
        read_data_1 : OUT STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
        read_data_2 : OUT STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0)

    );
END ENTITY decode_stage;

ARCHITECTURE decode_stage_architecture OF decode_stage IS

    COMPONENT general_register_file IS
        GENERIC (
            REGISTER_SIZE : INTEGER := REGISTER_SIZE;
            REGISTER_NUMBER : INTEGER := REGISTER_NUMBER
        );
        PORT (
            write_enable, clk, reset : IN STD_LOGIC;
            read_address1, read_address2, write_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            write_data : IN STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
            read_data1, read_data2 : OUT STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT input_port IS
        GENERIC (
            DATA_SIZE : INTEGER := 16
        );
        PORT (
            clk : IN STD_LOGIC; -- Clock signal
            reset : IN STD_LOGIC; -- Reset signal
            data_in : IN STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT generic_mux IS
        GENERIC (
            M : INTEGER := REGISTER_SIZE;
            N : INTEGER := 2;
            K : INTEGER := 1
        );
        PORT (
            inputs : IN STD_LOGIC_VECTOR(M * N - 1 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR(K - 1 DOWNTO 0);
            outputs : OUT STD_LOGIC_VECTOR(M - 1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL temp_data_1 : STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
    SIGNAL input_mux : STD_LOGIC_VECTOR(2 * REGISTER_SIZE - 1 DOWNTO 0);
    SIGNAL temp_input_port_output : STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);

BEGIN
    -- Component instantiations with proper signal assignments
    register_file_instance : general_register_file
    PORT MAP(
        write_enable => reg_write,
        clk => clk,
        reset => reset,
        read_address1 => fetched_instruction(2 DOWNTO 0), -- Use direct input instead of temp signal
        read_address2 => fetched_instruction(5 DOWNTO 3), -- Use direct input instead of temp signal
        write_address => write_back_address,
        write_data => write_back_data,
        read_data1 => temp_data_1,
        read_data2 => read_data_2
    );

    input_port_instance : input_port
    PORT MAP(
        clk => clk,
        reset => reset,
        data_in => input_port_data,
        data_out => temp_input_port_output
    );

    input_mux <= temp_input_port_output & temp_data_1;

    input_port_mux_instance : generic_mux
    PORT MAP(
        inputs => input_mux,
        sel => IN_PORT_IN,
        outputs => read_data_1
    );

END ARCHITECTURE decode_stage_architecture;