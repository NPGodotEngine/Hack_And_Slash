extends Node2D

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT

onready var upper_body_animator: AnimationPlayer = $UpperAnimator
onready var lower_body_animator: AnimationPlayer = $LowerAnimator

var _character: Character = null

func _ready() -> void:
    _character = get_parent()
    assert(_character, "PlayerSkin must be a child of Character")

    _character.connect("character_velocity_changed", self, "_on_character_velocity_changed")

    upper_body_animator.play("idle")

func _on_character_velocity_changed(prev_velocity, velocity) -> void:
    if Vector2.ZERO.is_equal_approx(velocity):
        upper_body_animator.play("idle")
        lower_body_animator.stop()
        lower_body_animator.seek(0)
    else:
        upper_body_animator.stop()
        upper_body_animator.seek(0)
        lower_body_animator.play("run")

