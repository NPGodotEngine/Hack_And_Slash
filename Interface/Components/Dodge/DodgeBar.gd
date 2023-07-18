class_name DodgeBar
extends MarginContainer

# warning-ignore-all: RETURN_VALUE_DISCARDED


@export var dodge_bar_over_color: Color = Color.DARK_GREEN
@export var dodge_bar_under_color: Color = Color.DARK_GRAY


@onready var bar_under: TextureProgressBar = $BarUnder
@onready var bar_over: TextureProgressBar = $BarOver

var dodge_value: float = 100.0: set = set_dodge_value
var max_dodge_value: float = 100.0: set = set_max_dodge_value

func set_dodge_value(value:float) -> void:
    bar_over.value = value
    
func set_max_dodge_value(value:float) -> void:
    bar_over.max_value = value
    bar_under.max_value = value
    bar_under.value = bar_under.max_value

func _ready() -> void:
    super._ready()
    
    update_bar_color()

func update_bar_color() -> void:
    bar_over.tint_progress = dodge_bar_over_color
    bar_under.tint_progress = dodge_bar_under_color