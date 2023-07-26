extends ConditionLeaf

@onready var vision_area: Area2D = get_node_or_null("%Vision/VisionConeArea")

var target_body: Player

# func _ready() -> void:
# 	vision_area.connect("body_entered", Callable(self, "_on_body_entered"))
# 	vision_area.connect("body_exited", Callable(self, "_on_body_exited"))

# func _on_body_entered(body:Node) -> void:
# 	if body is Player:
# 		target_body = body

# func _on_body_exited(body:Node) -> void:
# 	if target_body == body:
# 		target_body = null

func tick(_actor:Node, blackboard:Blackboard) -> int:
	var target: Player = blackboard.get_value(EnemyBlackboard.PLAYER_TARGET)

	for body in vision_area.get_overlapping_bodies():
		if target == body:
			blackboard.set_value(EnemyBlackboard.TARGET_POSITION, target.global_position)
			return SUCCESS
	# if target_body != null:
	# 	blackboard.set_value(EnemyBlackboard.TARGET_POSITION, target_body.global_position)
	# 	blackboard.set_value(EnemyBlackboard.PLAYER_TARGET, target_body)
	# 	return SUCCESS
	# else:
	return FAILURE
	


