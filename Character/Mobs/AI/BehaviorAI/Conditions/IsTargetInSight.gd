extends ConditionLeaf


@export var line_of_sight_ref: NodePath

@onready var _line_of_sight: LineOfSight = get_node_or_null(line_of_sight_ref)

func tick(_actor:Node, blackboard:Blackboard):
	var target = blackboard.get_value("detected_target")
	if _line_of_sight.isTargetInSight(target):
		print("Target accquired")
		return SUCCESS
	else:
		return FAILURE