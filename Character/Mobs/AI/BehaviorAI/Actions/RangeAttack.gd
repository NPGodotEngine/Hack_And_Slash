extends ActionLeaf

@onready var weapon: Weapon = get_node_or_null("%WeaponPlaceholder").get_child(0)

func tick(_actor:Node, blackboard:Blackboard) -> int:
	var target_pos: Vector2 = blackboard.get_value(EnemyBlackboard.TARGET_POSITION)
	
	weapon.execute(target_pos)
	return SUCCESS
