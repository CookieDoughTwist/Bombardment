--[[

]]

-- size of our actual window
WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

-- size we're trying to emulate with push
--VIRTUAL_WIDTH = 512
--VIRTUAL_HEIGHT = 288
--VIRTUAL_WIDTH = 1024
--VIRTUAL_HEIGHT = 576
VIRTUAL_WIDTH = 1920
VIRTUAL_HEIGHT = 1080

VIRTUAL_WIDTH_2 = VIRTUAL_WIDTH / 2
VIRTUAL_HEIGHT_2 = VIRTUAL_HEIGHT / 2

RENDER_RANGE = 4000     -- bit radius for render culling (bits)

-- title screen
SHADOW_OFFSET = 5       -- offset of shadow text (bits)
TITLE_DELAY = 2.5       -- time before title fades in (seconds)
TITLE_FADE_IN = 5       -- time for title to fade in (seconds)
ENTER_DELAY = 8         -- time before enter prompt fades in (seconds)
ENTER_FADE_IN = 1.25    
ENTER_PERIOD = 1.25

-- selection screen
SELECTIONS_START = {
    'GETTING STARTED',
    'GRAVITY IS HARD',
    'THEY CAN SHOOT TOO',
    'SHOW ME YOUR STUFF',
}
-- TODO: modularize selection table
SELECTIONS_TAGS = {
    'getting_started',
    'gravity_is_hard',
    'they_can_shoot_too', 
    'show_me_your_stuff',   
}
MENU_TEXT_JUMP = 96     -- menu option spacing (bits)
MENU_BOX_PAD_X = 25     -- menu box padding (bits)    
MENU_BOX_PAD_Y = 48     -- menu box padding (bits)    
TEXT_BUFFER_X = -2      -- menu horizontal text buffer
TEXT_BUFFER_Y = 0       -- menu vertical text buffer
T_TRANSITION = 0.1      -- time to transition to selection

-- focus state
FOCUS_SCROLL_SPEED = 10         -- scroll speed (bits/frame)
FOCUS_ZOOM_RATIO = 2            -- the ratio increment to zoom
FOCUS_ZOOM_MAX = 16             -- max zoom out (meters/bit)
FOCUS_ZOOM_MIN = 0.125          -- min zoom out (meters/bit)
FOCUS_ROTATION_SPEED = math.rad(1)    -- rotation rate (radians/frame)
CRAFT_THROTTLE_RATE = 0.01       -- percent increment per frame

-- map state
MAP_SCROLL_SPEED = 10       -- scroll speed (bits/frame)
MAP_ZOOM_RATIO = 2          -- the ratio increment to zoom
MAP_ZOOM_MAX = 1024         -- max zoom out (meters/bit)
MAP_ZOOM_MIN = 16           -- min zoom out (meters/bit)
MAP_ROTATION_SPEED = math.rad(1)    -- rotation rate (radians/frame)
CRAFT_RADIUS = 15
CRAFT_EDGE = 8
--[[
CRAFT_VECTOR = {
    -CRAFT_EDGE, -CRAFT_RADIUS,
    CRAFT_EDGE, -CRAFT_RADIUS,
    -CRAFT_EDGE, 2 * CRAFT_RADIUS,
    CRAFT_EDGE, 2 * CRAFT_RADIUS,
}
]]

-- resource constants
IMAGE_MPB = 0.125       -- standard resource meters per bit
BACKGROUND_TAGS = {'b2', 'b7', 'b8', 'b9', 'b10', 'b11'}
--{'b1', 'b2', 'b3', 'b4', 'b5', 'b6', 'b7', 'b8', 'b9', 'b10', 'b11'}
BACKGROUND_DAMPING = 1.001
BACKGROUND_ZOOM = 2
CONVENTIONAL_HIT_SOUNDS = {'conventional_hit1', 'conventional_hit2', 'conventional_hit3'}

-- physics
G = 6.674E-11           -- gravitational constant
M_SOL = 1.98847E30      -- solar mass

-- numbers
PI_2 = math.pi / 2
PI_4 = math.pi / 4
TWO_PI = 2 * math.pi

-- colors
FULL_COLOR = {255, 255, 255, 255}   -- enable all colors and no transparency
CRIMSON = {220, 20, 60}
DARK_ORANGE = {255, 140, 0}
LEMON_CHIFFON = {255, 250, 205}
SKY_BLUE = {135, 206, 250}
ROYAL_PURPLE = {120, 81, 169}
LIGHT_GRAY = {211, 211, 211}
GRAY = {128, 128, 128}
BLACK = {0, 0, 0}

SKY_BLUE_2 = {135, 206, 250, 127}
CRIMSON_2 = {220, 20, 60, 127}

-- game mechanics
DAMAGE_FROM_MOMENTUM = 1E-4     -- damage points per unit momentum (damage/(kg*m/s))