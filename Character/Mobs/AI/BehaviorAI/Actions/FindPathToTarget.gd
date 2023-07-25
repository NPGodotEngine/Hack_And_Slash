extends ActionLeaf

@onready var nav_agent: NavigationAgent2D = get_node_or_null("%NavigationAgent2D")

func tick(_actor:Node, blackboard:Blackboard) -> int:
	var target_pos: Vector2 = blackboard.get_value(EnemeyBlackboard.TARGET_POSITION)

	if target_pos:
		nav_agent.target_position = target_pos
		return SUCCESS
	return FAILURE
