class_name CryoBullet
extends Projectile

# Acceleration curve
##
# A curve that can be custom defined curve
# Acceleration would base on curve
var _acceleration_curve: Curve

# Max speed of bullet
var _max_speed: float = _speed

## Override ##
func _move_projectile(delta:float) -> void:
    var current_speed: float = get_current_speed()

    # move bullet
    _velocity = _direction.normalized() * current_speed * delta
    global_rotation = _direction.angle()
    global_position += _velocity
## Override ##


# Get current speed
##
# The speed is scaled by curve
func get_current_speed() -> float:
    # get ratio of bullet's life span
    var life_span_ratio: float = (_life_span_timer.wait_time - _life_span_timer.time_left) / _life_span_timer.wait_time

    # get curve y value base on ratio of bullet's life span
    var curve_y_interpolation: float = _acceleration_curve.interpolate(life_span_ratio)

    # calculate current speed
    var current_speed: float = (_max_speed - _speed) * curve_y_interpolation

    # make sure speed is range
    current_speed = clamp(current_speed, _speed, _max_speed)

    return current_speed

# Configure cryo bullet movement
##
# Movement would be slow at start and accelerate to max speed
# `acc_curve` acceleration curve for bullet acceleration
# `max_speed` max speed of cryo bullet
func configure_movement(acc_curve:Curve, max_speed:float) -> void:
    _acceleration_curve = acc_curve
    _max_speed = max_speed



