--[[

]]

-- REMINDER: orientation of 0 is pointing up by enforcement
--           true Lua 0 is pointing to the right (positive x)
--           positive angles go clockwise

ENTITY_DEFS = {
    
    ['cal_ship_tube'] = {
        resource = 'standard_craft',
        width = 10,
        height = 50,
        mass = 786E3,
        thrust = 1E5,
        gimbal = 1E5,
        vectoring = math.rad(5),
        thrustLoc = {0, 30},
    },
    ['cal_ship_10_50_10000'] = {
        resource = 'standard_craft',
        width = 10,
        height = 50,
        mass = 786E3,
        thrust = 1E5,
        gimbal = 1E6,
        vectoring = math.rad(5),
        thrustLoc = {0, 30},

        addons = {            
            {
                def_key = 'conventional_ball_turret',
                location = {-5, 10},
                orientation = -PI_2
            },
            {
                def_key = 'conventional_ball_turret',
                location = {-5, -10},
                orientation = -PI_2
            },            
            {
                def_key = 'conventional_ball_turret',
                location = {5, 10},
                orientation = PI_2
            },
            {
                def_key = 'conventional_ball_turret',
                location = {5, -10},
                orientation = PI_2
            }
        }
    },
    ['tungsten_shell'] = {
        resource = 'tungsten_shell',
        width = 0.25,
        height = 1,
        mass = 1E3,       
    }
}