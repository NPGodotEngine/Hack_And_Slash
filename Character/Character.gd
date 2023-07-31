class_name Character
extends CharacterBody2D

# warning-ignore-all: UNUSED_SIGNAL

# Emit when character take damage
##
# `hit_damage`: type of HitDamage
# `total_damage`: total damage in integer
signal on_character_take_damage(hit_damage, total_damage)

## Emit when character is dead
signal on_character_dead()

## Whether character is dead or not
var is_dead: bool = false: set = set_is_dead

func set_is_dead(value:bool) -> void:
	is_dead = value

	if is_dead:
		emit_signal("on_character_dead")

func _ready():
	pass

func _process(_delta:float) -> void:
	pass

func _physics_process(_delta:float) -> void:
	pass
