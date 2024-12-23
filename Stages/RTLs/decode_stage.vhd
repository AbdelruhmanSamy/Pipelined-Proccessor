LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY decode_stage IS
    GENERIC (
        REGISTER_SIZE : INTEGER := 16;
        REGISTER_NUMBER : INTEGER := 8
    );
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        fetched_opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        fetched_instruction : IN STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
        reg_write : IN STD_LOGIC;
        write_back_address : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        write_back_data : IN STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
        input_for_input_port : IN STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
        is_input_port : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        read_data_1 : OUT STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0);
        read_data_2 : OUT STD_LOGIC_VECTOR(REGISTER_SIZE - 1 DOWNTO 0)
    );
END ENTITY decode_stage;

ARCHITECTURE decode_stage_architecture OF decode_stage IS

    COMPONENT register_file IS
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
            DATA_SIZE : INTEGER := REGISTER_SIZE
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            INPUT : IN STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
            OUTPUT : OUT STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0)
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

    register_file_instance : register_file
    PORT MAP(
        write_enable => reg_write,
        clk => clk,
        reset => reset,
        read_address1 => fetched_instruction(2 DOWNTO 0),
        read_address2 => fetched_instruction(5 DOWNTO 3),
        write_address => write_back_address,
        write_data => write_back_data,
        read_data1 => temp_data_1,
        read_data2 => read_data_2
    );

    input_port_instance : input_port
    PORT MAP(
        clk => clk,
        reset => reset,
        INPUT => input_for_input_port,
        OUTPUT => temp_input_port_output
    );

    input_mux <= temp_input_port_output & temp_data_1;

    input_port_mux_instance : generic_mux
    PORT MAP(
        inputs => input_mux,
        sel => is_input_port,
        outputs => read_data_1
    );

END ARCHITECTURE decode_stage_architecture;