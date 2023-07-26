extends ConditionLeaf

@onready var vision_area: Area2D = get_node_or_null("%Vision/VisionConeArea")

var target_body: Player


func tick(_actor:Node, blackboard:Blackboard) -> int:
	var target: Player = blackboard.get_value(EnemyBlackboard.PLAYER_TARGET)

	for body in vision_area.get_overlapping_bodies():
		if target == body:
			blackboard.set_value(EnemyBlackboard.TARGET_POSITION, target.global_position)
			return SUCCESS

	return FAILURE
	


