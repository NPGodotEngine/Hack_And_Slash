extends ActionLeaf

export (NodePath) var move_component: NodePath

onready var _move_comp: MovementComponent = get_node(move_component) as MovementComponent

func tick(actor, blackboard):
	if blackboard.get("detected_target") != null:
		print("Move to target")
		var target = blackboard.get("detected_target")
		_move_comp.process_move(actor.global_position.direction_to(target.global_position))
		return RUNNING
	return FAILURE
