LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY n_bit_adder IS
    GENERIC (n : INTEGER := 16);
    PORT (
        a, b : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        carry_in : IN STD_LOGIC;
        carry_out : OUT STD_LOGIC;
        sum : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0)
    );
END n_bit_adder;

ARCHITECTURE n_bit_adder_architecture OF n_bit_adder IS
    COMPONENT one_bit_adder
        PORT (
            a, b, carry_in : IN STD_LOGIC;
            sum, carry_out : OUT STD_LOGIC);
    END COMPONENT;
    SIGNAL temp_sum : STD_LOGIC_VECTOR(n DOWNTO 0);
BEGIN
    temp_sum(0) <= carry_in;
    lp : FOR i IN 0 TO n - 1 GENERATE
        ux : one_bit_adder
        PORT MAP(
            a => a(i),
            b => b(i),
            carry_in => temp_sum(i),
            sum => sum(i),
            carry_out => temp_sum(i + 1)
        );
    END GENERATE;
    carry_out <= temp_sum(n);
END ARCHITECTURE n_bit_adder_architecture;