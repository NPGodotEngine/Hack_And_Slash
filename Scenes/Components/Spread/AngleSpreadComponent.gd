class_name AngleSpreadComponent
extends Node

# Spread range in degree
##
# The final range would be from
# -spread_range_degree
# to
# spread_range_degree
@export var spread_range_degree = 10.0

# Return a new random normalized 
# direction in `Vector2` from given direction
##
# `from_direction` current facing direction
# `scaler` used to scale spread range. Value must in between 0.0 ~ 1.0
# if value is out of range then it will be capped in 0.0 ~ 1.0  
func get_random_spread(from_direction:Vector2, scaler:float = 1.0) -> Vector2:
    # make sure accuracy scaler is in range
    scaler = min(max(0.0, scaler), 1.0)
    
    # normalize face direction
    var direction: Vector2 = from_direction.normalized()

    # get random rotation
    var scaled_spread_range: float = spread_range_degree * (1.0 -scaler)
    var rand_rotation: float = randf_range(-scaled_spread_range, scaled_spread_range)
    rand_rotation = deg_to_rad(rand_rotation)

    # rotate direction
    direction = direction.rotated(rand_rotation)

    return direction