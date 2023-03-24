extends ActionLeaf


func tick(actor, blackboard):
	if blackboard.get("detected_target") != null:
		print("Attack target")
		return RUNNING
	return FAILURE
