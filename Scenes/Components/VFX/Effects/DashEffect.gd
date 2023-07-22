extends Node2D

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT


enum TRANSITION_TYPES  { 
    LINEAR = Tween.TRANS_LINEAR,
    SINE = Tween.TRANS_SINE,
    QUINT = Tween.TRANS_QUINT,
    QUART = Tween.TRANS_QUART,
    QUAD = Tween.TRANS_QUAD,
    EXPO = Tween.TRANS_EXPO,
    ELASTIC = Tween.TRANS_ELASTIC,
    CUBIC = Tween.TRANS_CUBIC,
    CIRC = Tween.TRANS_CIRC,
    BOUNCE = Tween.TRANS_BOUNCE,
    BACK = Tween.TRANS_BACK,
    SPRING = Tween.TRANS_SPRING
}

enum EASE_TYPES {
    EASE_IN = 0,
    EASE_OUT = 1,
    EASE_IN_OUT = 2,
    EASE_OUT_IN = 3
}

# Fade duration
@export var fade_duration: float = 0.3

# Scale factor
##
# The higher the value the smaller it will scale to
# Default 1.0 not scale
@export_range(1.0, 10.0) var scale_factor: float = 1.0

# Initial color for modulate
@export var initial_color: Color = Color(1.0, 1.0, 1.0, 1.0)

# Final color for modulate
@export var final_color: Color = Color(1.0, 1.0, 1.0, 0.0)

# Delay of tween
@export var delay: float = 0.0

func _ready() -> void:
    var tween := create_tween()
    tween.tween_property(self, "modulate",final_color, fade_duration)\
        .set_trans(Tween.TRANS_LINEAR)\
        .set_ease(Tween.EASE_IN_OUT)\
        .set_delay(delay)
    tween.tween_property(self, "scale", Vector2.ONE / scale_factor, fade_duration)\
        .set_trans(Tween.TRANS_LINEAR)\
        .set_ease(Tween.EASE_IN_OUT)
    tween.tween_callback(queue_free)
        
