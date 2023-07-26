extends ConditionLeaf

var the_target

func _ready() -> void:
	%TargetFinder.connect("target_found", Callable(self, "_update_target"))

func _update_target(target) -> void:
	the_target = target

func tick(_actor:Node, blackboard:Blackboard) -> int:
	if the_target != null:
		blackboard.set_value(EnemyBlackboard.TARGET_POSITION, the_target.global_position)
		blackboard.set_value(EnemyBlackboard.PLAYER_TARGET, the_target)
		the_target = null
		return SUCCESS
	else:
		blackboard.set_value(EnemyBlackboard.TARGET_POSITION, null)
		blackboard.set_value(EnemyBlackboard.PLAYER_TARGET, null)	
		return FAILURE