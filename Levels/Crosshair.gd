extends Node2D

# warning-ignore-all: UNUSED_ARGUMENT


func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:
    global_position = get_global_mouse_position()