--[[

]]

Engine = Class{}

function Engine:init(index)

    -- holds the state of the universe
    self.universe = Universe()
    --self.universe:loadScenario('simple_orbit')
    --self.universe:loadScenario('multi_orbit')
    --self.universe:loadScenario('test_planetoid')
    --self.universe:loadScenario('no_bodies')
    self.universe:loadScenario('getting_started')

    self.state = ''
    self.stateMachine = StateMachine {
        ['focus'] = function() return EngineFocusState(self) end,
        ['map'] = function() return EngineMapState(self) end
    }

    -- start in focus state
    self:changeState('focus', {})

    -- background tracker
    self.background = BACKGROUND_TAGS[math.random(#BACKGROUND_TAGS)]
    self.backgroundOrientation = math.random() * TWO_PI

    -- pause tracker
    self.paused = false
end

function Engine:changeState(name, params)
    
    self.stateMachine:change(name, params)
end

function Engine:update(dt)

    if love.keyboard.wasPressed('space') then
        self.paused = not self.paused
    end

    if not self.paused then
        -- update the universe
        -- only responsible for incrementing physics
        self.universe:update(dt)
    end

    -- state machine handles all external inputs
    -- this includes player control (any changes applied next step)
    self.stateMachine:update(dt)
end

function Engine:render()
    
    -- TODO: pull out common render code from states 8/8/18 -AW

    -- state machine handles all rendering
    self.stateMachine:render()
end