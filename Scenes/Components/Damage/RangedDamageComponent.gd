class_name RangedDamageComponent
extends DamageComponent

# Max damage
export(float) var max_damage: float = 1000.0


func get_damage() -> float:
    var max_dmg: float = round(max_damage * damage_multiplier)
    max_dmg = max(max_dmg, min_damage)

    var min_dmg: float = round(min_damage * damage_multiplier)
    min_dmg = max(min_dmg, min_damage)

    var dmg: float = round(rand_range(min_dmg, max_dmg))
    dmg = max(dmg, min_damage)

    return dmg