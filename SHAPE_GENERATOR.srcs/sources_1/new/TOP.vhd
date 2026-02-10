----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/21/2026 11:09:53 AM
-- Design Name: 
-- Module Name: TOP - Behavioral
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
-- TOP level design that connects inputs, VGA controller, RGB generator, and outputs together
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
Port ( 
clk : in std_logic;
reset : in std_logic;
select_shape : in std_logic_vector (1 downto 0);
clear : in std_logic;
fill_shape : in std_logic;
R_out : out std_logic_vector (3 downto 0);
G_out : out std_logic_vector (3 downto 0);
B_out : out std_logic_vector (3 downto 0);
h_sync : out std_logic;
v_sync: out std_logic

);
end TOP;

architecture Structural of TOP is

signal vid_on : std_logic;

-- signals to generate 25.173MHz clock
signal pixel_clk : std_logic;
signal locked : std_logic; 
signal reset_g : std_logic;
signal x_coord: std_logic_vector(9 downto 0);
signal y_coord: std_logic_vector(9 downto 0);
begin

--generating a 25.173MHz clock using clock wizard
CLOCK_GEN: entity work.clk_wiz_0
port map (
clk_in1 => clk,
reset => reset,
clk_out1 => pixel_clk,
locked => locked
);

reset_g <= reset OR (NOT locked);

VGA : entity work.VGA_CONTROLLER
port map (
clk => pixel_clk,
reset => reset_g,
h_sync => h_sync,
v_sync => v_sync,
h => x_coord,
v => y_coord,
video_on => vid_on
);

SHAPE : entity work.SHAPE_GENERATOR
port map (
video_on => vid_on,
h_count => x_coord,
v_count => y_coord,
sel_shape => select_shape,
fill_shape => fill_shape,
clear => clear,
R_out => R_out,
G_out => G_out,
B_out => B_out
);

end Structural;
