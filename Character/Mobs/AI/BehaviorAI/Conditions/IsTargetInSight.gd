@tool
extends ConditionLeaf


@export var line_of_sight_ref: NodePath

@onready var _line_of_sight: LineOfSight = get_node_or_null(line_of_sight_ref)

func _get_configuration_warnings():
	if line_of_sight_ref.is_empty():
		return ["line of sight node path is missin"]
	if not get_node(line_of_sight_ref) is LineOfSight:
		return ["line of sight must be a LineOfSight"]
	return []

func tick(_actor:Node, blackboard:Blackboard):
	var target = blackboard.get_value("detected_target")
	if _line_of_sight.isTargetInSight(target):
		print("Target accquired")
		return SUCCESS
	else:
		return FAILURE