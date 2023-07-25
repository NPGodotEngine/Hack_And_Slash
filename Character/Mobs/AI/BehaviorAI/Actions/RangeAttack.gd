extends ActionLeaf


func tick(_actor:Node, blackboard:Blackboard) -> int:
	print("range attack %s" % blackboard.get_value(EnemeyBlackboard.PLAYER_TARGET).name)
	return SUCCESS
