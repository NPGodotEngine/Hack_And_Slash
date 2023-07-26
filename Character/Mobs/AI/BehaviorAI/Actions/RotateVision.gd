extends ActionLeaf

## Angle offset
@export_range(-360.0, 360.0) var angle_offset: float = 0.0

## `true` to lerp rotation
@export var interpolate: bool = true

## How fast should it be rotated
@export_range(0.01, 1.0) var rotation_speed: float = 1.0


@onready var vision: VisionCone2D = get_node_or_null("%Vision")

var elapsed: float = 0.0

func tick(_actor:Node, blackboard:Blackboard) -> int:

	var target_pos: Vector2 = blackboard.get_value(EnemyBlackboard.TARGET_POSITION)

	if target_pos == null:
		return FAILURE
	
	var current_rot: float = vision.global_rotation
	var target_rot: float = current_rot + vision.get_angle_to(target_pos) + deg_to_rad(angle_offset)

	if is_equal_approx(current_rot, target_rot):
		elapsed = 0.0
		return SUCCESS
	
	if interpolate:
		vision.global_rotation = lerp_angle(current_rot, target_rot, clampf(elapsed, 0.0, 1.0))
		elapsed += get_process_delta_time() * rotation_speed
	else:
		vision.global_rotation = lerp_angle(current_rot, target_rot, 1.0)

	return RUNNING
