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
require 'src/StateMachine'
require 'src/Util'

-- game states
require 'src/states/BaseState'
require 'src/states/TitleState'

-- sounds
sfxLoc = 'resources/sounds/'
gSounds = {

}

-- images
imgLoc = 'resources/graphics/'
gTextures = {

}

-- fonts
fntLoc = 'resources/fonts/'
gFonts = {
    ['retroblock8'] = love.graphics.newFont(fntLoc .. 'retroblock.ttf', 8),
    ['retroblock16'] = love.graphics.newFont(fntLoc .. 'retroblock.ttf', 16),
    ['retroblock32'] = love.graphics.newFont(fntLoc .. 'retroblock.ttf', 32)
}

    