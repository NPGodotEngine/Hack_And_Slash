class_name HitBox
extends Area2D

# warning-ignore-all: RETURN_VALUE_DISCARDED


# Emit when contact with a HurtBox
signal contacted_hurt_box(hurt_box)

# Emit when contact with StaticBody2D
signal contacted_static_body(body)



# HitDamage
var hit_damage: HitDamage

var paired_hurt_box = null setget set_paried_hurt_box

func set_paried_hurt_box(hurt_box) -> void:
	emit_signal("contacted_hurt_box", hurt_box)

	
func _ready() -> void:
	collision_layer = 0
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body:Node) -> void:
	if body is StaticBody2D:
		emit_signal("contacted_static_body", body)

# Add new hit mask
func add_hit_mask(new_mask:int) -> void:
	# bitwise OR
	collision_mask |= new_mask

# Remove a hit mask
func remove_hit_mask(mask:int) -> void:
	# bitwise XOR
	collision_mask ^= mask