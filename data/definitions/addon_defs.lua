ADDON_DEFS = {
    ['conventional_ball_turret'] = {
        base = nil,
        barrel = 'conventional_gun',
        projectile = 'tungsten_shell',
        fire_effect = 'tungsten_shell_flare',
        fire_sound = 'conventional_shot',
        arc_2 = math.rad(65),
        cooldown = 0.25,
        -- Box2D may have some hitboxing issues at higher speeds
        projectile_speed = 1E3,
        rotation_speed = math.rad(15)
    }
}