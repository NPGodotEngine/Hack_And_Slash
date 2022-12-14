extends ProjectileWeapon

# warning-ignore-all:RETURN_VALUE_DISCARDED

# Flame pool that leave on ground when
# bullet hit 
export (PackedScene) var _flame_pool_scene = null

# Flame pool duration
export (float) var _flame_pool_life_span = 3.0

# Flame damage interval
export (float) var _flame_pool_damage_interval = 1.0

# Flame pool spawn chance
export (float, 0.0, 1.0) var _flame_pool_spawn_chance = 0.1

# Number of time left bullet can do split
# Dcrease 1 for each spawn bullets
export (int) var init_bullet_split_count_left = 1

# Number of splits can bullet do
# when it hit something
export (int) var bullet_split = 2

# Splited angle for a bullet
# that is about to split
export (float) var splits_angle_deg = 10.0

func execute(position:Vector2, direction:Vector2) -> void:
    .execute(position, direction)

    # get facing direction
    _spawn_bullet(direction.normalized(), position, init_bullet_split_count_left)

    start_reloading()

func _on_projectile_hit(projectile:FireBullet, body:Node) -> void:
    assert(_flame_pool_scene, "flame_pool_scene is null")

    # Spanw flame pool
    if _flame_pool_scene and can_spawn_flame_pool():
        _spawn_flame_pool(body.global_position)
    
    # if projectile has not splits left
    if projectile.split_count_left == 0: return
    
    # splits projectiles
    # get arc angle directions for each splitted bullets
    var n_splits: int = 0
    var character: Character = get_parent().get_manager_owner()
    if character:
        n_splits = int(round(projectile.n_splits * (float(character._level) / float(character.MAX_LEVEL))))

    var arc_dirs = get_arc_shooting_style(projectile.get_projectile_direction(), 
                                deg2rad(splits_angle_deg), 
                                n_splits)
    
    # Spawn bullets
    for dir in arc_dirs:
        _spawn_bullet(dir, projectile.global_position, 
                        projectile.split_count_left - 1,
                        [body])

    # remove old projectile
    # if it splitted
    if n_splits > 0:    
        projectile.queue_free()


# Spawn a bullet at global position
##
# `direction` face direction
# `position` global position
# `splits_left` number of time left for this bullet to
# be able to split
# `ignored_bodies` bodies that will be ignored by this bullet
# usually is the bodies had been hitted so it will not be
# damaged twice
func _spawn_bullet(direction:Vector2, position:Vector2, splits_left:int,
        ignored_bodies:Array = []) -> void:
    var bullet: FireBullet = self.projectile_scene.instance()
    get_tree().current_scene.call_deferred("add_child", bullet)
    bullet.setup(self, direction, position, projectile_speed, 
            get_hit_damage(), projectile_life_span, 
            projectile_penetration_chance)
    bullet.add_ignored_bodies(ignored_bodies)
    bullet.split_count_left = splits_left
    bullet.n_splits = bullet_split
    bullet.connect("on_projectile_hit", self, "_on_projectile_hit")

# Spawn a flame pool at global position
func _spawn_flame_pool(position:Vector2) -> void:
    var flame_pool: FlamePool = _flame_pool_scene.instance()
    get_tree().current_scene.call_deferred("add_child", flame_pool)
    flame_pool.setup(get_hit_damage(), _flame_pool_life_span, _flame_pool_damage_interval)
    flame_pool.global_position = position

# Can spawn a flaming pool
func can_spawn_flame_pool() -> bool:
    if is_equal_approx(_flame_pool_spawn_chance, 0.0): return false
    return Utils.is_in_threshold(_flame_pool_spawn_chance, 0.0001, 1.0)

# Return vector2 as direction for each projectiles
##
# `direction` is tha facing direction
# `max_angle_radian` the total angle in radian for shooting bullet in arc
# `projectile_count` number of projectiles
func get_arc_shooting_style(direction:Vector2, max_angle_radian:float, projectile_count:int) -> Array:
    if projectile_count <= 0: return []

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