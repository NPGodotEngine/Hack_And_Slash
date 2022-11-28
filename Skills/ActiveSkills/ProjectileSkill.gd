extends ActiveSkill

# Projectile that skill will instantiate and shoot
export (PackedScene) var projectile: PackedScene = null

func shoot_skill() -> void:
    assert(projectile , "project tile not given")

    if not is_skill_ready:
        return 
        
    var projectile_instance = projectile.instance()
    get_tree().current_scene.add_child(projectile_instance)
    projectile_instance.direction = (get_global_mouse_position() - global_position).normalized()
    projectile_instance.damage = damage
    projectile_instance.global_position = global_position

    start_cool_down()

