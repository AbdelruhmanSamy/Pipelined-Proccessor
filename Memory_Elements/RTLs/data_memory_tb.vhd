LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_data_memory IS
END ENTITY tb_data_memory;

ARCHITECTURE behavior OF tb_data_memory IS

    -- Component declaration of the unit under test (UUT)
    COMPONENT data_memory
        PORT (
            ResetMemory : IN STD_LOGIC;
            MemWrite : IN STD_LOGIC;
            MemRead : IN STD_LOGIC;
            Address : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            DataIn : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            DataOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -- Testbench signals
    SIGNAL tb_ResetMemory : STD_LOGIC := '0';
    SIGNAL tb_MemWrite : STD_LOGIC := '0';
    SIGNAL tb_MemRead : STD_LOGIC := '0';
    SIGNAL tb_Address : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tb_DataIn : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tb_DataOut : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: data_memory
        PORT MAP (
            ResetMemory => tb_ResetMemory,
            MemWrite => tb_MemWrite,
            MemRead => tb_MemRead,
            Address => tb_Address,
            DataIn => tb_DataIn,
            DataOut => tb_DataOut
        );

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Initialize signals
        tb_Address <= (OTHERS => '0');  -- Start at address 0
        tb_DataIn <= "0000000000000001";  
        tb_ResetMemory <= '1';  
        WAIT FOR 100 ps; 
        ASSERT tb_DataOut = "0000000000000000" REPORT "Error intitialization" SEVERITY ERROR;
        
        -- Deassert reset and begin normal operations
        tb_ResetMemory <= '0';
        
        tb_MemWrite <= '0';  
        tb_MemRead <= '1';  
        tb_Address <= "000000000011";  
        tb_DataIn <= "0000000111111111"; 
        
        WAIT FOR 100 ps;  
        ASSERT tb_DataOut = "0010011000011111" REPORT "Error at read Address 3  "   SEVERITY ERROR;
        
        tb_MemWrite <= '1';  
        tb_MemRead <= '0';  
        tb_Address <= "000000000011";  
        tb_DataIn <= "0000000111111111"; 
        
        WAIT FOR 100 ps;  
        ASSERT tb_DataOut = "0010011000011111" REPORT "Error dataout should not cahnge when write"   SEVERITY ERROR;
        
        tb_MemWrite <= '0';  
        tb_MemRead <= '1';  
        tb_Address <= "000000000011";  
        tb_DataIn <= "0000000111111111"; 
        
        WAIT FOR 100 ps;  
        ASSERT tb_DataOut = "0000000111111111" REPORT "Error at write Address 3  "   SEVERITY ERROR;
        

        -- Test resetting memory again
        tb_ResetMemory <= '1';  
        WAIT FOR 100 ps;
        ASSERT tb_DataOut = "0000000000000000" REPORT "Error at reset"   SEVERITY ERROR;

        tb_ResetMemory <= '0';  
        tb_MemWrite <= '0';  
        tb_MemRead <= '1';  
        tb_Address <= "000000000010";  
        tb_DataIn <= "0000000111111111";  
        
        WAIT FOR 100 ps; 
        ASSERT tb_DataOut = "0010010000000111" REPORT "Error read after disreset"   SEVERITY ERROR;
        
        -- Finish simulation after performing all operations
        WAIT FOR 100 ps;
        REPORT "Test finished";

        -- End the simulation
        ASSERT FALSE REPORT "End of simulation" SEVERITY NOTE;
        WAIT;  -- Wait indefinitely
    END PROCESS stim_proc;

END ARCHITECTURE behavior;
