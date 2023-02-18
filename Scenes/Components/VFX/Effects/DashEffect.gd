extends Node2D

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT


enum TRANSITION_TYPES  { 
    LINEAR = 0,
    SINE = 1,
    QUINT = 2,
    QUART = 3,
    QUAD = 4,
    EXPO = 5,
    ELASTIC = 6,
    CUBIC = 7,
    CIRC = 8,
    BOUNCE = 9,
    BACK = 10
}

enum EASE_TYPES {
    EASE_IN = 0,
    EASE_OUT = 1,
    EASE_IN_OUT = 2,
    EASE_OUT_IN = 3
}

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

# Transition type of tween
export (TRANSITION_TYPES) var trans_type: int = TRANSITION_TYPES.LINEAR

# Ease type of tween
export (EASE_TYPES) var ease_type: int = EASE_TYPES.EASE_IN_OUT

# Delay of tween
export (float) var delay: float = 0.0


onready var _tween: Tween = $Tween

func _ready() -> void:
    _tween.interpolate_property(self, "modulate", initial_color, final_color, 
        fade_duration, trans_type, ease_type, delay)
    _tween.interpolate_property(self, "scale", Vector2.ONE, Vector2.ONE / scale_factor, 
        fade_duration, trans_type, ease_type, delay)
    _tween.start()

func _physics_process(delta: float) -> void:
    if modulate.a <= 0.0:
        queue_free()
        
