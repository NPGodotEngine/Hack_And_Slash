extends ConditionLeaf


func tick(_actor:Node, blackboard:Blackboard) -> int:
	var target: Player = blackboard.get_value(EnemyBlackboard.PLAYER_TARGET)

	if target == null:
		return SUCCESS
	
	if target.is_dead:
		return SUCCESS
	
	return FAILURE
