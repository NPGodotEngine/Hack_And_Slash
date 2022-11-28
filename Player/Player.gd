class_name Player
extends KinematicBody2D

# Player movement speed
export var movement_speed := 200.0

# Player current velocity
var velocity := Vector2.ZERO

func _physics_process(delta: float) -> void:
    # Get direction from input
    var direction: Vector2 = Vector2(
        Input.get_axis("move_left", "move_right"),
        Input.get_axis("move_up", "move_down")
    ).normalized()

    velocity = direction * movement_speed
    velocity = move_and_slide(velocity)