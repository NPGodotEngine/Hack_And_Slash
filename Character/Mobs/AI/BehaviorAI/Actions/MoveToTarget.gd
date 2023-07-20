extends ActionLeaf

@export var move_component_ref: NodePath

@onready var _move_comp: MovementComponent = get_node(move_component_ref) as MovementComponent

func tick(actor:Node, blackboard:Blackboard):
	if blackboard.get_value("detected_target") != null:
		var target = blackboard.get_value("detected_target")
		_move_comp.process_move(actor.global_position.direction_to(target.global_position))
		return RUNNING
	return FAILURE
