class_name RangedDamageComponent
extends DamageComponent

## Max damage
@export var max_damage: float = 1000.0

## Min damage
@export var min_damage: float = 1.0


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
	var max_dmg: float = round(max_damage * damage_multiplier)
	max_dmg = max(max_dmg, min_damage)

	var min_dmg: float = round(min_damage * damage_multiplier)
	min_dmg = max(min_dmg, min_damage)

	var dmg: float = round(randf_range(min_dmg, max_dmg))
	dmg = max(dmg, min_damage)

	return dmg