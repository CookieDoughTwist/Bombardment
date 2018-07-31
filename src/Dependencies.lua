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

-- universe
require 'src/universe/Universe'
require 'src/universe/Entity'

-- definitions
require 'data/definitions/entity_defs'

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
}

-- fonts
fntLoc = 'resources/fonts/'
gFonts = {
    ['retroblock8'] = love.graphics.newFont(fntLoc .. 'retroblock.ttf', 8),
    ['retroblock16'] = love.graphics.newFont(fntLoc .. 'retroblock.ttf', 16),
    ['retroblock32'] = love.graphics.newFont(fntLoc .. 'retroblock.ttf', 32),
    ['futureearth32'] = love.graphics.newFont(fntLoc .. 'Future-Earth.ttf', 32),
    ['futureearth48'] = love.graphics.newFont(fntLoc .. 'Future-Earth.ttf', 48),
    ['futureearth64'] = love.graphics.newFont(fntLoc .. 'Future-Earth.ttf', 64)
}

    