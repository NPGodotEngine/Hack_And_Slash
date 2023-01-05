class_name DamageComponent
extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED

class DamageContext extends Resource:
	var previous_damage: float = 0.0
	var updated_damage: float = 0.0

# Emit when damage changed
##
# `damage_context`: class `DamageContext`
signal damage_updated(damage_context)


# Min damage
export (float) var min_damage: float = 1.0

# Current damage
export (float) var damage: float = 10.0 setget set_damage, get_damage

# Color for damage
export (Color) var damage_color: Color = Color.white

# Damage multiplier
var damage_multiplier: float = 1.0

## Getter Setter ##


func set_damage(value:float) -> void:
	if is_equal_approx(value, damage):
		return 

	var prev_damage = damage
	damage = max(value, min_damage)
	damage = round(damage)

	var damage_context: DamageContext = DamageContext.new()
	damage_context.previous_damage = prev_damage
	damage_context.updated_damage = damage

	emit_signal("damage_updated", damage_context)

func get_damage() -> float:
	return round(max(damage * damage_multiplier, min_damage))

## Getter Setter ##
