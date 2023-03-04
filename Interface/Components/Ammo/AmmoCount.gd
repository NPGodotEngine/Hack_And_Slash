class_name AmmoCount
extends MarginContainer

# warning-ignore-all: RETURN_VALUE_DISCARDED


export (float) var anim_duration: float = 0.2
export (float) var deplete_anim_duration: float = 1.0
export (Vector2) var scale_to: Vector2 = Vector2(2.0, 2.0)
export (Color) var from_color: Color = Color.white
export (Color) var to_color: Color = Color.red


onready var current_ammo: Label = $HBoxContainer/CurrentAmmo
onready var max_ammo: Label = $HBoxContainer/MaxAmmo
onready var tween: Tween = $Tween

var ammo_count: int setget set_ammo_count
var max_ammo_count: int setget set_max_ammo_count

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
    current_ammo.rect_pivot_offset = current_ammo.rect_size / 2.0

    tween.interpolate_property(current_ammo, "rect_scale", 
        Vector2.ONE,scale_to, anim_duration/ 2.0, 
        _transition_type, tween.EASE_IN_OUT)
    tween.interpolate_property(current_ammo, "rect_scale", 
        scale_to, Vector2.ONE, anim_duration/ 2.0, 
        _transition_type, tween.EASE_OUT_IN, anim_duration/ 2.0)

    tween.interpolate_property(current_ammo, "modulate", 
        from_color, to_color, anim_duration/ 2.0, 
        _transition_type, tween.EASE_IN_OUT)
    tween.interpolate_property(current_ammo, "modulate", 
        to_color, from_color, anim_duration/ 2.0, 
        _transition_type, tween.EASE_OUT_IN, anim_duration/ 2.0)

    tween.repeat = false
    tween.start()

func ammo_deplete_anim() -> void:
    current_ammo.rect_pivot_offset = current_ammo.rect_size / 2.0
    current_ammo.rect_scale = Vector2.ONE

    tween.interpolate_property(current_ammo, "modulate", 
        from_color, to_color, deplete_anim_duration/ 2.0, 
        Tween.TRANS_LINEAR, tween.EASE_IN_OUT)
    tween.interpolate_property(current_ammo, "modulate", 
        to_color, from_color, deplete_anim_duration/ 2.0, 
        Tween.TRANS_LINEAR, tween.EASE_OUT_IN, deplete_anim_duration/ 2.0)

    tween.repeat = true
    tween.start()