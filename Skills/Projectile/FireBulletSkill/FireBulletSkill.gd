extends ProjectileSkill

# warning-ignore-all:RETURN_VALUE_DISCARDED

# Max angle to spread bullet 
export (float) var max_shooting_angle = 15.0

# Flame pool that leave on ground when
# bullet hit 
export (PackedScene) var _flame_pool_scene = null

# Flame pool duration
export (float) var _flame_pool_life_span = 3.0

# Flame damage interval
export (float) var _flame_pool_damage_interval = 1.0

# Flame pool spawn chance
export (float, 0.0, 1.0) var _flame_pool_spawn_chance = 0.1

func execute(position:Vector2, direction:Vector2) -> void:
    .execute(position, direction)

    # get facing direction
    var face_dir: Vector2 = get_global_mouse_position() - skill_owner.global_position

    # use arc shape for shooting projectile
    var shoot_dirs = get_arc_shooting_style(face_dir, deg2rad(max_shooting_angle), self.projectile_count)

    # shoot projectiles
    for dir in shoot_dirs:
        var bullet: Projectile = self.projectile_scene.instance()
        get_tree().current_scene.add_child(bullet)
        bullet.setup(self, dir, skill_owner.global_position, projectile_speed)
        bullet.connect("on_projectile_hit", self, "_on_projectile_hit", [], CONNECT_ONESHOT)

    start_cool_down()

func _on_projectile_hit(body:Node) -> void:
    assert(_flame_pool_scene, "flame_pool_scene is null")

    if _flame_pool_scene and can_spawn_flame_pool():
        var flame_pool: FlamePool = _flame_pool_scene.instance()
        get_tree().current_scene.call_deferred("add_child", flame_pool)
        flame_pool.setup(get_hit_damage(), _flame_pool_life_span, _flame_pool_damage_interval)
        flame_pool.global_position = body.global_position

# Can spawn a flaming pool
func can_spawn_flame_pool() -> bool:
    if is_equal_approx(_flame_pool_spawn_chance, 0.0): return false
    return Utils.is_in_threshold(_flame_pool_spawn_chance, 0.0001, 1.0)

# Return vector2 as direction for each projectiles
##
# `direction` is tha facing direction
# `max_angle_radian` the total angle in radian for shooting bullet in arc
func get_arc_shooting_style(direction:Vector2, max_angle_radian:float, projectile_count:int) -> Array:
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