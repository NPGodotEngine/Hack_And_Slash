class_name DashBar
extends MarginContainer

# warning-ignore-all: RETURN_VALUE_DISCARDED


export (Color) var dash_bar_over_color: Color = Color.darkgreen
export (Color) var dash_bar_under_color: Color = Color.darkgray


onready var bar_under: TextureProgress = $BarUnder
onready var bar_over: TextureProgress = $BarOver

var dash_value: float = 100.0 setget set_dash_value
var max_dash_value: float = 100.0 setget set_max_dash_value

func set_dash_value(value:float) -> void:
    bar_over.value = value
    
func set_max_dash_value(value:float) -> void:
    bar_over.max_value = value
    bar_under.max_value = value
    bar_under.value = bar_under.max_value

func _ready() -> void:
	update_bar_color()

func update_bar_color() -> void:
    bar_over.tint_progress = dash_bar_over_color
    bar_under.tint_progress = dash_bar_under_color