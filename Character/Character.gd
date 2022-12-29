# A generic class extended KinematicBody2D 
# and must be extended from object such as
# Player, Monster, NPC anything that is alive
##
# Class manage movement properties by default
class_name Character
extends KinematicBody2D

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: UNUSED_SIGNAL

# Emit when character die
signal die(character)


# Character's max movement speed
##
# Final scaled speed would be capped to this value
# if it is greater than this value
export (float) var max_movement_speed: float = 400.0

# Character's min movement speed
##
# Final scaled speed would be capped to this value
# if it is lower than this value
export (float) var min_movement_speed: float = 0.0

# How fast can player turn from 
# one direction to another
#
# The higher the value the faster player can turn
# and less the smooth of player motion
export (float, 0.1, 1.0) var drag_factor: float = 0.5

# Character movement speed
##
# Get this value will return a movement speed
# scaled by movement speed multiplier
export (float) var movement_speed: float = 200.0 setget , get_movement_speed

# Total movement speed multiplier
##
# Value is between min and max usually
# is 0.0 ~ 1.0 but depend on min max setting
var movement_speed_multiplier: float = 0.0 setget set_movement_speed_multiplier


# Is character dead
##
# Set to `true` make character dead
var is_dead:bool = false setget set_is_dead

# Components in character
var character_comps: Array = []

# Player current velocity
var velocity := Vector2.ZERO

## Getter Setter ##


# Set movement speed multiplier
##
# Cap value if it is not between min and max
func set_movement_speed_multiplier(value:float) -> void:
	# Cap value between min and max
	movement_speed_multiplier = value

# Get scaled movement speed
##
# Speed is included speed multiplier 
func get_movement_speed() -> float:
	var speed: float = movement_speed + movement_speed * movement_speed_multiplier
	speed =  min(max(min_movement_speed, speed), max_movement_speed)
	return speed

## Getter Setter ##



# Set character's dead state
##
# Emit signal `die`
func set_is_dead(value:bool) -> void:
	if value == is_dead: return

	is_dead = value
	if is_dead:
		die()
		emit_signal("die", self)
## Getter Setter ##



## Override ##
func queue_free() -> void:
	if character_comps and character_comps.size() > 0:
		character_comps.clear()
	.queue_free()
	 
func _process(delta: float) -> void:
	process_tick(delta)

func _physics_process(delta: float) -> void:
	physics_tick(delta)
## Override ##



# Setup character
func setup() -> void:
	pass

# Get character component by name
func get_component_by_name(comp_name:String) -> Component:
	for comp in character_comps:
		if comp.name == comp_name:
			return comp
	return null

# Character process tick
func process_tick(delta) -> void:
	pass

# Character physics tick
func physics_tick(delta: float) -> void:
	move_character(delta)

# Move character
func move_character(delta:float) -> void:
	pass

# Character die
func die() -> void:
	set_process(false)
	set_physics_process(false)

# Increase amount of speed multiplier
##
# The ideal value for amount is between -1.0 ~ 1.0
func increase_speed_multiplier(amount:float) -> void:
	set_movement_speed_multiplier(movement_speed_multiplier + amount)

# Decrease amount of speed multiplier
##
# The ideal value for amount is between -1.0 ~ 1.0
func decrease_speed_multiplier(amount:float) -> void:
	set_movement_speed_multiplier(movement_speed_multiplier - amount)

# Return normalized Vector2 of character's shooting direction
##
# `normalized` if direction need to normalized, default is `true`
func get_shooting_direction(normalized:bool=true) -> Vector2:
	var direction: Vector2 = (get_global_mouse_position() - global_position) 
	return direction.normalized() if normalized else direction
