----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/21/2026 11:09:53 AM
-- Design Name: 
-- Module Name: SHAPE_GENERATOR - Behavioral
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
-- 
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

entity SHAPE_GENERATOR is
Port ( 
video_on : in std_logic;
h_count : in std_logic_vector(9 downto 0);
v_count : in std_logic_vector(9 downto 0);
sel_shape : in std_logic_vector (1 downto 0);
fill_shape: in std_logic;
clear: in std_logic;
R_out : out std_logic_vector (3 downto 0);
G_out : out std_logic_vector (3 downto 0);
B_out : out std_logic_vector (3 downto 0)
);
end SHAPE_GENERATOR;

architecture Behavioral of SHAPE_GENERATOR is
--colours
signal black : std_logic_vector (11 downto 0) := (others => '0');
signal white : std_logic_vector (11 downto 0) := (others => '1');



begin

shapes : process (video_on, h_count, v_count, sel_shape, fill_shape, clear)
variable x, y: integer; -- x and y coordinates
variable x_rad, y_rad: integer; -- x and y distance from the centre of the screen
variable draw: std_logic;

begin
-- convert h_count and v_count inputs to mod 10 integers so that it is easier to code
-- note that the display area of the screen is 640 x 480
-- the middle of the screen is (319, 239)
-- (0,0) is top left and y increases downward while x increases rightward
x := to_integer(unsigned(h_count));
y := to_integer(unsigned(v_count));
draw := '0';

    -- outside display area is black
    if video_on = '0' then
        R_out <= black(11 downto 8);
        G_out <= black(7 downto 4);
        B_out <= black(3 downto 0);
    else
       -- inside display area
       
       --clear shapes so that it is just white background
        if clear = '1' then
            R_out <= white(11 downto 8);
            G_out <= white(7 downto 4);
            B_out <= white(3 downto 0);
            
 
        else
            --draw shapes inside display area  
            case(sel_shape) is
                when "00" => 
                    -- rectangle 
                    if fill_shape = '1' then
                    -- rectangle is filled
                        if (x >= 120 AND x <= 400 AND y >= 60 AND y <= 300) then 
                        --area to draw rectangle
                            draw := '1';
                        end if;
                    else
                    -- hollow rectangle
                        if ((x = 120 OR x = 400) AND (y >= 60 and y <= 300)) OR
                           ((y = 60  OR y = 300) AND (x >= 120 and x <= 400)) then
                    --area to draw rectangle border (1 pixel thick)
                            draw := '1';
                        end if;
                    end if;
                when "01" =>
                    -- triangle (right angled)
                    ---- vertices: (200,300), (440,300), (200,100)
                    if fill_shape = '1' then
                    -- triangle is filled
                        if (x >= 200 AND x<= 440 AND --horizontal bounds
                            y >= 100 AND y <= 300 AND --vertical bounds 
                           (y >= ((x - 200) * 200) / 240 + 100)) then -- hypotenuse
                        --area to draw triangle
                            draw := '1';
                        end if;
                    else
                    -- hollow triangle
                        if ((y = 300 AND x >= 200 AND x <= 440) OR -- horizontal bounds
                            (x = 200 AND y >= 100 AND y <= 300) OR -- vertical bounds
                            (y >= ((x - 200) * 200) / 240 + 99 and --hypotenuse (+/- 1 to account for integer rounding)
                             y <= ((x - 200) * 200) / 240 + 101 and    
                             x >= 200 and x <= 440 and                 -- restrict to horizontal and veritcal bounds
                             y >= 100 and y <= 300)) then
                        --area to draw triangle border (1 pixel thick)
                            draw := '1';
                        end if;
                    end if;
                when "10" =>
                    -- circle
                    -- radius = 100 pixels
                    x_rad := x - 319;
                    y_rad := y - 239;
                    if fill_shape = '1' then
                    -- circle is filled
                        if (x_rad * x_rad + y_rad * y_rad <= 10000) then
                        --area to draw circle
                            draw := '1';
                        end if;
                    else
                    -- hollow circle
                        if ((x_rad * x_rad + y_rad * y_rad >= 9800) AND
                            (x_rad * x_rad + y_rad * y_rad <= 10200)) then
                        --area to draw circle border (1 pixel thick)
                            draw := '1';
                        end if;
                    end if;
                when "11" =>
                    -- diamond
                    x_rad := x - 319;
                    y_rad := y - 239;

                    if fill_shape = '1' then
                        if (abs(x_rad) + abs(y_rad) <= 120) then
                        --area to draw diamond
                            draw := '1';
                        end if;
                    -- diamond is filled
                    else
                    -- hollow diamond
                        if (abs(x_rad) + abs(y_rad) = 120) then
                        --area to draw diamond border (1 pixel thick)
                            draw := '1';
                        end if;
                    end if;
                 when others =>
                    draw := '0';
            end case;
            
            --colour of shapes is black with white background
            if draw = '1' then
                R_out <= black(11 downto 8);
                G_out <= black(7 downto 4);
                B_out <= black(3 downto 0);
            else
                R_out <= white(11 downto 8);
                G_out <= white(7 downto 4);
                B_out <= white(3 downto 0);
            end if;
        end if;
        
    end if; 


end process;


end Behavioral;
