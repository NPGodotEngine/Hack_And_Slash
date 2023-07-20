class_name DamageLabel
extends Node2D

# warning-ignore-all: RETURN_VALUE_DISCARDED

@export var _gravity = Vector2(0.0, 980)

@export_range(-400, 0.0) var _left_bound: float = -100.0
@export_range(0.0, 400) var _right_bound: float = 100.0

@export var _jump_force = -200.0

@onready var _label := $Label
@onready var _animation_player := $AnimationPlayer
@onready var _destroy_timer := $DestroyTimer

var _velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	var rand_x = randf_range(_left_bound, _right_bound)
	_velocity = Vector2(rand_x, _jump_force)

	_destroy_timer.connect("timeout", Callable(self, "queue_free"))

func _process(delta: float) -> void:

	_velocity += _gravity * delta
	global_position += _velocity * delta

func set_damage(damage:String, critical:bool, color:Color = Color.WHITE, 
	outline_color:Color = Color.BLACK, prefix:String = "-", suffix:String = "") -> void:
	_label.text = prefix + damage + suffix
	_label.set("theme_override_colors/font_color", color)
	_label.set("theme_override_colors/font_outline_color", outline_color)

	if critical:
		_animation_player.play("critical")
	else:
		_animation_player.play("damage")

