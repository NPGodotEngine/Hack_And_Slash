extends Node2D

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT

# Fade duration
export (float) var fade_duration: float = 0.3

# Scale factor
##
# The higher the value the smaller it will scale to
# Default 1.0 not scale
export (float, 1.0, 10.0) var scale_factor: float = 1.0

# Initial color for modulate
export (Color) var initial_color: Color = Color(1.0, 1.0, 1.0, 1.0)

# Final color for modulate
export (Color) var final_color: Color = Color(1.0, 1.0, 1.0, 0.0)


onready var _tween: Tween = $Tween

func _ready() -> void:
    _tween.interpolate_property(self, "modulate", initial_color, final_color, fade_duration)
    _tween.interpolate_property(self, "scale", Vector2.ONE, Vector2.ONE / scale_factor, fade_duration)
    _tween.start()

func _physics_process(delta: float) -> void:
    if modulate.a <= 0.0:
        queue_free()
        
