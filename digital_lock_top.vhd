library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- THIS IS THE ENTITY (The Pins)
entity digital_lock_top is
    Port ( 
        clk        : in  STD_LOGIC;          
        reset      : in  STD_LOGIC;          
        keypad_in  : in  STD_LOGIC_VECTOR(3 downto 0); 
        enter_btn  : in  STD_LOGIC;          
        lock_out   : out STD_LOGIC;          
        alarm_out  : out STD_LOGIC;          
        seg_out    : out STD_LOGIC_VECTOR(6 downto 0) 
    );
end digital_lock_top;

-- THIS IS THE ARCHITECTURE (The Logic/Step 4)
architecture Behavioral of digital_lock_top is
    -- We define the "States" the lock can be in
    type state_type is (IDLE, DIGIT1, DIGIT2, DIGIT3, UNLOCKED, ALARM);
    
    -- These signals hold the current and next "Mood" of the lock
    signal current_state, next_state : state_type;
    
    -- This is your Secret Code: 1, 2, 3
    constant PASS1 : std_logic_vector(3 downto 0) := "0001"; 
    constant PASS2 : std_logic_vector(3 downto 0) := "0010"; 
    constant PASS3 : std_logic_vector(3 downto 0) := "0011"; 
begin
-- Process to update current state on clock edge
    sync_process: process(clk, reset)
    begin
        if reset = '1' then
            current_state <= IDLE;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;
    -- Combinational process to determine next state
    comb_process: process(current_state, keypad_in, enter_btn)
    begin
        -- Default assignments
        next_state <= current_state;
        lock_out   <= '0';
        alarm_out  <= '0';

        case current_state is
            when IDLE =>
                if enter_btn = '1' then
                    if keypad_in = PASS1 then next_state <= DIGIT1;
                    else next_state <= ALARM; -- Wrong first digit
                    end if;
                end if;

            when DIGIT1 =>
                if enter_btn = '1' then
                    if keypad_in = PASS2 then next_state <= DIGIT2;
                    else next_state <= ALARM;
                    end if;
                end if;

            when DIGIT2 =>
                if enter_btn = '1' then
                    if keypad_in = PASS3 then next_state <= UNLOCKED;
                    else next_state <= ALARM;
                    end if;
                end if;

            when UNLOCKED =>
                lock_out <= '1';
                -- Stay here until reset is pressed
                next_state <= UNLOCKED;

            when ALARM =>
                alarm_out <= '1';
                -- Stay here until reset is pressed
                next_state <= ALARM;

            when others =>
                next_state <= IDLE;
        end case;
    end process;
    
    -- Simple 7-segment decoder based on state
    with current_state select
        seg_out <= "1110001" when IDLE,     -- Display 'L' (Locked)
                   "1110001" when DIGIT1,   -- Display 'L'
                   "1110001" when DIGIT2,   -- Display 'L'
                   "1000001" when UNLOCKED, -- Display 'U' (Unlocked)
                   "0001000" when ALARM,    -- Display 'A' (Alarm)
                   "1111111" when others;   -- All segments off
end Behavioral;