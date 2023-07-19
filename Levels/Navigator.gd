extends Node2D

@export var agent: NodePath
@onready var nav_agent: NavigationAgent2D = get_node(agent) as NavigationAgent2D

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	nav_agent.path_desired_distance = 4.0
	nav_agent.target_desired_distance = 4.0

	nav_agent.connect("velocity_computed", Callable(self, "_on_velocity_computed"))

	call_deferred("actor_setup")

func actor_setup() -> void:
	await get_tree().physics_frame
	set_movement_target(get_parent().global_position)

func set_movement_target(movement_target: Vector2):
	nav_agent.set_target_position(movement_target)

func _physics_process(delta: float) -> void:
	super(delta)

	if Input.is_action_pressed("primary"):
		set_movement_target(get_global_mouse_position())
		return

	if nav_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = get_parent().global_position
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	print(next_path_position)

	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	(get_parent().get_node("MovementComponent") as MovementComponent).process_move(safe_velocity)
