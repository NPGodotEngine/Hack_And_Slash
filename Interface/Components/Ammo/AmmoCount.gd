class_name AmmoCount
extends MarginContainer

# warning-ignore-all: RETURN_VALUE_DISCARDED


@export var anim_duration: float = 0.2
@export var deplete_anim_duration: float = 1.0
@export var scale_to: Vector2 = Vector2(2.0, 2.0)
@export var from_color: Color = Color.WHITE
@export var to_color: Color = Color.RED


@onready var current_ammo: Label = $HBoxContainer/CurrentAmmo
@onready var max_ammo: Label = $HBoxContainer/MaxAmmo

var ammo_count: int: set = set_ammo_count
var max_ammo_count: int: set = set_max_ammo_count

var _transition_type: int = Tween.TRANS_QUART
    
    
func set_ammo_count(value:int) -> void:
    ammo_count = value
    current_ammo.text = str(ammo_count)

    if ammo_count != 0:
        consume_ammo_anim()
    else:
        ammo_deplete_anim()

func set_max_ammo_count(value:int) -> void:
    max_ammo_count = value
    max_ammo.text = str(max_ammo_count)

func consume_ammo_anim() -> void:
    current_ammo.pivot_offset = current_ammo.size / 2.0

    var scale_tween := create_tween()
    scale_tween.tween_property(current_ammo, "scale", scale_to, anim_duration/ 2.0)\
        .set_trans(_transition_type)\
        .set_ease(Tween.EASE_IN_OUT)
    scale_tween.tween_property(current_ammo, "scale", Vector2.ONE, anim_duration/ 2.0)\
        .set_trans(_transition_type)\
        .set_ease(Tween.EASE_OUT_IN)

    var color_tween := create_tween()
    color_tween.tween_property(current_ammo, "modulate", to_color, anim_duration/ 2.0)\
        .set_trans(_transition_type)\
        .set_ease(Tween.EASE_IN_OUT) 
    color_tween.tween_property(current_ammo, "modulate", from_color, anim_duration/ 2.0)\
        .set_trans(_transition_type)\
        .set_ease(Tween.EASE_OUT_IN)

func ammo_deplete_anim() -> void:
    current_ammo.pivot_offset = current_ammo.size / 2.0
    current_ammo.scale = Vector2.ONE

    var color_tween := create_tween()
    color_tween.tween_property(current_ammo, "modulate", to_color, deplete_anim_duration/ 2.0)\
        .set_trans(Tween.TRANS_LINEAR)\
        .set_ease(Tween.EASE_IN_OUT) 

    color_tween.tween_property(current_ammo, "modulate", from_color, deplete_anim_duration/ 2.0)\
        .set_trans(Tween.TRANS_LINEAR)\
        .set_ease(Tween.EASE_OUT_IN) 