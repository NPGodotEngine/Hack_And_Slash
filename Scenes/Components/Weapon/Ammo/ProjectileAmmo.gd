@tool
class_name ProjectileAmmo
extends Ammo


# Consume a projectile bullet
# return a projectile bullet object
# this also set following bullet properties
# `speed`
# `life span`
# `penetration chance`
func consume_ammo() -> Projectile:
    if _is_reloading or _round_left == 0:
        return null
    
    var bullet: Projectile = bullet_scene.instantiate()
    assert(bullet, "Can't instance bullet from %s" % bullet_scene)
    assert(bullet is Projectile, "Bullet is not a type of Projectile")
    
    bullet.speed = bullet_speed
    bullet.life_span = bullet_life_span
    bullet.penetration_chance = bullet_penetration_chance

    if not self.infinite_ammo:
        _set_round_left(_round_left - 1)

    if _round_left == 0:
        reload_ammo()

    return bullet