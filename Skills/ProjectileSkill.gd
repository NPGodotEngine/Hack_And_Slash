extends Skill

# Projectile that skill will instantiate and shoot
export (PackedScene) var projectile: PackedScene = null

func execute(position:Vector2, direction:Vector2) -> void:
    assert(projectile , "projectile not given")
        
    var projectile_instance: Projectile = projectile.instance()
    get_tree().current_scene.add_child(projectile_instance)
    projectile_instance.direction = direction
    projectile_instance.hit_damage = get_hit_damage()
    projectile_instance.global_position = position

    start_cool_down()

func get_hit_damage() -> HitDamage:
    var is_critical = false
    var character: Character = skill_owner as Character
    if character:
        is_critical = character.is_critical()
    
    return HitDamage.new().init(
        skill_owner,
        self,
        get_damage_output(),
        is_critical,
        Color.white if not is_critical else Color.red
    )
    

