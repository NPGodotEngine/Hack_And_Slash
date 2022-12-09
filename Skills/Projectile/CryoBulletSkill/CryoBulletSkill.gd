extends ProjectileSkill

# warning-ignore-all:RETURN_VALUE_DISCARDED

# Max projectile speed
export (float) var max_projectile_speed = (projectile_speed + 500.0) setget set_max_projectile_speed

# Acceleration curve is a CurveTexture
# that has its own defined curve and 
# CurveTexture allow curve to be defined
# in inspector
export (CurveTexture) var projectile_acc_curve

# Max angle of bullet spread both min and max
export (float) var spread_angle = 15.0

# Fire interval
export (float) var fire_interval = 0.3

# Fire interval timer
var _fire_interval_timer: Timer

# How many bullets left to shoot
var _bullet_left: int = 0

# Is in fire interval
var _is_in_interval: bool = false

## Getter Setter ##
func set_max_projectile_speed(value:float) -> void:
    # make sure we have at least equal to projectile basic speed
    max_projectile_speed = max(projectile_speed, value)
## Getter Setter ##

## Override ##
func setup(skill_executer) -> void:
    .setup(skill_executer)

    # refill bullet
    _refill_bullets()

    # add default acceleration curve if not exist
    if not projectile_acc_curve:
        projectile_acc_curve = CurveTexture.new()
        projectile_acc_curve.curve = Curve.new() 
        projectile_acc_curve.curve.add_point(Vector2(0.0, 0.1))
        projectile_acc_curve.curve.add_point(Vector2(0.7, 1.0))
    
    # setup fire interval timer
    _fire_interval_timer = Timer.new()
    add_child(_fire_interval_timer)
    _fire_interval_timer.one_shot = true
    _fire_interval_timer.connect("timeout", self, "_on_fire_a_projectile")

func execute(position:Vector2, direction:Vector2) -> void:
    .execute(position, direction)

    # make first shot
    if not _is_in_interval:
        _on_fire_a_projectile()

func _on_cool_down_timer_timeout() -> void:
    ._on_cool_down_timer_timeout()

    # refill bullet
    _refill_bullets()
## Override ##

# Call to shoot one or many bullets in one succession
# This will also be called from fire interval timer
func _on_fire_a_projectile():
    # shoot bullet if we have bullet left
    if _bullet_left > 0:
        _shoot_bullet()

        # decrease bullet
        _bullet_left -= 1
        _bullet_left = int(min(max(0, _bullet_left), self.projectile_count))
    
    # no bullet left to shoot
    if _bullet_left == 0:
        _is_in_interval = false
        # start skill cool down if no bullets left
        start_cool_down()
        _fire_interval_timer.stop()
    else:
        # have bullet left then wait until next shot
        _is_in_interval = true
        _fire_interval_timer.stop()
        _fire_interval_timer.start(fire_interval)

# Shoot one bullet
func _shoot_bullet() -> void:
    var global_mouse_position = get_global_mouse_position()

    # get direction
    var face_direction = (global_mouse_position - skill_owner.global_position).normalized()

    # get random spread direction
    var spread_direction = get_random_spread_direction(face_direction, spread_angle)

    # shoot projectile
    var bullet: CryoBullet = projectile_scene.instance()
    get_tree().current_scene.add_child(bullet)
    bullet.setup(self, spread_direction, skill_owner.global_position, projectile_speed)
    bullet.configure_movement(projectile_acc_curve.curve, max_projectile_speed)

# Refill bullets
func _refill_bullets() -> void:
    _bullet_left = self.projectile_count

# Return a vector2 with random direction in spread angle
##
# `face_direction` current face direction
# `spread_angle_deg` spread angle left or right in degree
func get_random_spread_direction(face_direction:Vector2, spread_angle_deg:float) -> Vector2:
    var dir_norm: Vector2 = face_direction.normalized()
    var min_spread_radian: float = (deg2rad(spread_angle_deg) if spread_angle_deg < 0.0 
                                                                else -deg2rad(spread_angle_deg))
    var max_spread_radian: float = (-deg2rad(spread_angle_deg) if spread_angle_deg < 0.0 
                                                                else deg2rad(spread_angle_deg))
    var random_radian: float = rand_range(min_spread_radian, max_spread_radian)
    return dir_norm.rotated(random_radian)

