class_name Bullet
extends Node2D

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED



# Bullet type `BulletType` in Global.gd
var bullet_type: int = Global.BulletType.PROJECTILE

# Bullet hit damage
var hit_damage: HitDamage = null