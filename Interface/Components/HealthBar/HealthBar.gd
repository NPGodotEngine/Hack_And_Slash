class_name HealthBar
extends MarginContainer

# warning-ignore-all: RETURN_VALUE_DISCARDED

@export var interpolation_duration: float = 0.4
@export var interpolation_delay: float = 0.3

@export  var health_color: Color = Color.GREEN
@export  var caution_color: Color = Color.YELLOW
@export  var low_color: Color = Color.RED

@export var caution_threshold_scale: float = 0.5
@export var low_threshold_scale: float = 0.25

@onready var health_bar_under: TextureProgressBar = $HealthBarUnder
@onready var health_bar_over: TextureProgressBar = $HealthBarOver

var health: float = 100.0: set = set_health
var max_health: float = 100.0: set = set_max_health

func set_health(value:float) -> void:
	health = round(value)

	# set value 
	health_bar_over.value = health
	
	update_health_bar_color()

	# tween health bar under
	var value_tween := create_tween()
	value_tween.tween_property(health_bar_under, "value", health, interpolation_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)\
		.set_delay(interpolation_delay)

func set_max_health(value:float) -> void:
	max_health = round(value)

	health_bar_over.max_value = max_health
	health_bar_under.max_value = max_health

func _ready() -> void:
	update_health_bar_color()

func update_health_bar_color() -> void:
	# set color of health
	if(health < max_health * low_threshold_scale or
		is_equal_approx(health, max_health * low_threshold_scale)):
		health_bar_over.tint_progress = low_color
	elif (health < max_health * caution_threshold_scale or
		is_equal_approx(health, max_health * caution_threshold_scale)):
		health_bar_over.tint_progress = caution_color
	else:
		health_bar_over.tint_progress = health_color

