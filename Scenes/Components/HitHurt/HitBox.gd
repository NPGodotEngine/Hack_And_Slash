class_name HitBox
extends Area2D

# warning-ignore-all: RETURN_VALUE_DISCARDED


## Emit when contact with a HurtBox
signal contacted_hurt_box(hurt_box)

## Emit when contact with StaticBody2D
signal contacted_static_body(body)

## Emit when contact with TileMap
signal contacted_tile_map(tile_map)


## Bitwise mask
## What type of hurt box should be target
## @
## E.g Player, Enemy, Boss or combination
## @
## Usually check all potential box of target mask
## then remove it with method `remove_target_mask` a accordingly
## @
## For example a bullet can hit player and enemy so target mask
## must check player and enemy box then remove player once
## bullet is instantiated thus the bullet only hit enemy
## not player
@export_flags_2d_physics var target_mask: int = 0

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
	if body is TileMap:
		emit_signal("contacted_tile_map", body)

## Add new mask to target mask
func add_target_mask(new_mask:int) -> void:
	target_mask |= new_mask

## Remove a mask from target mask
func remove_target_mask(mask:int) -> void:
	target_mask ^= mask
