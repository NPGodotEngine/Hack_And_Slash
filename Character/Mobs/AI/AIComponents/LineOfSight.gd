@tool
class_name LineOfSight
extends Marker2D

@export  var distance: float = 100.0

@onready var raycast: RayCast2D = $RayCast2D

func isTargetInSight(target:Node2D) -> bool:
    if target == null:
        return false

    # update raycast
    var target_dir: Vector2 = global_position.direction_to(target.global_position)
    var target_position: Vector2 = target_dir * distance
    raycast.target_position = target_position
    raycast.force_raycast_update()

    # check if target is in sight
    if raycast.is_colliding() and raycast.get_collider() == target:
        return true
    else:
        return false
    
