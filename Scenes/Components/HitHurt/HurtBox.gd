class_name HurtBox
extends Area2D

# warning-ignore-all: RETURN_VALUE_DISCARDED

# Emit when take damage
signal take_damage(hit_damage)

## Bitwise mask
## Type of hurt box
## @
## E.g Player, Enemy, Boss or combination
## @
## This will be used to check
## if hit box's target mask match
## this type mask if they match
## then this hurt box send `take_damage`
## signal
@export_flags_2d_physics var type_mask: int = 0


func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area:Area2D) -> void:
	if area is HitBox:
		var hit_box: HitBox = area as HitBox

		# make sure attacker is not our self
		if hit_box.hit_damage._attacker == owner:
			return

		# check if hit box's target mask match
		# included this type of hurt box	
		if hit_box.target_mask & type_mask == 0:
			return
		hit_box.paired_hurt_box = self
		emit_signal("take_damage", hit_box.hit_damage)

# Add new hit mask
func add_type_mask(new_mask:int) -> void:
	# bitwise OR
	type_mask |= new_mask

# Remove a hit mask
func remove_type_mask(mask:int) -> void:
	# bitwise XOR
	type_mask ^= mask
