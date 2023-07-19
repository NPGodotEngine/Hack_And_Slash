extends Control

# warning-ignore-all: UNUSED_ARGUMENT


@export var cursor_always_visible: bool = false

func _process(_delta: float) -> void:
	if cursor_always_visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		return

	var display_cursor: bool = true

	for child in get_children():
		if child.visible:
			display_cursor = false
			break
	
	if display_cursor:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
