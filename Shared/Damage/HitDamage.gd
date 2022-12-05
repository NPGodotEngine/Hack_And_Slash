# A class that hold damage information
# 
# Deliver this information Upon hitting character
class_name HitDamage
extends Reference

# Attacker
var attacker = null

# Skill
var skill = null

# Damage
var damage: int = 0

# Is this a critical damage
var is_critical: bool = false

# Color of damage number
var color_of_damage: Color = Color.white

# Initialization
func init(_attacker, _skill, _damage:int, _is_critical:bool, _color_of_damage:Color) -> HitDamage:
    self.attacker = _attacker
    self.skill = _skill
    self.damage = _damage
    self.is_critical = _is_critical
    self.color_of_damage = _color_of_damage
    return self
