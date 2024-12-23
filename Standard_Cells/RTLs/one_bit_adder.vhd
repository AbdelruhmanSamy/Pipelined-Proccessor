LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY one_bit_adder IS
    PORT (
        a, b, carry_in : IN STD_LOGIC;
        sum, carry_out : OUT STD_LOGIC
    );
END ENTITY one_bit_adder;

ARCHITECTURE one_bit_adder_architecture OF one_bit_adder IS
BEGIN
    sum <= a XOR b XOR carry_in;
    carry_out <= (a AND b) OR (carry_in AND(b XOR a));
END ARCHITECTURE;