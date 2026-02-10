library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_TOP is
end TB_TOP;

architecture sim of tb_TOP is

    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';

    signal select_shape : std_logic_vector(1 downto 0);
    signal clear        : std_logic;
    signal fill_shape   : std_logic;

    signal R_out, G_out, B_out : std_logic_vector(3 downto 0);
    signal h_sync, v_sync      : std_logic;

    constant CLK_PERIOD : time := 40 ns;

begin
    
    clk <= not clk after CLK_PERIOD/2;

    DUT : entity work.TOP
        port map (
            clk          => clk,
            reset        => reset,
            select_shape => select_shape,
            clear        => clear,
            fill_shape   => fill_shape,
            R_out        => R_out,
            G_out        => G_out,
            B_out        => B_out,
            h_sync       => h_sync,
            v_sync       => v_sync
        );

    process
    begin
 
        assert false
    report "TB_TOP STARTED"
    severity warning;

    
        -- Reset
        reset <= '1';
        clear <= '0';
        fill_shape <= '1';
        select_shape <= "00";
        wait for 200 ns;
        reset <= '0';

        -- Wait into visible region
        wait for 20 ms; -- several frames

        -- Expect active video
        assert R_out /= "UUUU"
            report "FAIL: RGB outputs invalid"
            severity failure;

        -- Clear screen
        clear <= '1';
        wait for 1 ms;

        assert R_out = "1111"
            report "FAIL: Clear not propagating through TOP"
            severity failure;

        -- Shape select
        clear <= '0';
        select_shape <= "10"; -- circle
        wait for 1 ms;

        report "*** TOP LEVEL INTEGRATION TEST PASSED ***"
            severity warning;

        wait;
    end process;

end sim;
