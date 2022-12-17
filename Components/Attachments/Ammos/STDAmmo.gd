tool
extends Ammo

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT

export (float) var bullet_speed = 200.0
export (float) var bullet_life_span = 3.0
export (float) var bullet_penetration_chance = 0.0


func shoot_ammo(from_position:Vector2, to_position:Vector2, hit_damage:HitDamage, rounds_per_shot:int = 1) -> void:
    .shoot_ammo(from_position, to_position, hit_damage, rounds_per_shot)

    if _is_reloading:
        return

    if _round_left == 0:
        reload_ammo()
        return

    for i in rounds_per_shot:
        var bullet: Projectile = bullet_scene.instance()
        assert(bullet, "Can't instance bullet from %s" % bullet_scene)
        assert(bullet is Projectile, "Bullet is not a type of Projectile")
        
        Global.add_to_scene_tree(bullet)

        bullet.setup(from_position, to_position, bullet_speed, hit_damage, bullet_life_span, bullet_penetration_chance)
        bullet.connect("on_projectile_hit", self, "_on_bullet_hit")

        _set_round_left(_round_left - rounds_per_shot)

func _on_bullet_hit(bullet, body) -> void:
    pass