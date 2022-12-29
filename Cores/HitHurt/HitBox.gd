class_name HitBox
extends Area2D

# warning-ignore-all: RETURN_VALUE_DISCARDED


# Emit when contact with a HurtBox
signal contacted_hurt_box(hurt_box)

# For adjusting from inspector
export (int, LAYERS_2D_PHYSICS) var hit_mask: int = 0

# HitDamage
var hit_damage: HitDamage

var paired_hurt_box = null setget set_paried_hurt_box

func set_paried_hurt_box(hurt_box) -> void:
	emit_signal("contacted_hurt_box", hurt_box)

	
func _ready() -> void:
	collision_layer = 0
	collision_mask = hit_mask

# Add new hit mask
func add_hit_mask(new_mask:int) -> void:
	# bitwise OR
	hit_mask |= new_mask
	collision_mask = hit_mask

# Remove a hit mask
func remove_hit_mask(mask:int) -> void:
	# bitwise XOR
	hit_mask ^= mask
	collision_mask = hit_mask