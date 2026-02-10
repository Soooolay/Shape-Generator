library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_VGA_CONTROLLER is
end TB_VGA_CONTROLLER;

architecture sim of TB_VGA_CONTROLLER is

    -- DUT signals
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '1';
    signal h_sync   : std_logic;
    signal v_sync   : std_logic;
    signal h        : std_logic_vector(9 downto 0);
    signal v        : std_logic_vector(9 downto 0);
    signal video_on : std_logic;

    constant CLK_PERIOD : time := 40 ns; -- 25 MHz

begin

    -- Clock generation
    clk <= not clk after CLK_PERIOD/2;

    -- DUT instantiation
    DUT: entity work.VGA_CONTROLLER
        port map (
            clk      => clk,
            reset    => reset,
            h_sync   => h_sync,
            v_sync   => v_sync,
            h        => h,
            v        => v,
            video_on => video_on
        );

    -- Test process
    stimulus : process
        variable h_int : integer;
        variable v_int : integer;
    begin
        -- Reset

        reset <= '1';
        wait for 5 * CLK_PERIOD;
        reset <= '0';


        -- Check horizontal counter wrap
        wait until rising_edge(clk);
        for i in 0 to 800 loop
            wait until rising_edge(clk);
        end loop;

        h_int := to_integer(unsigned(h));
        assert h_int = 0
            report "FAIL: h_count did not wrap to 0 at 799"
            severity failure;

        -- Check vertical counter increment
        v_int := to_integer(unsigned(v));
        wait until rising_edge(clk); -- after one full line

        assert to_integer(unsigned(v)) = v_int + 1
            report "FAIL: v_count did not increment on EOL"
            severity failure;

        -- Check h_sync timing
        wait until to_integer(unsigned(h)) = 656;
        wait until rising_edge(clk);
        assert h_sync = '0'
            report "FAIL: h_sync not low during sync pulse"
            severity failure;

        wait until to_integer(unsigned(h)) = 752;
        wait until rising_edge(clk);
        assert h_sync = '1'
            report "FAIL: h_sync did not return high"
            severity failure;

        -- Check v_sync timing
        wait until to_integer(unsigned(v)) = 490;
        wait until rising_edge(clk);
        assert v_sync = '0'
            report "FAIL: v_sync not low during sync pulse"
            severity failure;

        wait until to_integer(unsigned(v)) = 492;
        wait until rising_edge(clk);
        assert v_sync = '1'
            report "FAIL: v_sync did not return high"
            severity failure;

        -- Check video_on region
        wait until to_integer(unsigned(h)) = 100 and
                   to_integer(unsigned(v)) = 100;
        wait until rising_edge(clk);
        assert video_on = '1'
            report "FAIL: video_on should be high in active area"
            severity failure;

        wait until to_integer(unsigned(h)) = 700;
        wait until rising_edge(clk);
        assert video_on = '0'
            report "FAIL: video_on should be low outside active area"
            severity failure;

        -- PASS
        report "*** VGA_CONTROLLER TEST PASSED ***"
            severity warning;

        wait;
    end process;

end sim;
