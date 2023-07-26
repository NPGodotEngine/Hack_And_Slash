extends ActionLeaf

@onready var weapon: Weapon = get_node_or_null("%WeaponPlaceholder").get_child(0)

func tick(_actor:Node, blackboard:Blackboard) -> int:
	var target_pos: Vector2 = blackboard.get_value(EnemyBlackboard.TARGET_POSITION)

	if target_pos == null:
		return FAILURE

	weapon.weapon_point_at_position = target_pos

	var current_rot: float = weapon.global_rotation
	var target_rot: float = current_rot + weapon.get_angle_to(target_pos)
	# if weapon point at target position
	if is_equal_approx(current_rot, target_rot):
		return SUCCESS
	
	return RUNNING
