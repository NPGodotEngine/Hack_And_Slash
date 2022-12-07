extends ProjectileSkill

export (float) var max_shooting_angle = 15.0

func execute(position:Vector2, direction:Vector2) -> void:
    .execute(position, direction)

    # get facing direction
    var face_dir: Vector2 = get_global_mouse_position() - skill_owner.global_position

    # use fan shape for shooting projectile
    var shoot_dirs = get_fan_shooting_style(face_dir, deg2rad(max_shooting_angle), self.projectile_count)

    # shoot projectiles
    for dir in shoot_dirs:
        var bullet: Projectile = self.projectile_scene.instance()
        get_tree().current_scene.add_child(bullet)
        bullet.direction = dir
        bullet.global_position = self.skill_owner.global_position
        bullet.hit_damage = self.get_hit_damage()
        bullet.speed = self.projectile_speed
        bullet.life_span = self.projectile_life_span

    start_cool_down()

# Return vector2 as direction for each projectiles
func get_fan_shooting_style(direction:Vector2, max_angle_radian:float, projectile_count:int) -> Array:
    # return direction if only 1 projectile
    if projectile_count == 1: return [direction.normalized()]

    var count: int = projectile_count - 1
    var dir_norm: Vector2 = direction.normalized()
    var angles: Array = []

    # angle in interval
    var split_angle_radin: float = max_angle_radian / count

    # angle offset
    var angle_offset: float = max_angle_radian / 2.0 

    # calcualte angle for each projectile
    for i in projectile_count:
        var rot: float = i * split_angle_radin - angle_offset
        var dir: Vector2 = dir_norm.rotated(rot)
        angles.append(dir)
    
    return angles