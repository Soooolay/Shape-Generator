----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/21/2026 11:09:53 AM
-- Design Name: 
-- Module Name: VGA_CONTROLLER - Behavioral
-- Project Name: SHAPE_GENERATOR
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_CONTROLLER is
Port ( 
    clk : in std_logic;
    reset: in std_logic;
    h_sync : out std_logic;
    v_sync : out std_logic;
    h : out std_logic_vector(9 downto 0);
    v : out std_logic_vector(9 downto 0);
    video_on : out std_logic
);
end VGA_CONTROLLER;

architecture Behavioral of VGA_CONTROLLER is


signal h_count : integer range 0 to 799 := 0;
signal v_count : integer range 0 to 524 := 0;
signal eol : std_logic := '0';



begin


--horizontal counter

process(clk, reset)
begin
    if reset = '1' then
        h_count <= 0;
        eol     <= '0';
    elsif rising_edge(clk) then
        if h_count = 799 then
            h_count <= 0;
            eol     <= '1';   -- end of line pulse
        else
            h_count <= h_count + 1;
            eol     <= '0';
        end if;
    end if;
end process;

--vertical counter
        
process(clk, reset)
begin
    if reset = '1' then
        v_count <= 0;
    elsif rising_edge(clk) then
        if eol = '1' then
            if v_count = 524 then
                v_count <= 0;
            else
                v_count <= v_count + 1;
            end if;
        end if;
    end if;
end process;

-- output values of counters

h <= std_logic_vector(to_unsigned(h_count, 10));
v <= std_logic_vector(to_unsigned(v_count, 10));


-- compartators

--h_sync comparator:
process(clk, reset)
begin
    if reset = '1' then
        h_sync <= '1';
    elsif rising_edge(clk) then
        if (h_count>= 656) AND (h_count <= 751 ) then
            h_sync <= '0';
        else
            h_sync <= '1';
        end if;
    end if;    
end process;

--v_sync comparator:
process(clk, reset)
begin
    if reset = '1' then
        v_sync <= '1';
    elsif rising_edge(clk) then
        if (v_count >= 490) AND (v_count <= 491 ) then
            v_sync <= '0';
        else
            v_sync <= '1';
        end if;
    end if;    
end process;

--display area:

process(clk, reset)
begin
    if reset = '1' then
        video_on <= '0';
    elsif rising_edge(clk) then
        if (h_count < 640) AND (v_count < 480 ) then
                video_on <= '1';
        else
            video_on <= '0';
       end if;
    end if;  
end process;

end Behavioral;
