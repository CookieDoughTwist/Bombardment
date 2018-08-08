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

    ['getting_started'] = {
        bodies = {
            {
                def_key = 'cal_roid_1E2_1E15',
                x = 0,
                y = 0
            }
        },
        entities = {
            {
                def_key = 'cal_ship_tube',
                x = -1800,
                y = 0,
                angle = 0,
                dx = 0,
                dy = -math.sqrt(G * BODY_DEFS['cal_roid_1E2_1E15'].mass / 1800),
                dr = math.pi / 4,
                allegiance = -1,
                craft = true,
            },   
        },
        player = {
            {
                def_key = 'cal_ship_10_50_10000',
                x = 200,
                y = 0,
                angle = math.pi,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_roid_1E2_1E15'].mass / 200),
                dr = 0,
                craft = true,
            }
        }
    },
    ['gravity_is_hard'] = {
        bodies = {
            {
                def_key = 'small_planet',
                x = 0,
                y = 0
            }
        },
        entities = {
            {
                def_key = 'cal_ship_tube',
                x = -1300,
                y = 0,
                angle = 0,
                dx = 0,
                dy = -math.sqrt(G * BODY_DEFS['small_planet'].mass / 1300),
                dr = math.pi / 4,
                allegiance = -1,
                craft = true,
            },   
        },
        player = {
            {
                def_key = 'cal_ship_10_50_10000',
                x = 2200,
                y = 0,
                angle = math.pi,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['small_planet'].mass / 2200),
                dr = 0,
                craft = true,
            }
        }
    },
    ['they_can_shoot_too'] = {
        bodies = {
            {
                def_key = 'cal_roid_1E2_1E15',
                x = 0,
                y = 0
            }
        },
        entities = {
            {
                def_key = 'cal_ship_10_50_10000',
                x = -200,
                y = 0,
                angle = 0,
                dx = 0,
                dy = -math.sqrt(G * BODY_DEFS['cal_roid_1E2_1E15'].mass / 200),
                dr = math.pi / 4,
                allegiance = -1,
                craft = true,
            },   
        },
        player = {
            {
                def_key = 'cal_ship_10_50_10000',
                x = 1800,
                y = 0,
                angle = math.pi,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_roid_1E2_1E15'].mass / 1800),
                dr = 0,
                craft = true,
            }
        }
    },

    ['show_me_your_stuff'] = {
        bodies = {
            {
                def_key = 'cal_plan_1E5_1E18',
                x = 0,
                y = 0
            }
        },
        entities = {
            {
                def_key = 'cal_ship_10_50_10000',
                x = 2 * BODY_DEFS['cal_plan_1E5_1E18'].radius,
                y = 200,
                angle = 0,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_plan_1E5_1E18'].mass / (2 * BODY_DEFS['cal_plan_1E5_1E18'].radius)),
                dr = 0,
                allegiance = -1,
                craft = true,
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = 2 * BODY_DEFS['cal_plan_1E5_1E18'].radius - 200,
                y = 200,
                angle = 0,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_plan_1E5_1E18'].mass / (2 * BODY_DEFS['cal_plan_1E5_1E18'].radius)),
                dr = 0,
                allegiance = -1,
                craft = true,
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = -2 * BODY_DEFS['cal_plan_1E5_1E18'].radius - 200,
                y = 200,
                angle = 0,
                dx = 0,
                dy = -math.sqrt(G * BODY_DEFS['cal_plan_1E5_1E18'].mass / (2 * BODY_DEFS['cal_plan_1E5_1E18'].radius)),
                dr = 0,
                allegiance = -1,
                craft = true,
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = -2 * BODY_DEFS['cal_plan_1E5_1E18'].radius - 200,
                y = 300,
                angle = 0,
                dx = 0,
                dy = -math.sqrt(G * BODY_DEFS['cal_plan_1E5_1E18'].mass / (2 * BODY_DEFS['cal_plan_1E5_1E18'].radius)),
                dr = 0,
                allegiance = -1,
                craft = true,
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = -2 * BODY_DEFS['cal_plan_1E5_1E18'].radius - 200,
                y = 400,
                angle = 0,
                dx = 0,
                dy = -math.sqrt(G * BODY_DEFS['cal_plan_1E5_1E18'].mass / (2 * BODY_DEFS['cal_plan_1E5_1E18'].radius)),
                dr = 0,
                allegiance = -1,
                craft = true,
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
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = 2 * BODY_DEFS['cal_plan_1E5_1E18'].radius + 100,
                y = 0,
                angle = 0,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_plan_1E5_1E18'].mass / (2 * BODY_DEFS['cal_plan_1E5_1E18'].radius)),
                dr = 0,
                craft = true,
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = 2 * BODY_DEFS['cal_plan_1E5_1E18'].radius - 100,
                y = 0,
                angle = 0,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_plan_1E5_1E18'].mass / (2 * BODY_DEFS['cal_plan_1E5_1E18'].radius)),
                dr = 0
            },
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
                dr = 0,
                craft = true
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = 2 * BODY_DEFS['cal_plan_1E5_1E18'].radius + 100,
                y = 0,
                angle = 0,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_plan_1E5_1E18'].mass / (2 * BODY_DEFS['cal_plan_1E5_1E18'].radius)),
                dr = 0,
                craft = true
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
                dr = 0,
                craft = true
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
                dr = 0,
                craft = true,
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
                allegiance = -1,
                craft = true,
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = 1000,
                y = 400,
                angle = 0,
                dx = 0,                
                dy = math.sqrt(G * BODY_DEFS['cal_roid_1E2_1E15'].mass / 600),
                dr = 0.5,
                craft = true,
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = 1200,
                y = 400,
                angle = 0,
                dx = 0,                
                dy = math.sqrt(G * BODY_DEFS['cal_roid_1E2_1E15'].mass / 800),
                dr = 1.0,
                craft = true,
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = 1400,
                y = 400,
                angle = 0,
                dx = 0,                
                dy = math.sqrt(G * BODY_DEFS['cal_roid_1E2_1E15'].mass / 1000),
                dr = 1.5,
                craft = true,
            }      
        },
        player = {
            {
                def_key = 'cal_ship_10_50_10000',
                x = 600,
                y = 400,
                angle = math.pi,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_roid_1E2_1E15'].mass / 200),
                dr = 0,
                craft = true,
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
            {
                def_key = 'cal_ship_10_50_10000',
                x = 2 * BODY_DEFS['cal_plan_1E5_1E18'].radius,
                y = 200,
                angle = 0,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_plan_1E5_1E18'].mass / (2 * BODY_DEFS['cal_plan_1E5_1E18'].radius)),
                dr = 0,
                craft = true,
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = 2 * BODY_DEFS['cal_plan_1E5_1E18'].radius - 200,
                y = 200,
                angle = 0,
                dx = 0,
                dy = math.sqrt(G * BODY_DEFS['cal_plan_1E5_1E18'].mass / (2 * BODY_DEFS['cal_plan_1E5_1E18'].radius)),
                dr = 0,
                allegiance = -1,
                craft = true,
            },
            {
                def_key = 'cal_ship_10_50_10000',
                x = -2 * BODY_DEFS['cal_plan_1E5_1E18'].radius - 200,
                y = 200,
                angle = 0,
                dx = 0,
                dy = -math.sqrt(G * BODY_DEFS['cal_plan_1E5_1E18'].mass / (2 * BODY_DEFS['cal_plan_1E5_1E18'].radius)),
                dr = 0,
                allegiance = -1,
                craft = true,
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
                dr = 0,
                craft = true,
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