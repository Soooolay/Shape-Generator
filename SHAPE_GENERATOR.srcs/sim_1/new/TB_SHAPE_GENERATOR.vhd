library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_SHAPE_GENERATOR is
end TB_SHAPE_GENERATOR;

architecture sim of TB_SHAPE_GENERATOR is

    signal video_on   : std_logic := '1';
    signal h_count    : std_logic_vector(9 downto 0);
    signal v_count    : std_logic_vector(9 downto 0);
    signal sel_shape  : std_logic_vector(1 downto 0);
    signal fill_shape : std_logic;
    signal clear      : std_logic;
    signal R_out, G_out, B_out : std_logic_vector(3 downto 0);

begin

    DUT : entity work.SHAPE_GENERATOR
        port map (
            video_on   => video_on,
            h_count    => h_count,
            v_count    => v_count,
            sel_shape  => sel_shape,
            fill_shape => fill_shape,
            clear      => clear,
            R_out      => R_out,
            G_out      => G_out,
            B_out      => B_out
        );

    process
    begin
        -- Clear test
        clear <= '1';
        sel_shape <= "00";
        fill_shape <= '1';
        h_count <= std_logic_vector(to_unsigned(200,10));
        v_count <= std_logic_vector(to_unsigned(200,10));
        wait for 10 ns;

        assert R_out = "1111"
            report "FAIL: Clear did not force white"
            severity failure;

        -- Filled rectangle (inside)
        clear <= '0';
        sel_shape <= "00";
        fill_shape <= '1';
        h_count <= std_logic_vector(to_unsigned(200,10));
        v_count <= std_logic_vector(to_unsigned(100,10));
        wait for 10 ns;

        assert R_out = "0000"
            report "FAIL: Filled rectangle pixel not drawn"
            severity failure;


        -- Rectangle (outside)
        h_count <= std_logic_vector(to_unsigned(10,10));
        v_count <= std_logic_vector(to_unsigned(10,10));
        wait for 10 ns;

        assert R_out = "1111"
            report "FAIL: Background not white"
            severity failure;


        -- Filled circle (center)
        sel_shape <= "10";
        fill_shape <= '1';
        h_count <= std_logic_vector(to_unsigned(319,10));
        v_count <= std_logic_vector(to_unsigned(239,10));
        wait for 10 ns;

        assert R_out = "0000"
            report "FAIL: Filled circle center not drawn"
            severity failure;

        -- video_on = 0
 
        video_on <= '0';
        wait for 10 ns;

        assert R_out = "0000"
            report "FAIL: video_on = 0 not forcing black"
            severity failure;

        report "*** SHAPE_GENERATOR TEST PASSED ***"
            severity warning;

        wait;
    end process;

end sim;
