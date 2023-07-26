extends ActionLeaf

@onready var weapon: Weapon = get_node_or_null("%WeaponPlaceholder").get_child(0)

func tick(_actor:Node, blackboard:Blackboard) -> int:
	var target: Player = blackboard.get_value(EnemyBlackboard.PLAYER_TARGET)
	
	if target == null:
		return FAILURE

	
	var movement_comp: MovementComponent
	for child in target.get_children():
		if child is MovementComponent:
			movement_comp = child
			break
	
	# predicting player movement 
	var desired_position: Vector2 = target.global_position
	var target_movement_dir: Vector2 = movement_comp._velocity.normalized()
	desired_position = desired_position + target_movement_dir * 10.0

	weapon.weapon_point_at_position = desired_position

	var current_rot: float = weapon.global_rotation
	var target_rot: float = current_rot + weapon.get_angle_to(desired_position)
	# if weapon point at target position
	if is_equal_approx(current_rot, target_rot):
		return SUCCESS
	
	return RUNNING
