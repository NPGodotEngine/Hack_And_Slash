class_name AmmoCount
extends MarginContainer

onready var current_ammo: Label = $HBoxContainer/CurrentAmmo
onready var max_ammo: Label = $HBoxContainer/MaxAmmo

var ammo_count: int setget set_ammo_count
var max_ammo_count: int setget set_max_ammo_count

func set_ammo_count(value:int) -> void:
    ammo_count = value
    current_ammo.text = str(ammo_count)

func set_max_ammo_count(value:int) -> void:
    max_ammo_count = value
    max_ammo.text = str(max_ammo_count)