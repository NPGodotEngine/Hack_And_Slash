class_name Bullet
extends Node2D

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_PARAMETER



## Bullet type `BulletType` in Global.gd
var bullet_type: int = Global.BulletType.PROJECTILE

## Bullet hit damage
var hit_damage: HitDamage = null: set = _set_hit_damage

## Bullet's hit box
var hit_box: HitBox = null

func _set_hit_damage(value:HitDamage) -> void:
    if value is HitDamage:
        hit_damage = value
        _hit_damage_updated(hit_damage)

func _init() -> void:
    pass

func _ready() -> void:
    for child in get_children():
        if child is HitBox:
            hit_box = child
            return

func _process(_delta:float) -> void:
    pass

func _physics_process(_delta:float) -> void:
    pass

# Call internally when hit damage is updated
func _hit_damage_updated(_damage:HitDamage) -> void:
    pass

## Add new mask to hit box's target mask
func add_target_mask(mask:int) -> void:
    if hit_box:
        hit_box.add_target_mask(mask)

## Remove a mask from hit box's target mask
func remove_target_mask(mask:int) -> void:
    if hit_box:
        hit_box.remove_target_mask(mask)