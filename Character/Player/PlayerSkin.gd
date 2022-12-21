extends Node2D

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT

onready var upper_body_animator: AnimationPlayer = $UpperAnimator
onready var lower_body_animator: AnimationPlayer = $LowerAnimator

# Character this skin belong to
var _character: Character = null

func _ready() -> void:
    _character = get_parent()
    assert(_character, "PlayerSkin must be a child of Character")

    upper_body_animator.play("idle")

func _physics_process(delta: float) -> void:
    if abs(_character.velocity.x) <= 0.1 and abs(_character.velocity.y) <= 0.1:
        if not upper_body_animator.is_playing():
            upper_body_animator.play("idle")
        if lower_body_animator.is_playing():
            lower_body_animator.seek(0, true)
            lower_body_animator.stop()
    else:
        if upper_body_animator.is_playing():
            upper_body_animator.seek(0, true)
            upper_body_animator.stop()
        if not lower_body_animator.is_playing():
            lower_body_animator.play("run")

