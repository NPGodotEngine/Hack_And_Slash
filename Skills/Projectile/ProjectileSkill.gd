# ProjectileSkill extended from Skill
##
# Designed specific to shooting projectile
class_name ProjectileSkill
extends Skill

# Projectile this skill will use to instantiate and shoot
export (PackedScene) var projectile_scene: PackedScene = null

# Speed that will be applied to projectile
export (float) var projectile_speed := 200.0 

# Penetration chance that will be applied to projectile
export (float, 0.0, 1.0) var projectile_penetration_chance := 0.0

# Life span tha will be applied to projectile
export (float) var projectile_life_span := 3.0

# Maximum of projectil size can shoot
# projectile count will not excee this value
export (int) var max_projectile_size := 1

# Currnt projectile count can shoot at time
# The value is scaled base on character's level
var projectile_count: int = 1 setget _no_set, get_projectile_count

## Getter Setter ##
func _no_set(_value) -> void:
    push_warning("Set property not allowed")
    return

func get_projectile_count() -> int:
    projectile_count = 1

    # scale projectile count base on character level
    # otherwise default to 1
    if skill_owner and skill_owner is Character:
        var scale: float = skill_owner._level * skill_owner.MAX_LEVEL / 100.0 
        var count: int = int(round(max_projectile_size * scale))
        count = int(min(max(1, count), max_projectile_size))
        projectile_count = count
    
    return projectile_count
## Getter Setter ##

## Override ##
func execute(_position:Vector2, _direction:Vector2) -> void:
    assert(projectile_scene , "projectile_scene is null")
## Override ##


    

