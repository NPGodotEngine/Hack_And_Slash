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



## How fast can player turn from 
## one direction to another
##
## The higher the value the faster player can turn
## and less the smooth of player motion would be
@export_range(0.1, 1.0) var drag_factor: float = 0.5

## Movement speed
@export var movement_speed: float = 200.0

var _target: CharacterBody2D = null

## Movement speed multiplier
var movement_speed_multiplier: float = 1.0

## Current velocity
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

## Perform movement
## Called this method in physics process in order
## to update movement
##
## `direction`: movement direction
func process_move(direction:Vector2) -> void:
	if _target == null:
		push_error("Could not find target to move")
		return

	direction = direction.normalized()

	# transform movement speed
	var transformed_speed: float = transformMovementSpeed(movement_speed)

	# Smoothing player turing direction
	var desired_velocity := direction * transformed_speed
	var steering_velocity = desired_velocity - _velocity
	steering_velocity  = steering_velocity * drag_factor
	var new_velocity = _velocity + steering_velocity
	
	var prev_velocity: Vector2 = _velocity
	_target.set_velocity(new_velocity)
	_target.move_and_slide()
	_velocity = _target.velocity

	var velocity_context: VelocityContext = VelocityContext.new()
	velocity_context.previous_velocity = prev_velocity
	velocity_context.updated_velocity = _velocity

	emit_signal("velocity_updated", velocity_context)

## Transform a movement speed and
## return a new transformed movement speed
##
## `speed`: speed to be transformed
func transformMovementSpeed(speed:float) -> float:
	var new_speed: float = speed

	# apply speed multiplier
	new_speed *= movement_speed_multiplier

	# capped speed
	new_speed = min(max(new_speed, min_movement_speed), max_movement_speed)

	return new_speed
