# A class for player controlled character
##
# Manage visual, skills, movement, input
class_name Player
extends Character

# Player movement speed
export var movement_speed := 250.0

# How fast can player turn from 
# one direction to another
#
# The higher the value the faster player can turn
# and less the smooth of player motion
export (float, 0.1, 1.0) var drag_factor := 0.5

# Player skin visual
onready var skin := $Skin

# Fire position
onready var fire_position := $Pointer/Position2D

onready var health_bar := $HealthBar

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

	print("level:%d, exp:%d, next_exp:%d" % [level, current_exp, next_level_exp_requried])

func physics_tick(_delta: float) -> void:
	_move()
	_update_skin()
	_execute_skills()

func _move() -> void:
	# Get direction from input
	var direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

	# Smoothing player turing direction
	var desired_velocity := direction * movement_speed
	var steering_velocity = desired_velocity - velocity
	steering_velocity  = steering_velocity * drag_factor
	velocity += steering_velocity

	# Move player
	velocity = move_and_slide(velocity)

func _update_skin() -> void:
	# Update skin 
	var global_mouse_position := get_global_mouse_position()

	if global_mouse_position.x < global_position.x:
		skin.face_left()
	else:
		skin.face_right()

func _execute_skills() -> void:
	assert(skill_manager, "skill manager missing")

	# get shooting direction
	var direction = (get_global_mouse_position() - fire_position.global_position).normalized()

	# execute skills 
	if Input.is_action_pressed("primary"): 
		skill_manager.execute_skill(0, fire_position.global_position, direction)
	if Input.is_action_pressed("secondary"):
		skill_manager.execute_skill(1, fire_position.global_position, direction)

func _update_health_bar() -> void:
	health_bar.min_value = float(0)
	health_bar.max_value = float(max_health)
	health_bar.value = float(health)

func _on_health_changed(_from_health:int, _to_health:int) -> void:
	_update_health_bar()

func _on_max_health_changed(_from_max_health:int, _to_max_health:int) -> void:
	_update_health_bar()

func _on_take_damage(_amount:int) -> void:
	_update_health_bar()

func _on_die(_character:Character) -> void:
	print("player die %d / %d" %[health, max_health])

# # for testing health bar
# func _unhandled_input(event: InputEvent) -> void:
# 	var logging: bool = false

# 	if event.is_action_pressed("ui_down"): 
# 		add_exp(randi() % 10 + 1)
# 		logging = true
	
# 	if event.is_action_pressed("ui_left"):
# 		take_damge(randi()% 10 + 1)
# 		logging = true

# 	if logging:
# 		print("level:%d, max_level:%d exp:%d, next_exp:%d, health:%d, max_health:%d, dead:%s" % 
# 			[level, get_max_level(), current_exp, next_level_exp_requried, health, max_health, is_dead])
	