LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY forwarding_unit IS
    PORT (
        Rsrc1 : in std_logic_vector(15 downto 0);
        Rsrc2 : in std_logic_vector(15 downto 0);
        memory_address : in std_logic_vector(15 downto 0);
        WB_data : in std_logic_vector(15 downto 0);
       
        FU_signal : out std_logic
    );
END forwarding_unit;
ARCHITECTURE forwarding_unit_architecture OF forwarding_unit IS
BEGIN

    -- TODO: The design doesn't show any specific logic or any other output signals.
    FU_signal <= '1'; -- Where to go 
END forwarding_unit_architecture;