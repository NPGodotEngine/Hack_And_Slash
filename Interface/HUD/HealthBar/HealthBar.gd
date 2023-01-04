class_name HealthBar
extends Control

# warning-ignore-all: RETURN_VALUE_DISCARDED

export (float) var interpolation_duration: float = 0.4
export (float) var interpolation_delay: float = 0.3

export (Color) var health_color: Color = Color.green
export (Color) var caution_color: Color = Color.yellow
export (Color) var low_color: Color = Color.red

export (float, 0.0, 1.0) var caution_threshold_scale: float = 0.5
export (float, 0.0, 1.0) var low_threshold_scale: float = 0.25

onready var health_bar_under: TextureProgress = $HealthBarUnder
onready var health_bar_over: TextureProgress = $HealthBarOver
onready var tween: Tween = $Tween

var health: float = 100.0 setget set_health
var max_health: float = 100.0 setget set_max_health

func set_health(value:float) -> void:
    var prev_health = health
    health = round(value)

    # set value 
    health_bar_over.value = health
    
    # set color of health
    if(health < max_health * low_threshold_scale or
            is_equal_approx(health, max_health * low_threshold_scale)):
        health_bar_over.tint_progress = low_color
    elif (health < max_health * caution_threshold_scale or
        is_equal_approx(health, max_health * caution_threshold_scale)):
        health_bar_over.tint_progress = caution_color
    else:
        health_bar_over.tint_progress = health_color

    # tween health bar under
    tween.interpolate_property(health_bar_under, "value", prev_health, health, 
        interpolation_duration, Tween.TRANS_SINE, Tween.EASE_OUT, interpolation_delay)
    tween.start() 

func set_max_health(value:float) -> void:
    max_health = round(value)

    health_bar_over.max_value = max_health
    health_bar_under.max_value = max_health

