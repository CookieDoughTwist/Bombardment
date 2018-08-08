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
require 'src/universe/entity/Addon'
require 'src/universe/entity/C2'

-- definitions
require 'data/definitions/entity_defs'
require 'data/definitions/body_defs'
require 'data/definitions/addon_defs'
require 'data/scenarios/scenario_defs'

-- sounds
sfxLoc = 'resources/sounds/'
gSounds = {
    -- https://freesound.org/people/almusic34/sounds/176682/
    ['spacebg'] = love.audio.newSource(sfxLoc .. 'almusic34_space4.mp3'),
    ['reselect'] = love.audio.newSource(sfxLoc .. 'laserswitch.wav'),
    ['conventional_shot'] = love.audio.newSource(sfxLoc .. 'interaction/conventional_shot.wav'),
    ['conventional_hit1'] = love.audio.newSource(sfxLoc .. 'interaction/conventional_hit1.wav'),
    ['conventional_hit2'] = love.audio.newSource(sfxLoc .. 'interaction/conventional_hit2.wav'),
    ['conventional_hit3'] = love.audio.newSource(sfxLoc .. 'interaction/conventional_hit3.wav'),
    ['chemical_thruster'] = love.audio.newSource(sfxLoc .. 'interaction/chemical_thruster.wav'),
    ['explosion1'] = love.audio.newSource(sfxLoc .. 'interaction/explosion1.wav'),
}

-- images
imgLoc = 'resources/graphics/'
gTextures = {
    --https://wallpaper.wiki/download-1080p-space-backgrounds-free.html/wallpaper-wiki-free-download-1080p-space-background-pic-wpd008677/
    ['spacelandbg'] = love.graphics.newImage(imgLoc .. 'backgrounds/spacemountainplanet.png'),
    ['standard_craft'] = love.graphics.newImage(imgLoc .. 'entities/ships/standard_ship_base_red.png'),
    ['large_plume'] = love.graphics.newImage(imgLoc .. 'entities/ships/exaggerated_exhaust_plume.png'),
    ['medium_plume'] = love.graphics.newImage(imgLoc .. 'entities/ships/yellow_exhaust_plume.png'),
    ['tungsten_shell'] = love.graphics.newImage(imgLoc .. 'entities/projectiles/kinetics/tungsten_shell.png'),
    ['tungsten_shell_flare'] = love.graphics.newImage(imgLoc .. 'entities/projectiles/kinetics/tungsten_shell_flare.png'),
    ['generic_missile'] = love.graphics.newImage(imgLoc .. 'entities/projectiles/missiles/generic_missile.png'),
    ['missile_exhaust'] = love.graphics.newImage(imgLoc .. 'entities/projectiles/missiles/missile_exhaust.png'),
    ['conventional_gun'] = love.graphics.newImage(imgLoc .. 'entities/addons/conventional_gun.png'),

    -- explosions
    --https://opengameart.org/content/explosion-set-1-m484-games
    ['small_orange_explosion'] = love.graphics.newImage(imgLoc .. 'effects/explosions/small_orange_explosion.png'),

    -- http://wallpaperen.com/asteroid-clipart/best-asteroid-clipart-free-to-use-public-domain-space-clip-art/
    ['roid1'] = love.graphics.newImage(imgLoc .. 'entities/doodads/asteroid.png'),

    -- planets
    ['p1'] = love.graphics.newImage(imgLoc .. 'bodies/p1.png'),
    ['p2'] = love.graphics.newImage(imgLoc .. 'bodies/p2.png'),
    ['p3'] = love.graphics.newImage(imgLoc .. 'bodies/p3.png'),
    -- https://www.kisspng.com/free/planet.html
    ['p4'] = love.graphics.newImage(imgLoc .. 'bodies/p4.png'),
    -- TODO: edit image alignment issues 8/8/18 -AW
    --['f1'] = love.graphics.newImage(imgLoc .. 'bodies/f1.png'),
    --['f2'] = love.graphics.newImage(imgLoc .. 'bodies/f2.png'),
    ['f3'] = love.graphics.newImage(imgLoc .. 'bodies/f3.png'),
    --['f4'] = love.graphics.newImage(imgLoc .. 'bodies/f4.png'),
    --['f5'] = love.graphics.newImage(imgLoc .. 'bodies/f5.png'),
    ['f6'] = love.graphics.newImage(imgLoc .. 'bodies/f6.png'),
    --['f7'] = love.graphics.newImage(imgLoc .. 'bodies/f7.png'),
    --['f8'] = love.graphics.newImage(imgLoc .. 'bodies/f8.png'),

    -- backgrounds
    --https://wonderfulengineering.com/35-hd-galaxy-wallpapers-for-free-download/
    --['b1'] = love.graphics.newImage(imgLoc .. 'backgrounds/b1.png'),
    ['b2'] = love.graphics.newImage(imgLoc .. 'backgrounds/b2.png'),
    --['b3'] = love.graphics.newImage(imgLoc .. 'backgrounds/b3.png'),
    --['b4'] = love.graphics.newImage(imgLoc .. 'backgrounds/b4.png'),
    --['b5'] = love.graphics.newImage(imgLoc .. 'backgrounds/b5.png'),
    --['b6'] = love.graphics.newImage(imgLoc .. 'backgrounds/b6.png'),
    ['b7'] = love.graphics.newImage(imgLoc .. 'backgrounds/b7.png'),
    ['b8'] = love.graphics.newImage(imgLoc .. 'backgrounds/b8.png'),
    ['b9'] = love.graphics.newImage(imgLoc .. 'backgrounds/b9.png'),
    ['b10'] = love.graphics.newImage(imgLoc .. 'backgrounds/b10.png'),
    ['b11'] = love.graphics.newImage(imgLoc .. 'backgrounds/b11.png'),

    --https://www.vectorstock.com/royalty-free-vector/protractor-actual-size-graduation-vector-12617847
}

-- texture quads
gFrames = {
    ['small_orange_explosion'] = GenerateQuads(gTextures['small_orange_explosion'], 16, 16),
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
    ['casanovascotia64'] = love.graphics.newFont(fntLoc .. 'Casanova-Scotia.otf', 64),
    ['timesnewroman16'] = love.graphics.newFont(fntLoc .. 'Times_New_Roman_Normal.ttf', 16),
    ['timesnewroman32'] = love.graphics.newFont(fntLoc .. 'Times_New_Roman_Normal.ttf', 32),
    -- https://fontlibrary.org/en/font/cmu-serif
    ['cmunbi32'] = love.graphics.newFont(fntLoc .. 'cmunbi.ttf', 32),
}

    