class_name Component
extends Node

# Call to setup component
func setup() -> void:
    yield(self, "ready")


