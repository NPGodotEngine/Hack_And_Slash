extends Skill

# Projectile that skill will instantiate and shoot
export (PackedScene) var projectile: PackedScene = null

func execute(position:Vector2, direction:Vector2) -> void:
    assert(projectile , "project tile not given")
        
    var projectile_instance = projectile.instance()
    get_tree().current_scene.add_child(projectile_instance)
    projectile_instance.direction = direction
    projectile_instance.damage = get_damage_output()
    projectile_instance.global_position = position

    start_cool_down()

