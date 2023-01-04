class_name MovementComponent
extends Node

# warning-ignore-all: UNUSED_ARGUMENT


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

# Movement speed multiplier
var movement_speed_multiplier: float = 1.0



# Return a `Vector2` for new movement velocity
##
# `velocity`: current velocity
# `direction`: desired movement direction
func move(velocity:Vector2, direction:Vector2) -> Vector2:

    direction = direction.normalized()

    # transform movement speed
    var transformed_speed: float = transformMovementSpeed(movement_speed)

    # Smoothing player turing direction
    var desired_velocity := direction * transformed_speed
    var steering_velocity = desired_velocity - velocity
    steering_velocity  = steering_velocity * drag_factor
    var new_velocity = velocity + steering_velocity

    return new_velocity

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