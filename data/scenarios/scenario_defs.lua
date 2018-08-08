-- TODO: make scenarios more modular/exposed 8/2/18 -AW
SCENARIO_DEFS = {

    ['empty'] = {
        bodies = {

        },
        entities = {

        },
        player = {

        }
    },

    ['no_bodies'] = {
        bodies = {

        },
        entities = {

        },
        player = {
            {
                def_key = 'cal_ship_10_50_10000',
                x = 2 * BODY_DEFS['cal_plan_1E5_1E18'].radius,
                y = 0,
                angle = 0,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_plan_1E5_1E18'].mass / (2 * BODY_DEFS['cal_plan_1E5_1E18'].radius)),
                dr = 0
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = 2 * BODY_DEFS['cal_plan_1E5_1E18'].radius + 100,
                y = 0,
                angle = 0,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_plan_1E5_1E18'].mass / (2 * BODY_DEFS['cal_plan_1E5_1E18'].radius)),
                dr = 0
            }
        }
    },

    ['simple_orbit'] = {
        bodies = {
            {
                def_key = 'cal_roid_1E2_1E15',
                x = 400,
                y = 400
            }
        },
        entities = {

        },
        player = {
            {
                def_key = 'cal_ship_10_50_10000',
                x = 600,
                y = 400,
                angle = math.pi / 2,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_roid_1E2_1E15'].mass / 200),
                dr = 0
            }
        }
    },

    ['simple_orbit_far'] = {
        bodies = {
            {
                def_key = 'cal_roid_1E2_1E15',
                x = 400+10000000,
                y = 400
            }
        },
        entities = {

        },
        player = {
            {
                def_key = 'cal_ship_10_50_10000',
                x = 600+10000000,
                y = 400,
                angle = 0,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_roid_1E2_1E15'].mass / 200),
                dr = 0
            }
        }
    },

    ['multi_orbit'] = {
        bodies = {
            {
                def_key = 'cal_roid_1E2_1E15',
                x = 400,
                y = 400
            }
        },
        entities = {
            {
                def_key = 'cal_ship_tube',
                x = 800,
                y = 400,
                angle = 0,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_roid_1E2_1E15'].mass / 400),
                dr = 0.1,
                allegiance = -1
            },--[[
            {
                def_key = 'cal_ship_10_50_10000',
                x = 1000,
                y = 400,
                angle = 0,
                dx = 0,                
                dy = math.sqrt(G * BODY_DEFS['cal_roid_1E2_1E15'].mass / 600),
                dr = 0.5
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = 1200,
                y = 400,
                angle = 0,
                dx = 0,                
                dy = math.sqrt(G * BODY_DEFS['cal_roid_1E2_1E15'].mass / 800),
                dr = 1.0
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = 1400,
                y = 400,
                angle = 0,
                dx = 0,                
                dy = math.sqrt(G * BODY_DEFS['cal_roid_1E2_1E15'].mass / 1000),
                dr = 1.5
            }     ]]       
        },
        player = {
            {
                def_key = 'cal_ship_10_50_10000',
                x = 600,
                y = 400,
                angle = math.pi,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_roid_1E2_1E15'].mass / 200),
                dr = 0
            }
        }
    },

    ['test_planetoid'] = {
        bodies = {
            {
                def_key = 'cal_plan_1E5_1E18',
                x = 0,
                y = 0
            }
        },
        entities = {
            --[[
            {
                def_key = 'cal_ship_10_50_10000',
                x = 2 * BODY_DEFS['cal_plan_1E5_1E18'].radius,
                y = 200,
                angle = 0,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_plan_1E5_1E18'].mass / (2 * BODY_DEFS['cal_plan_1E5_1E18'].radius)),
                dr = 0
            },]]
            {
                def_key = 'cal_ship_10_50_10000',
                x = 2 * BODY_DEFS['cal_plan_1E5_1E18'].radius - 200,
                y = 200,
                angle = 0,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_plan_1E5_1E18'].mass / (2 * BODY_DEFS['cal_plan_1E5_1E18'].radius)),
                dr = 0,
                allegiance = -1
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = -2 * BODY_DEFS['cal_plan_1E5_1E18'].radius - 200,
                y = 200,
                angle = 0,
                dx = 0,
                dy = -math.sqrt(G * BODY_DEFS['cal_plan_1E5_1E18'].mass / (2 * BODY_DEFS['cal_plan_1E5_1E18'].radius)),
                dr = 0,
                allegiance = -1
            },
        },
        player = {
            {
                def_key = 'cal_ship_10_50_10000',
                x = 2 * BODY_DEFS['cal_plan_1E5_1E18'].radius,
                y = 0,
                angle = 0,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_plan_1E5_1E18'].mass / (2 * BODY_DEFS['cal_plan_1E5_1E18'].radius)),
                dr = 0
            },--[[
            {
                def_key = 'cal_ship_10_50_10000',
                x = 2 * BODY_DEFS['cal_plan_1E5_1E18'].radius + 100,
                y = 0,
                angle = 0,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_plan_1E5_1E18'].mass / (2 * BODY_DEFS['cal_plan_1E5_1E18'].radius)),
                dr = 0
            }]]
        }
    },













    ['test_black_hole'] = {
        bodies = {
            ['stellar_black_hole'] = {
                x = 0,
                y = 0
            }
        },
        entities = {

        },
        player = {
            ['cal_ship_10_50_10000'] = {
                x = 160E3,
                y = 0,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['stellar_black_hole'].mass / 160E3),
                dr = 0
            }
        }
    },

    ['earth_low_orbit'] = {
        bodies = {
            {
                def_key = 'earth',
                x = 0,
                y = 0
            }
        },
        entities = {
            
        },
        player = {
            {
                def_key = 'cal_ship_10_50_10000',
                x = 160E3 + BODY_DEFS['earth'].radius,
                y = 0,
                dx = 0,                        
                dy = math.sqrt(G * BODY_DEFS['earth'].mass / (160E3 + BODY_DEFS['earth'].radius)),
                dr = 0
            }
        }
    }
}