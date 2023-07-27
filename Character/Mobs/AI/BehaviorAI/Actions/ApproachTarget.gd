extends ActionLeaf


@onready var nav_agent: NavigationAgent2D = get_node_or_null("%NavigationAgent2D")
@onready var movement_comp: MovementComponent = get_node_or_null("%MovementComponent")

func _ready() -> void:
	nav_agent.connect("velocity_computed", Callable(self, "_on_velocity_computed"))


func tick(actor:Node, blackboard:Blackboard) -> int:
	var is_dead: bool = blackboard.get_value(EnemyBlackboard.IS_DEAD)

	if is_dead:
		nav_agent.set_velocity(Vector2.ZERO)
		return FAILURE

	if nav_agent.distance_to_target() <= nav_agent.path_max_distance:
		nav_agent.set_velocity(Vector2.ZERO)
		return SUCCESS

	if nav_agent.is_navigation_finished():
		nav_agent.set_velocity(Vector2.ZERO)
		return SUCCESS

	# Move toward target
	var current_agent_position: Vector2 = actor.global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()

	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

	return RUNNING

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	movement_comp.process_move(safe_velocity)
