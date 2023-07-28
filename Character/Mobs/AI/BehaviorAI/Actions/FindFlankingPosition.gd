extends ActionLeaf


## Radius from target to find better position
@export_range(0.0, 200.0) var radius: float = 100.0

@onready var nav_agent: NavigationAgent2D = get_node_or_null("%PathFinder")

func tick(actor:Node, blackboard:Blackboard) -> int:
	var target: Player = blackboard.get_value(EnemyBlackboard.PLAYER_TARGET)

	if target == null:
		return FAILURE

	# # get random point in unit circle 
	# var rand_unit_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	# rand_unit_vector = rand_unit_vector.normalized()
	# var desired_position: Vector2 = rand_unit_vector * radius + target.global_position
	# nav_agent.target_position = desired_position
	# blackboard.set_value(EnemyBlackboard.TARGET_POSITION, target.global_position)

	var flanking_position: Vector2 = find_flanking_position(actor, target)
	nav_agent.target_position = flanking_position
	blackboard.set_value(EnemyBlackboard.TARGET_POSITION, flanking_position)

	return SUCCESS

func find_flanking_position(actor:Node, target:Player) -> Vector2:
	var flanking_comp: FlankingComponent = null
	for child in target.get_children():
		if child is FlankingComponent:
			flanking_comp = child
			break
	if flanking_comp:
		var valid_positions: PackedVector2Array = flanking_comp.find_flanking_positions()
		if valid_positions.is_empty():
			return target.global_position
		else:
			var nearest_position: Vector2 = valid_positions[0]
			for i in range(1, valid_positions.size()):
				var new_position: Vector2 = valid_positions[i]
				var new_dist = actor.global_position.distance_to(new_position)
				var old_dist = actor.global_position.distance_to(nearest_position)

				if new_dist < old_dist:
					nearest_position = new_position
			
			return nearest_position

	return target.global_position

