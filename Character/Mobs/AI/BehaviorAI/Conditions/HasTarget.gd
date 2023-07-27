extends ConditionLeaf

var new_target

@onready var target_finder: Node2D = get_node_or_null("%TargetFinder")

func _ready() -> void:
	target_finder.connect("target_found", Callable(self, "_update_target"))

func _update_target(target) -> void:
	new_target = target

func tick(_actor:Node, blackboard:Blackboard) -> int:
	var old_target = blackboard.get_value(EnemyBlackboard.PLAYER_TARGET)

	if new_target != old_target:
		blackboard.set_value(EnemyBlackboard.PLAYER_TARGET, new_target)
		new_target = null
		return SUCCESS
	else:
		return SUCCESS
		