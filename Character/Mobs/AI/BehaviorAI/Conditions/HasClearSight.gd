extends ConditionLeaf

@onready var vision_area: Area2D = get_node_or_null("%Vision/VisionConeArea")
@onready var line_of_sight: RayCast2D = get_node_or_null("%LineOfSight")

func tick(_actor:Node, blackboard:Blackboard) -> int:
	var target: Player = blackboard.get_value(EnemyBlackboard.PLAYER_TARGET)

	if target == null:
		return FAILURE

	# make sure target is in vision area
	var target_in_sight = false
	for body in vision_area.get_overlapping_bodies():
		if body == target:
			target_in_sight = true
			break
	if not target_in_sight:
		return FAILURE
	
	# if target is in line of sight
	line_of_sight.target_position = line_of_sight.to_local(target.global_position)
	line_of_sight.force_raycast_update()
	var collider := line_of_sight.get_collider()
	
	if collider == null:
		return FAILURE
	
	if collider == target:
		return SUCCESS
	
	return FAILURE
