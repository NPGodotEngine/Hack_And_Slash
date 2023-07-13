class_name Bullet
extends Node2D

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED



# Bullet type `BulletType` in Global.gd
var bullet_type: int = Global.BulletType.PROJECTILE

# Bullet hit damage
var hit_damage: HitDamage = null setget _set_hit_damage

func _set_hit_damage(value:HitDamage) -> void:
    if value is HitDamage:
        hit_damage = value
        _hit_damage_updated(hit_damage)

# Call internally when hit damage is updated
func _hit_damage_updated(damage:HitDamage) -> void:
    pass