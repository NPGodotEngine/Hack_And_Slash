extends ConditionLeaf

func tick(_actor:Node, blackboard:Blackboard) -> int:
	var is_dead: bool = blackboard.get_value(EnemeyBlackboard.IS_DEAD)
	
	if is_dead:
		return FAILURE
	return SUCCESS
