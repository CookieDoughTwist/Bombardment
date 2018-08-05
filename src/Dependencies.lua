--[[
    Bombardment

    Author: Andrew Wang
    andrew01810@gmail.com
]]

-- external libraries
Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

-- utility
require 'src/constants'
require 'src/StateMachine'
require 'src/Util'

-- game states
require 'src/states/game/BaseState'
require 'src/states/game/TitleState'
require 'src/states/game/SelectionState'
require 'src/states/game/PlayState'

-- engine
require 'src/Engine'
require 'src/states/engine/EngineFocusState'
require 'src/states/engine/EngineMapState'

-- universe
require 'src/universe/Universe'
require 'src/universe/Entity'
require 'src/universe/Body'

-- definitions
require 'data/definitions/entity_defs'
require 'data/definitions/body_defs'
require 'data/scenarios/scenario_defs'

-- sounds
sfxLoc = 'resources/sounds/'
gSounds = {
    -- https://freesound.org/people/almusic34/sounds/176682/
    ['spacebg'] = love.audio.newSource(sfxLoc .. 'almusic34_space4.mp3'),
    ['reselect'] = love.audio.newSource(sfxLoc .. 'laserswitch.wav'),
}

-- images
imgLoc = 'resources/graphics/'
gTextures = {
    --https://wallpaper.wiki/download-1080p-space-backgrounds-free.html/wallpaper-wiki-free-download-1080p-space-background-pic-wpd008677/
    ['spacelandbg'] = love.graphics.newImage(imgLoc .. 'spacemountainplanet.png'),
    ['standard_craft'] = love.graphics.newImage(imgLoc .. 'standard_ship_base_red.png'),
    ['large_plume'] = love.graphics.newImage(imgLoc .. 'exaggerated_exhaust_plume.png'),
    --https://www.vectorstock.com/royalty-free-vector/protractor-actual-size-graduation-vector-12617847

}

-- fonts
fntLoc = 'resources/fonts/'
gFonts = {
    ['retroblock8'] = love.graphics.newFont(fntLoc .. 'retroblock.ttf', 8),
    ['retroblock16'] = love.graphics.newFont(fntLoc .. 'retroblock.ttf', 16),
    ['retroblock32'] = love.graphics.newFont(fntLoc .. 'retroblock.ttf', 32),
    ['futureearth32'] = love.graphics.newFont(fntLoc .. 'Future-Earth.ttf', 32),
    ['futureearth48'] = love.graphics.newFont(fntLoc .. 'Future-Earth.ttf', 48),
    ['futureearth64'] = love.graphics.newFont(fntLoc .. 'Future-Earth.ttf', 64),
    -- http://www.fontspace.com/chequered-ink/casanova-scotia
    ['casanovascotia16'] = love.graphics.newFont(fntLoc .. 'Casanova-Scotia.otf', 16),
    ['casanovascotia32'] = love.graphics.newFont(fntLoc .. 'Casanova-Scotia.otf', 32),
}

    