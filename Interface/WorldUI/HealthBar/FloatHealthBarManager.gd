extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED

func _ready() -> void:
    UIEvents.connect("add_float_health_bar_ui", self, "add_float_health_bar")

func add_float_health_bar(float_health_bar) -> void:
    add_child(float_health_bar)

