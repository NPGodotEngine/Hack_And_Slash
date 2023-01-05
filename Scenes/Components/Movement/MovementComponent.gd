tool
class_name MovementComponent
extends Node

# warning-ignore-all: UNUSED_ARGUMENT


class VelocityContext extends Resource:
    var previous_velocity: Vector2 = Vector2.ZERO
    var updated_velocity: Vector2 = Vector2.ZERO

# Emit when velocity changed
##
# `velocity_context`: class `VelocityContext`
signal velocity_updated(velocity_context)



# Node path to KenimaticBody2D
export(NodePath) var target: NodePath

# Max movement speed
export (float) var max_movement_speed: float = 400.0

# Min movement speed
export (float) var min_movement_speed: float = 10.0

# How fast can player turn from 
# one direction to another
##
# The higher the value the faster player can turn
# and less the smooth of player motion would be
export (float, 0.1, 1.0) var drag_factor: float = 0.5

# Movement speed
export (float) var movement_speed: float = 200.0

onready var _target: KinematicBody2D = get_node(target)

# Movement speed multiplier
var movement_speed_multiplier: float = 1.0


# Current velocity
var _velocity: Vector2 = Vector2.ZERO

func _get_configuration_warning() -> String:
    if target.is_empty():
        return "target node path is missing"
    
    if not get_node(target) is KinematicBody2D:
        return "target must be a KinematicBody2D node" 

    return ""

# Return a `Vector2` for new movement velocity
##
# `direction`: desired movement direction
func move(direction:Vector2) -> void:
    if _target == null or target.is_empty():
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
    _velocity = _target.move_and_slide(new_velocity)

    var velocity_context: VelocityContext = VelocityContext.new()
    velocity_context.previous_velocity = prev_velocity
    velocity_context.updated_velocity = _velocity

    emit_signal("velocity_updated", velocity_context)

# Transform a movement speed and
# return a new transformed movement speed
##
# `speed`: speed to be transformed
func transformMovementSpeed(speed:float) -> float:
    var new_speed: float = speed

    # apply speed multiplier
    new_speed *= movement_speed_multiplier

    # capped speed
    new_speed = min(max(new_speed, min_movement_speed), max_movement_speed)

    return new_speed