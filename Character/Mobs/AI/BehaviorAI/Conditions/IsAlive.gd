extends ConditionLeaf

@onready var nav_agent: NavigationAgent2D = get_node_or_null("%PathFinder")

func tick(actor:Node, blackboard:Blackboard) -> int:
	var is_dead: bool = blackboard.get_value(EnemyBlackboard.IS_DEAD)
	
	if is_dead:
		nav_agent.target_position = actor.global_position
		return FAILURE
	return SUCCESS
