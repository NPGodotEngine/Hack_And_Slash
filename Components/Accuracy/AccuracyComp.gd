class_name AccuracyComp
extends Component

signal accuracy_changed(from_accuracy, to_accuracy)

# Spread range in degree
##
# The final range would be from
# -spread_range_degree
# to
# spread_range_degree
export (float) var spread_range_degree = 10.0

# Accuracy
export (float, 0.0, 1.0) var accuracy = 0.5 setget set_accuracy


## Getter Setter ##


func set_accuracy(value:float) -> void:
    var old_accuracy: float = accuracy
    accuracy = min(max(0.0, value), 1.0)
    emit_signal("accuracy_changed", old_accuracy, accuracy)
## Getter Setter ##



# Return a new random normalized 
# direction in `Vector2` from given direction
##
# `face_dir` current facing direction
# `accuracy_scaler` used to scale spread range. Value must in between 0.0 ~ 1.0
# if value is out of range then it will be scaled in 0.0 ~ 1.0  
func get_random_spread(face_dir:Vector2, accuracy_scaler:float = 1.0) -> Vector2:
    # make sure accuracy scaler is in range
    accuracy_scaler = min(max(0.0, accuracy_scaler), 1.0)
    
    # normalize face direction
    var direction: Vector2 = face_dir.normalized()

    # get random rotation
    var scaled_spread_range: float = spread_range_degree * (1.0 -accuracy_scaler)
    var rand_rotation: float = rand_range(-scaled_spread_range, scaled_spread_range)
    rand_rotation = deg2rad(rand_rotation)

    # rotate direction
    direction = direction.rotated(rand_rotation)

    return direction