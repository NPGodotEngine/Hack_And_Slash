extends ActionLeaf

@onready var mob_skin: AnimatedSprite2D = get_node_or_null("%MobSkin")

func tick(_actor:Node, blackboard:Blackboard) -> int:
	var target_pos: Vector2 = blackboard.get_value(EnemyBlackboard.TARGET_POSITION)

	if target_pos == null:
		return FAILURE
	
	if target_pos.x < mob_skin.global_position.x:
		mob_skin.flip_h = true
	else:
		mob_skin.flip_h = false

	return SUCCESS
	

