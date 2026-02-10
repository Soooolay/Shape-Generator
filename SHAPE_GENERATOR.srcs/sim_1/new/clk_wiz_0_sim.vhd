library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_wiz_0 is
    port (
        clk_in1  : in  std_logic;
        reset    : in  std_logic;
        clk_out1 : out std_logic;
        locked   : out std_logic
    );
end clk_wiz_0;

architecture sim of clk_wiz_0 is
begin
    -- Pass-through clock
    clk_out1 <= clk_in1;

    -- Lock after reset is released
    process(clk_in1, reset)
    begin
        if reset = '1' then
            locked <= '0';
        elsif rising_edge(clk_in1) then
            locked <= '1';
        end if;
    end process;
end sim;
