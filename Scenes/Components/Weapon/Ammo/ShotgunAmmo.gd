@tool
class_name ShotgunAmmo
extends Ammo

# `true` penetration chance is picked randomly
# between 0.0 ~ bullet penetration chance
@export var random_penetration: bool = true

# Consume a projectile which contain number 
# of rounds
# return an array of projectile as type of Projectile
# this also set following bullet properties
# `speed`
# `life span`
# `penetration chance`
# `rounds_per_shot` number of rounds per one shot
func consume_ammo(rounds_per_shot) -> Array:
    if _is_reloading or _round_left == 0:
        return []
    
    var rounds: Array = []

    for _i in rounds_per_shot:
        var bullet: Projectile = bullet_scene.instantiate()
        assert(bullet, "Can't instance bullet from %s" % bullet_scene)
        assert(bullet is Projectile, "Bullet is not a type of Projectile")
        
        bullet.speed = bullet_speed
        bullet.life_span = bullet_life_span
        if random_penetration:
            randomize()
            bullet.penetration_chance = randf_range(0.0, bullet_penetration_chance)
        else:
            bullet.penetration_chance = bullet_penetration_chance

        rounds.append(bullet)

    if not self.infinite_ammo:
        _set_round_left(_round_left - 1)

    if _round_left == 0:
        reload_ammo()

    return rounds

