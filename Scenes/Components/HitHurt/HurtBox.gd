class_name HurtBox
extends Area2D

# warning-ignore-all: RETURN_VALUE_DISCARDED

# Emit when take damage
signal take_damage(hit_damage)


func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area:Area2D) -> void:
	if area is HitBox:
		var hit_box: HitBox = area as HitBox
		hit_box.paired_hurt_box = self
		emit_signal("take_damage", hit_box.hit_damage)

# Add new hit mask
func add_hit_mask(new_mask:int) -> void:
	# bitwise OR
	collision_mask |= new_mask

# Remove a hit mask
func remove_hit_mask(mask:int) -> void:
	# bitwise XOR
	collision_mask ^= mask
