@tool
extends NavigationAgent2D

## NodePath to MovementComponent node
@export var movement_ref: NodePath

@onready var _movement_comp: MovementComponent = get_node_or_null(movement_ref)

func _get_configuration_warnings():
	if not get_parent() is CharacterBody2D:
		return ["This node must be a child of CharacterBody2D node"]
	if movement_ref.is_empty():
		return ["movement_ref node path missing"]
	if not get_node(movement_ref) is MovementComponent:
		return ["movement_ref must be a MovementComponent node"]
	
	return []

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	connect("velocity_computed", Callable(self, "_on_velocity_computed"))

func _physics_process(_delta):
	if Engine.is_editor_hint():
		return

	if is_navigation_finished():
		return

	if distance_to_target() <= target_desired_distance:
		target_position = get_parent().global_position
		return

	# sync avoidance speed from movement component
	max_speed = _movement_comp.max_movement_speed

	# Move toward target
	var current_agent_position: Vector2 = get_parent().global_position
	var next_path_position: Vector2 = get_next_path_position()

	var direction: Vector2 = (next_path_position - current_agent_position).normalized()
	var new_velocity = _movement_comp.direction_to_velocity(direction)
	if avoidance_enabled:
		velocity = new_velocity
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	_movement_comp.movement_velocity = safe_velocity