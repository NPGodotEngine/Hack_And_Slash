class_name HurtBox
extends Area2D

# warning-ignore-all: RETURN_VALUE_DISCARDED

# Emit when take damage
signal take_damage(hit_damage)


func _ready() -> void:
    monitorable = false
    collision_mask = 0
    connect("area_entered", self, "_on_area_entered")

func _on_area_entered(area:Area2D) -> void:
    if area is HitBox:
        var hit_box: HitBox = area as HitBox
        emit_signal("take_damage", hit_box.hit_damage)
        hit_box.paired_hurt_box = self

# Add new mask to layer
func add_layer_mask(new_mask:int) -> void:
    collision_layer |= new_mask

# Remove a mask from layer
func remove_layer_mask(mask:int) -> void:
    collision_layer ^= mask
