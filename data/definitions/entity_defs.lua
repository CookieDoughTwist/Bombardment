--[[

]]

ENTITY_DEFS = {
    ['cal_ship_10_50_10000'] = {
        width = 10,
        height = 50,
        mass = 1E4,
        thrust = 1E5,
        gimbal = 1E5,
        vectoring = 3,
        thrustLoc = {0, -30},

        addons = {
            {
                def_key = 'conventional_ball_turret',
                location = {-5, 10},
                orientation = {-1, 0}
            },
            {
                def_key = 'conventional_ball_turret',
                location = {-5, -10},
                orientation = {-1, 0}
            },
            {
                def_key = 'conventional_ball_turret',
                location = {5, 10},
                orientation = {1, 0}
            },
            {
                def_key = 'conventional_ball_turret',
                location = {5, -10},
                orientation = {1, 0}
            }
        }
    },
}