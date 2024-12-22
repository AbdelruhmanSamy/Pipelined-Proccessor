library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC_Handler is
    Port (
        NOP              : in STD_LOGIC;
        reset            : in STD_LOGIC;
        INT              : in STD_LOGIC;
        RTI              : in STD_LOGIC;
        JMP              : in STD_LOGIC;
        RET              : in STD_LOGIC;
        InvMemAddress    : in STD_LOGIC;
        EmptySP          : in STD_LOGIC;
        HLT              : in STD_LOGIC;
        CALL             : in STD_LOGIC;
        JCond            : in STD_LOGIC;
        Selector         : out STD_LOGIC_VECTOR (2 downto 0)
    );
end PC_Handler;

architecture Behavioral of PC_Handler is
begin
    process(NOP, reset, INT, RTI, JMP, RET, InvMemAddress, EmptySP, HLT, CALL, JCond)
    begin
        if JMP = '1' or JCond = '1' or CALL = '1' then
            Selector <= "000";  -- Code for JMP, JCond, CALL
        elsif HLT = '1' then
            Selector <= "001";  -- Code for HLT
        elsif reset = '1' then
            Selector <= "010";  -- Code for reset
        elsif InvMemAddress = '1' then
            Selector <= "011";  -- Code for InvMemAddress
        elsif EmptySP = '1' then
            Selector <= "100";  -- Code for EmptySP
        elsif RET = '1' or RTI = '1' then
            Selector <= "101";  -- Code for RET, RTI
        elsif INT = '1' then
            Selector <= "110";  -- Code for INT
        elsif NOP = '1' then
            Selector <= "111";  -- Code for NOP
        else
            Selector <= "111";  -- Default output (Increment PC normally)
        end if;
    end process;
end Behavioral;
