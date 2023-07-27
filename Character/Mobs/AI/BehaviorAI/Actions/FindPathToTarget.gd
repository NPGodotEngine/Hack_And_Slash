extends ActionLeaf

@onready var nav_agent: NavigationAgent2D = get_node_or_null("%PathFinder")

func tick(_actor:Node, blackboard:Blackboard) -> int:
	var target = blackboard.get_value(EnemyBlackboard.PLAYER_TARGET)

	if target == null:
		return FAILURE

	nav_agent.target_position = target.global_position
	blackboard.set_value(EnemyBlackboard.TARGET_POSITION, target.global_position)
	return SUCCESS

