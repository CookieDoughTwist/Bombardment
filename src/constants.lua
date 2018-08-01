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
SCROLL_SPEED = 10       -- scroll speed (bits/frame)
ZOOM_RATIO = 2         -- the ratio increment to zoom
ZOOM_MAX = 100          -- max zoom out (meters/bit)
ZOOM_MIN = 1            -- min zoom out (meters/bit)
ROTATION_SPEED = math.rad(1)    -- rotation rate (radians/frame)