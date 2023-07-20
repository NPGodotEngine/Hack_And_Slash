class_name Bullet
extends Node2D

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_PARAMETER



# Bullet type `BulletType` in Global.gd
var bullet_type: int = Global.BulletType.PROJECTILE

# Bullet hit damage
var hit_damage: HitDamage = null: set = _set_hit_damage

func _set_hit_damage(value:HitDamage) -> void:
    if value is HitDamage:
        hit_damage = value
        _hit_damage_updated(hit_damage)

func _init() -> void:
    pass

func _ready() -> void:
    pass

func _process(_delta:float) -> void:
    pass

func _physics_process(_delta:float) -> void:
    pass

# Call internally when hit damage is updated
func _hit_damage_updated(_damage:HitDamage) -> void:
    pass