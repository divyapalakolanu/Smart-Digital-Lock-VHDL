library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_digital_lock is
-- Testbenches have no ports
end tb_digital_lock;

architecture Behavioral of tb_digital_lock is
    -- Component Declaration for the Unit Under Test (UUT)
    component digital_lock_top
        Port ( 
            clk        : in  STD_LOGIC;
            reset      : in  STD_LOGIC;
            keypad_in  : in  STD_LOGIC_VECTOR(3 downto 0);
            enter_btn  : in  STD_LOGIC;
            lock_out   : out STD_LOGIC;
            alarm_out  : out STD_LOGIC;
            seg_out    : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    -- Local Signals
    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';
    signal keypad_in  : std_logic_vector(3 downto 0) := "0000";
    signal enter_btn  : std_logic := '0';
    signal lock_out   : std_logic;
    signal alarm_out  : std_logic;
    signal seg_out    : std_logic_vector(6 downto 0);

    constant clk_period : time := 10 ns;

begin
    -- Instantiate the UUT
    uut: digital_lock_top Port map (
          clk => clk, reset => reset, keypad_in => keypad_in,
          enter_btn => enter_btn, lock_out => lock_out,
          alarm_out => alarm_out, seg_out => seg_out
        );

    -- Clock process (heartbeat of the system)
    clk_process :process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    -- Stimulus process (the "Virtual User" typing the password)
    stim_proc: process
    begin		
        -- 1. Hardware Reset
        reset <= '1'; wait for 100 ns;
        reset <= '0'; wait for 100 ns;

        -- THE FIX: Wait for falling edge to avoid race conditions
        wait until falling_edge(clk);

        -- 2. Enter Digit 1 (Password is 1)
        keypad_in <= "0001"; wait for 10 ns;
        enter_btn <= '1';    wait for 40 ns;
        enter_btn <= '0';    wait for 40 ns;

        -- 3. Enter Digit 2 (Password is 2)
        keypad_in <= "0010"; wait for 10 ns;
        enter_btn <= '1';    wait for 40 ns;
        enter_btn <= '0';    wait for 40 ns;

        -- 4. Enter Digit 3 (Password is 3)
        keypad_in <= "0011"; wait for 10 ns;
        enter_btn <= '1';    wait for 40 ns;
        enter_btn <= '0';    wait for 40 ns;

        -- Success: Observe the lock_out signal stay high
        wait for 200 ns;

        wait; -- Stop simulation
    end process;
end Behavioral;