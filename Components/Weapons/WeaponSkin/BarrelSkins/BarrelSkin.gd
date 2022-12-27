tool
class_name BarrelSkin
extends Component

# warning-ignore-all: RETURN_VALUE_DISCARDED

var fire_points: Array setget , get_fire_points

func _get_configuration_warning() -> String:
    var points: Array = []
    for node in get_children():
        if node is Position2D:
            points.append(node.global_position)
    
    if points.size() == 0:
        return "Barrel skin need at least 1 fire point which is type of Position2D"

    return ""
func get_fire_points() -> Array:
    var points: Array = []
    for node in get_children():
        if node is Position2D:
            points.append(node.global_position)
    return points


