LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY writeback_stage IS
    PORT (
        MemtoReg : IN STD_LOGIC;
        WB_data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- data from memory
        WB_address : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- data from ALU or immediate value
        Rdst_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WB_data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Rdst_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY writeback_stage;

ARCHITECTURE Behavioral OF writeback_stage IS

    COMPONENT generic_mux
        GENERIC (
            M : POSITIVE := 16;
            N : POSITIVE := 2;
            K : POSITIVE := 1
        );
        PORT (
            inputs : IN STD_LOGIC_VECTOR(M * N - 1 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR(K - 1 DOWNTO 0);
            outputs : OUT STD_LOGIC_VECTOR(M - 1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL mux_inputs : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mux_sel : STD_LOGIC_VECTOR(0 DOWNTO 0);
    SIGNAL mux_output : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    mux_inputs <= WB_data_in & WB_address; -- MEMtoReg = 1 --> WB_data = WB_data_in , else WB_data = WB_address

    mux_sel(0) <= MemtoReg;

    mux_inst : generic_mux
    GENERIC MAP(
        M => 16,
        N => 2,
        K => 1
    )
    PORT MAP(
        inputs => mux_inputs,
        sel => mux_sel,
        outputs => mux_output
    );

    WB_data_out <= mux_output;
    Rdst_out <= Rdst_in;

END ARCHITECTURE Behavioral;