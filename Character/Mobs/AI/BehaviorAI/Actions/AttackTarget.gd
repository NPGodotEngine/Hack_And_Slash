extends ActionLeaf


func tick(_actor:Node, blackboard:Blackboard):
	if blackboard.get_value("detected_target") != null:
		print("Attack target")
		return RUNNING
	return FAILURE
