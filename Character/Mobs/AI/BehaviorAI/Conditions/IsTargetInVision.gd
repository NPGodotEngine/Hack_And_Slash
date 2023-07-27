extends ConditionLeaf


@onready var vision_area: Area2D = get_node_or_null("%Vision/VisionConeArea")


func tick(_actor:Node, blackboard:Blackboard) -> int:
	var target: Player = blackboard.get_value(EnemyBlackboard.PLAYER_TARGET)

	for b in vision_area.get_overlapping_bodies():
		if b == target:
			return SUCCESS
	
	return FAILURE