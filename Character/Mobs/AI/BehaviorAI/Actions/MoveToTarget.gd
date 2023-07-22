@tool
extends ActionLeaf

@export var move_component_ref: NodePath

@onready var _move_comp: MovementComponent = get_node_or_null(move_component_ref)

func _get_configuration_warnings():
	if move_component_ref.is_empty():
		return ["move component node path is missin"]
	if not get_node(move_component_ref) is MovementComponent:
		return ["move component must be a MovementComponent"]
	return []

func tick(actor:Node, blackboard:Blackboard):
	if blackboard.get_value("detected_target") != null:
		var target = blackboard.get_value("detected_target")
		_move_comp.process_move(actor.global_position.direction_to(target.global_position))
		return RUNNING
	return FAILURE
