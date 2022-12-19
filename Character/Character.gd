# A generic class extended KinematicBody2D 
# and must be extended from object such as
# Player, Monster, NPC anything that is alive
##
# Class manage movement properties by default
class_name Character
extends KinematicBody2D

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: UNUSED_SIGNAL

# Emit when taking damage
signal take_damage(hit_damage, total_damage)

# Emit when character die
signal die(character)

# Emit when character's velocity has changed
signal character_velocity_changed(prev_velocity, velocity)



# Max movement speed reduction
const MAX_MOVEMENT_SPEED_REDUCTION = 0.9

# Min movement speed reduction
const MIN_MOVEMENT_SPEED_REDUCTION = 0.0

# Character's basic movement _speed
export var _movement_speed := 250.0

# How fast can player turn from 
# one direction to another
#
# The higher the value the faster player can turn
# and less the smooth of player motion
export (float, 0.1, 1.0) var _drag_factor := 0.5

# Scaled movement speed
# that is included movement speed reudction
var movement_speed: float = _movement_speed setget _no_set, get_movement_speed

# Total movement speed reduction
##
# Value is between min and max usually
# is 0.0 ~ 1.0 but depend on min max setting
var movement_speed_reduction: float = 0.0 setget set_movement_speed_reduction


# Is character dead
##
# Set to `true` make character dead
var is_dead:bool = false setget set_is_dead

# Components in character
var character_comps: Array = []

# Player current velocity
var velocity := Vector2.ZERO setget set_velocity

## Getter Setter ##


func _no_set(_value) -> void:
    push_warning("Set property not allowed")
    return

# Set character's velocity
func set_velocity(value:Vector2) -> void:
	var old_velocity: Vector2 = velocity
	velocity = value
	emit_signal("character_velocity_changed", old_velocity, velocity)

# Set movement speed reduction
##
# Cap value if it is not between min and max
func set_movement_speed_reduction(value:float) -> void:
	# Cap value between min and max
	var new_reduction: float = max(min(value, MAX_MOVEMENT_SPEED_REDUCTION), MIN_MOVEMENT_SPEED_REDUCTION)
	movement_speed_reduction = new_reduction

# Get scaled movement speed
##
# Speed is included speed reduction 
func get_movement_speed() -> float:
	return _movement_speed * (1.0 - movement_speed_reduction)

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
	for child in get_children():
		if child is Component:
			character_comps.append(child)
			child.setup()

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

# Character take damage
func take_damage(hit_damage:HitDamage) -> void:
	pass

# Character die
func die() -> void:
	set_process(false)
	set_physics_process(false)

# Add amount of reduction to movement speed reduction
##
# The ideal value for amount is between 0.1 ~ 0.9
func add_movement_speed_reduction(amount:float) -> void:
	set_movement_speed_reduction(movement_speed_reduction + amount)

# Remove amount of reduction to movement speed reduction
##
# The ideal value for amount is between 0.1 ~ 0.9
func remove_movement_speed_reduction(amount:float) -> void:
	set_movement_speed_reduction(movement_speed_reduction - amount)

# Return normalized Vector2 of character's shooting direction
##
# `normalized` if direction need to normalized, default is `true`
func get_shooting_direction(normalized:bool=true) -> Vector2:
	var direction: Vector2 = (get_global_mouse_position() - global_position) 
	return direction.normalized() if normalized else direction
