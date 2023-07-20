class_name Character
extends CharacterBody2D

# warning-ignore-all: UNUSED_SIGNAL

# Emit when character take damage
##
# `hit_damage`: type of HitDamage
# `total_damage`: total damage in integer
signal on_character_take_damage(hit_damage, total_damage)

func _ready():
	pass

func _process(_delta:float) -> void:
	pass

func _physics_process(_delta:float) -> void:
	pass
