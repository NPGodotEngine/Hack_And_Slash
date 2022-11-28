class_name Player
extends KinematicBody2D

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

# Player current velocity
var velocity := Vector2.ZERO

func _physics_process(_delta: float) -> void:
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

    # Update skin 
    var global_mouse_position := get_global_mouse_position()

    if global_mouse_position.x < global_position.x:
        skin.face_left()
    else:
        skin.face_right() 