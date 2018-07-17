--[[
    Bombardment

    Author: Andrew Wang
    andrew01810@gmail.com

    
]]

-- initialize our nearest-neighbor filter
--love.graphics.setDefaultFilter('nearest', 'nearest')

-- this time, we're keeping all requires and assets in our Dependencies.lua file
require 'src/Dependencies'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


function love.load()
    
    -- window bar title
    love.window.setTitle('Bombardment')

    -- seed the RNG
    math.randomseed(os.time())

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })

    -- set music to loop and start
    --gSounds['music']:setLooping(true)
    --gSounds['music']:play()

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleState() end
        --['begin-game'] = function() return BeginGameState() end,
        --['play'] = function() return PlayState() end,
        --['game-over'] = function() return GameOverState() end
    }
    gStateMachine:change('title')

    -- keep track of scrolling our background on the X axis
    backgroundX = 0

    -- initialize input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mousepressed(x, y, button)    
    gameX, gameY = push:toGame(x, y)
    love.mouse.buttonPressed[button] = {gameX, gameY}
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonPressed[button]
end

function love.update(dt)

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.buttonPressed = {}
    
    -- update global tween timer
    Timer.update(dt)
end

function love.draw()
    
    push:start()
    
    gStateMachine:render()
    push:finish()
end