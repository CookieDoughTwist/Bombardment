--[[

]]

-- size of our actual window
WINDOW_WIDTH = 1920
WINDOW_HEIGHT = 1080

-- size we're trying to emulate with push
--VIRTUAL_WIDTH = 512
--VIRTUAL_HEIGHT = 288
VIRTUAL_WIDTH = 1024
VIRTUAL_HEIGHT = 576
--VIRTUAL_WIDTH = 1920
--VIRTUAL_HEIGHT = 1080

VIRTUAL_WIDTH_2 = VIRTUAL_WIDTH / 2
VIRTUAL_HEIGHT_2 = VIRTUAL_HEIGHT / 2

RENDER_RANGE = 2000     -- bit radius for render culling (bits)

-- title screen
SHADOW_OFFSET = 5       -- offset of shadow text (bits)
TITLE_DELAY = 2.5       -- time before title fades in (seconds)
TITLE_FADE_IN = 5       -- time for title to fade in (seconds)
ENTER_DELAY = 8         -- time before enter prompt fades in (seconds)
ENTER_FADE_IN = 1.25    
ENTER_PERIOD = 1.25

-- selection screen
SELECTIONS_START = {
    'CAMPAIGN',
    'SANDBOX'
}
MENU_TEXT_JUMP = 48     -- menu option spacing (bits)
MENU_BOX_PAD_X = 10     -- menu box padding (bits)    
MENU_BOX_PAD_Y = -5    -- menu box padding (bits)    
TEXT_BUFFER_X = -2      -- menu horizontal text buffer
TEXT_BUFFER_Y = 2       -- menu vertical text buffer
T_TRANSITION = 0.1        -- time to transition to selection

-- focus state
FOCUS_SCROLL_SPEED = 10         -- scroll speed (bits/frame)
FOCUS_ZOOM_RATIO = 2            -- the ratio increment to zoom
FOCUS_ZOOM_MAX = 128           -- max zoom out (meters/bit)
FOCUS_ZOOM_MIN = 0.25           -- min zoom out (meters/bit)
FOCUS_ROTATION_SPEED = math.rad(1)    -- rotation rate (radians/frame)

-- map state
MAP_SCROLL_SPEED = 10       -- scroll speed (bits/frame)
MAP_ZOOM_RATIO = 2          -- the ratio increment to zoom
MAP_ZOOM_MAX = 2048         -- max zoom out (meters/bit)
MAP_ZOOM_MIN = 256         -- min zoom out (meters/bit)
MAP_ROTATION_SPEED = math.rad(1)    -- rotation rate (radians/frame)

-- physics
G = 6.674E-11           -- gravitational constant
M_SOL = 1.98847E30      -- solar mass