class_name RadiusSpreadComponent
extends Node

## Spread range in degree
##
## The final range would be from
## -spread_range_degree
## to
## spread_range_degree
@export var spread_radius = 10.0

# Return a new random normalized 
# direction in `Vector2` from given direction
##
# `from_direction` current facing direction
# `scaler` used to scale spread range. Value must in between 0.0 ~ 1.0
# if value is out of range then it will be capped in 0.0 ~ 1.0  
func get_random_spread_point(center:Vector2, scaler:float = 1.0) -> Vector2:
    # make sure accuracy scaler is in range
    scaler = min(max(0.0, scaler), 1.0)
    
    # find max spread radius
    var max_spread_radius: float = spread_radius * scaler 

    # get random point in unit circle 
    var rand_unit_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1))
    rand_unit_vector = rand_unit_vector.normalized()

    return max_spread_radius * rand_unit_vector + center
    