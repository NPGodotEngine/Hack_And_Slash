tool
class_name ProjectileAmmo
extends Ammo

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT

export(float) var bullet_speed = 200.0
export(float) var bullet_life_span = 3.0
export(float) var bullet_penetration_chance = 0.0

# The actual bullet scene
##
# To be used to instantiate a new bullet
export(PackedScene) var bullet_scene: PackedScene = null



func _get_configuration_warning() -> String:
    if bullet_scene == null:
        return "bullet_scene is missing"
    return ""

# Consume a projectile bullet
# return a projectile bullet object
##
# `from_position`: position to start
# `to_position`: end position
# `hit_damage`: `HitDamage`
func consume_ammo(from_position:Vector2, to_position:Vector2, hit_damage:HitDamage) -> Projectile:
    if _is_reloading or _round_left == 0:
        return null

    var bullet: Projectile = bullet_scene.instance()
    assert(bullet, "Can't instance bullet from %s" % bullet_scene)
    assert(bullet is Projectile, "Bullet is not a type of Projectile")

    bullet.setup(from_position, to_position, bullet_speed, hit_damage, bullet_life_span, bullet_penetration_chance)

    _set_round_left(_round_left - 1)

    if _round_left == 0:
        reload_ammo()

    return bullet