extends ConditionLeaf

@onready var vision_area: Area2D = get_node_or_null("%Vision/VisionConeArea")

var target_body: Player

func _ready() -> void:
	vision_area.connect("body_entered", Callable(self, "_on_body_entered"))
	vision_area.connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body:Node) -> void:
	if body is Player:
		target_body = body

func _on_body_exited(body:Node) -> void:
	if target_body == body:
		target_body = null

func tick(_actor:Node, blackboard:Blackboard) -> int:
	if target_body != null:
		blackboard.set_value(EnemeyBlackboard.TARGET_POSITION, target_body.global_position)
		blackboard.set_value(EnemeyBlackboard.PLAYER_TARGET, target_body)
		return SUCCESS
	else:
		return FAILURE
	


