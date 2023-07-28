@tool
class_name MovementComponent
extends Node2D

# warning-ignore-all: UNUSED_ARGUMENT


class VelocityContext extends Resource:
	var previous_velocity: Vector2 = Vector2.ZERO
	var updated_velocity: Vector2 = Vector2.ZERO

## Emit when velocity changed
##
## `velocity_context`: class `VelocityContext`
signal velocity_updated(velocity_context)



## Max movement speed
@export var max_movement_speed: float = 400.0

## Min movement speed
@export var min_movement_speed: float = 10.0

## Movement velocity a desired velocity to move
## @
## Set this value to make `CharacterBody2D` to move 
var movement_velocity: Vector2 = Vector2.ZERO



## How fast can player turn from 
## one direction to another
##
## The higher the value the faster player can turn
## and less the smooth of player motion would be
@export_range(0.1, 1.0) var drag_factor: float = 0.5

## Movement speed
@export var movement_speed: float = 200.0

var _target: CharacterBody2D = null


## Current velocity
## or tracked velocity which
## is calculated from `move_and_slide`
var _velocity: Vector2 = Vector2.ZERO

func _get_configuration_warnings() -> PackedStringArray:
	if not is_instance_of(get_parent(), CharacterBody2D):
		return ["This node must be a child of CharacterBody2D node"]

	return []

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	await get_parent().ready
	_target = get_parent() as CharacterBody2D

func _physics_process(_delta) -> void:
	if Engine.is_editor_hint():
		return

	if _target == null:
		push_error("Could not find target to move")
		return

	# Smoothing player turing direction
	var steering_velocity = movement_velocity - _velocity
	steering_velocity  = steering_velocity * drag_factor
	var new_velocity = _velocity + steering_velocity
	
	var prev_velocity: Vector2 = _velocity
	_target.velocity = new_velocity
	_target.move_and_slide()
	_velocity = _target.velocity

	var velocity_context: VelocityContext = VelocityContext.new()
	velocity_context.previous_velocity = prev_velocity
	velocity_context.updated_velocity = _velocity

	emit_signal("velocity_updated", velocity_context)

## Return velocity for given direction and speed
## @
## `direction`: normalized `Vector2`
## `speed`: default to `movement_speed` if not given
func direction_to_velocity(direction:Vector2, speed:float=movement_speed):
	if not direction.is_normalized():
		direction.normalized()
	return direction * speed
