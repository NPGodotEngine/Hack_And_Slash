extends ActionLeaf


## Radius from target to find better position
@export_range(0.0, 200.0) var radius: float = 100.0

@onready var nav_agent: NavigationAgent2D = get_node_or_null("%PathFinder")

func tick(_actor:Node, blackboard:Blackboard) -> int:
	var target: Player = blackboard.get_value(EnemyBlackboard.PLAYER_TARGET)

	if target == null:
		return FAILURE

	# get random point in unit circle 
	var rand_unit_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	rand_unit_vector = rand_unit_vector.normalized()
	var desired_position: Vector2 = rand_unit_vector * radius + target.global_position
	nav_agent.target_position = desired_position
	blackboard.set_value(EnemyBlackboard.TARGET_POSITION, target.global_position)

	return SUCCESS
