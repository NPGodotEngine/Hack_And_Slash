extends ActionLeaf


@onready var nav_agent: NavigationAgent2D = get_node_or_null("%NavigationAgent2D")
@onready var movement_comp: MovementComponent = get_node_or_null("%MovementComponent")



func tick(actor:Node, blackboard:Blackboard) -> int:
	var is_dead: bool = blackboard.get_value(EnemyBlackboard.IS_DEAD)

	connect_nav_agent()

	if is_dead:
		nav_agent.set_velocity(Vector2.ZERO)
		movement_comp.movement_direction = Vector2.ZERO
		disconnect_nav_agent()
		return FAILURE

	if nav_agent.distance_to_target() <= nav_agent.target_desired_distance:
		nav_agent.set_velocity(Vector2.ZERO)
		movement_comp.movement_direction = Vector2.ZERO
		disconnect_nav_agent()
		return SUCCESS

	if nav_agent.is_navigation_finished():
		nav_agent.set_velocity(Vector2.ZERO)
		movement_comp.movement_direction = Vector2.ZERO
		disconnect_nav_agent()
		return SUCCESS

	# Move toward target
	var current_agent_position: Vector2 = actor.global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()

	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	if nav_agent.avoidance_enabled:
		nav_agent.velocity = new_velocity
	else:
		_on_velocity_computed(new_velocity)

	return RUNNING

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	movement_comp.movement_direction = safe_velocity

func connect_nav_agent() -> void:
	if not nav_agent.is_connected("velocity_computed", Callable(self, "_on_velocity_computed")):
		nav_agent.connect("velocity_computed", Callable(self, "_on_velocity_computed"))

func disconnect_nav_agent() -> void:
	if nav_agent.is_connected("velocity_computed", Callable(self, "_on_velocity_computed")):
		nav_agent.disconnect("velocity_computed", Callable(self, "_on_velocity_computed"))