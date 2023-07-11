class_name DodgeBar
extends MarginContainer

# warning-ignore-all: RETURN_VALUE_DISCARDED


export (Color) var dodge_bar_over_color: Color = Color.darkgreen
export (Color) var dodge_bar_under_color: Color = Color.darkgray


onready var bar_under: TextureProgress = $BarUnder
onready var bar_over: TextureProgress = $BarOver

var dodge_value: float = 100.0 setget set_dodge_value
var max_dodge_value: float = 100.0 setget set_max_dodge_value

func set_dodge_value(value:float) -> void:
    bar_over.value = value
    
func set_max_dodge_value(value:float) -> void:
    bar_over.max_value = value
    bar_under.max_value = value
    bar_under.value = bar_under.max_value

func _ready() -> void:
	update_bar_color()

func update_bar_color() -> void:
    bar_over.tint_progress = dodge_bar_over_color
    bar_under.tint_progress = dodge_bar_under_color