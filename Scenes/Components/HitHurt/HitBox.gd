class_name HitBox
extends Area2D

# warning-ignore-all: RETURN_VALUE_DISCARDED


# Emit when contact with a HurtBox
signal contacted_hurt_box(hurt_box)

# Emit when contact with StaticBody2D
signal contacted_static_body(body)



# HitDamage
var hit_damage: HitDamage

var paired_hurt_box = null: set = set_paried_hurt_box

func set_paried_hurt_box(hurt_box) -> void:
	emit_signal("contacted_hurt_box", hurt_box)

	
func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body:Node) -> void:
	if body is StaticBody2D:
		emit_signal("contacted_static_body", body)

# Add new mask to layer
func add_layer_mask(new_mask:int) -> void:
	collision_layer |= new_mask

# Remove a mask from layer
func remove_layer_mask(mask:int) -> void:
	collision_layer ^= mask