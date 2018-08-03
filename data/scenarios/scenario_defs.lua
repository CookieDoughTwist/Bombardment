-- TODO: make scenarios more modular/exposed 8/2/18 -AW
SCENARIO_DEFS = {

    ['simple_orbit'] = {
        bodies = {
            {
                def_key = 'cal_roid_100_10000000',
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
                dx = 0,
                --dy = 19,
                dy = math.sqrt(G * BODY_DEFS['cal_roid_100_10000000'].mass / 200),
                dr = 0
            }
        }
    },

    ['simple_orbit_far'] = {
        bodies = {
            {
                def_key = 'cal_roid_100_10000000',
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
                dx = 0,
                --dy = 19,
                dy = math.sqrt(G * BODY_DEFS['cal_roid_100_10000000'].mass / 200),
                dr = 0
            }
        }
    },

    ['multi_orbit'] = {
        bodies = {
            {
                def_key = 'cal_roid_100_10000000',
                x = 400,
                y = 400
            }
        },
        entities = {
            {
                def_key = 'cal_ship_10_50_10000',
                x = 800,
                y = 400,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_roid_100_10000000'].mass / 400),
                dr = 0.1
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = 1000,
                y = 400,
                dx = 0,                
                dy = math.sqrt(G * BODY_DEFS['cal_roid_100_10000000'].mass / 600),
                dr = 0.5
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = 1200,
                y = 400,
                dx = 0,                
                dy = math.sqrt(G * BODY_DEFS['cal_roid_100_10000000'].mass / 800),
                dr = 1.0
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = 1400,
                y = 400,
                dx = 0,                
                dy = math.sqrt(G * BODY_DEFS['cal_roid_100_10000000'].mass / 1000),
                dr = 1.5
            }            
        },
        player = {
            {
                def_key = 'cal_ship_10_50_10000',
                x = 600,
                y = 400,
                dx = 0,
                --dy = 19,
                dy = math.sqrt(G * BODY_DEFS['cal_roid_100_10000000'].mass / 200),
                dr = 0
            }
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