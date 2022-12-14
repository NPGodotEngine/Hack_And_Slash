class_name DamageLabel
extends Node2D

export (Vector2) var _gravity = Vector2(0.0, 980)

export (float, -400, 0.0) var _left_bound = -100.0
export (float, 0.0, 400) var _right_bound = 100.0

export (float) var _jump_force = -200.0

onready var _label := $Label
onready var _animation_player := $AnimationPlayer

var _velocity: Vector2 = Vector2.ZERO

func _init() -> void:
    set_as_toplevel(true)

func _ready() -> void:
    var rand_x = rand_range(_left_bound, _right_bound)
    _velocity = Vector2(rand_x, _jump_force)


func _process(delta: float) -> void:
    _velocity += _gravity * delta
    global_position += _velocity * delta

func set_damage(damage:int, critical:bool, color:Color = Color.white, 
    outline_color:Color = Color.black, prefix:String = "-", suffix:String = "") -> void:
    yield(self, "ready")
    _label.text = prefix + str(damage) + suffix
    _label.set("custom_colors/font_color", color)
    _label.set("custom_colors/font_outline_modulate", outline_color)

    if critical:
        _animation_player.play("critical")
    else:
        _animation_player.play("damage")

