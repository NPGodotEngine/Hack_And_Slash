# A class for player controlled character
##
# Manage visual, skills, movement, input
class_name Player
extends Character

# warning-ignore-all:RETURN_VALUE_DISCARDED

# Player skin visual
onready var _skin := $Skin

# Fire position
onready var _fire_position := $Pointer/Position2D

onready var _health_bar := $HealthBar

# Active skill holder
onready var skill_manager: SkillManager = $SkillManager

# Player current velocity
var velocity := Vector2.ZERO

func setup() -> void:
	.setup()
	
	connect("health_changed", self, "_on_health_changed")
	connect("max_health_changed", self, "_on_max_health_changed")
	connect("take_damage", self, "_on_take_damage")
	connect("die", self, "_on_die")

	_update_health_bar()

	logging()

func physics_tick(delta: float) -> void:
	.physics_tick(delta)

	_update_skin()
	_execute_skills()

func move_character(_delta:float) -> void:
	# Get direction from input
	var direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

	# Smoothing player turing direction
	var desired_velocity := direction * get_movement_speed()
	var steering_velocity = desired_velocity - velocity
	steering_velocity  = steering_velocity * _drag_factor
	velocity += steering_velocity

	# Move player
	velocity = move_and_slide(velocity)

func _update_skin() -> void:
	# Update skin 
	var global_mouse_position := get_global_mouse_position()

	if global_mouse_position.x < global_position.x:
		_skin.face_left()
	else:
		_skin.face_right()

func _execute_skills() -> void:
	assert(skill_manager, "skill manager missing")

	# get shooting direction
	var direction = (get_global_mouse_position() - _fire_position.global_position).normalized()

	# execute skills 
	if Input.is_action_pressed("primary"): 
		skill_manager.execute_skill(0, _fire_position.global_position, direction)
	elif Input.is_action_just_released("primary"):
		skill_manager.cancel_skill_execution(0)

	if Input.is_action_pressed("secondary"):
		skill_manager.execute_skill(1, _fire_position.global_position, direction)
	elif Input.is_action_just_released("secondary"):
		skill_manager.cancel_skill_execution(1)

func _update_health_bar() -> void:
	_health_bar.min_value = float(0)
	_health_bar.max_value = float(_max_health)
	_health_bar.value = float(_health)

func _on_health_changed(_from_health:int, _to_health:int) -> void:
	_update_health_bar()

func _on_max_health_changed(_from_max_health:int, _to_max_health:int) -> void:
	_update_health_bar()

func _on_take_damage(_hit_damage:HitDamage, _total_damage:int) -> void:
	_update_health_bar()

func _on_die(_character:Character) -> void:
	print("player die %d / %d" %[_health, _max_health])

# for testing health bar
func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("ui_down"): 
		add_exp(randi() % 10 + 1)
		logging()
	
	if event.is_action_pressed("ui_left"):
		var crit = randi()%2
		var hit_damage = HitDamage.new().init(
			null, 
			null, 
			randi()%10+1, 
			crit,
			Color.red if crit else Color.white)
		take_damage(hit_damage)
		logging()

func logging() -> void:
	print("level:%d, max_level:%d exp:%d, next_exp:%d, health:%d, max_health:%d, damage:%d, dead:%s" % 
			[_level, MAX_LEVEL, _current_exp, _next_level_exp_requried, _health, _max_health, _damage, _is_dead])
	print("movement_speed:%f, speed:%f, movement_reduction:%f" % [_movement_speed, get_movement_speed(), movement_speed_reduction])
		
	