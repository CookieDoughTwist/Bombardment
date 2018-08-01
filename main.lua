--[[
    Bombardment

    Author: Andrew Wang
    andrew01810@gmail.com

    
]]

-- initialize our nearest-neighbor filter
--love.graphics.setDefaultFilter('nearest', 'nearest')

-- requires and resource initializations
require 'src/Dependencies'

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
    gSounds['spacebg']:setLooping(true)
    gSounds['spacebg']:play()

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleState() end,
        ['select'] = function() return SelectionState() end,
        ['play'] = function() return PlayState() end
        --['begin-game'] = function() return BeginGameState() end,
        --['play'] = function() return PlayState() end,
        --['game-over'] = function() return GameOverState() end
    }
    gStateMachine:change('title')

    -- initialize input table
    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
    love.bindings = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
    if key == 'enter' or key == 'return' or key == 'kpenter' or key == 'space' then
        love.bindings['select'] = true
    end
    if key == '=' or key == 'kp+' then
        love.bindings['increment'] = true
    end
    if key == '-' or key == 'kp-' then
        love.bindings['decrement'] = true
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mousepressed(x, y, button)    
    gameX, gameY = push:toGame(x, y)
    love.mouse.buttonsPressed[button] = {gameX, gameY}
end

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.wheelmoved(x, y)
    if y > 0 then
        love.mouse.buttonsPressed['wheelup'] = y
        love.bindings['increment'] = true
    elseif y < 0 then
        love.mouse.buttonsPressed['wheeldown'] = y
        love.bindings['decrement'] = true
    end
end

function love.wasPressed(key)
    return love.bindings[key]
end

function love.update(dt)

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
    love.bindings = {}
    
    -- update global tween timer
    Timer.update(dt)
end

function love.draw()
    
    push:start()
    
    gStateMachine:render()
    
    push:finish()
end