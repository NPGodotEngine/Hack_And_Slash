# A class that hold damage information
# 
# Deliver this information Upon hitting character
class_name HitDamage
extends Reference

# Attacker
var _attacker = null

# Weapon
var _weapon = null

# Damage
var _damage: int = 0

# Is this a critical damage
var _is_critical: bool = false

# Critical strike multiplier 
var _critical_multiplier: float = 0.0

# Color of damage number
var _color_of_damage: Color = Color.white

# Initialization
func init(attacker, weapon, damage:int, is_critical:bool, critical_multiplier:float, color_of_damage:Color) -> HitDamage:
    _attacker = attacker
    _weapon = weapon
    _damage = damage
    _is_critical = is_critical
    _critical_multiplier = critical_multiplier
    _color_of_damage = color_of_damage
    return self

# Create a generic HitDamage
func get_default() -> HitDamage:
    _attacker = null
    _weapon = null
    _damage = 0
    _is_critical = false
    _critical_multiplier = 0.0
    _color_of_damage = Color.white
    return self
