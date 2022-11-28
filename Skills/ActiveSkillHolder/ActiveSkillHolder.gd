# A class holde number of active skills
# and control of active skill
class_name ActiveSkillHolder
extends Position2D

# Number of active skills allowed to be use
const NUM_SKILLS = 2

# For quick load up preset skill 
export (Array, PackedScene) var skills = []

# List of active skills 
var active_skills: Array = []

func _ready() -> void:
    active_skills.resize(NUM_SKILLS)

    # load up preset skills
    for i in skills.size():
        var skill: ActiveSkill = skills[i].instance()
        add_child(skill)
        skill.position = Vector2.ZERO
        skill.rotation = rotation
        active_skills[i] = skill

func _physics_process(_delta: float) -> void:
    # Face mouse position
    look_at(get_global_mouse_position())

    # Tell first skill to shoot
    if Input.is_action_pressed("primary"):
        if active_skills[0]:
            active_skills[0].shoot_skill()
    
    # Tell second skill to shoot
    if Input.is_action_pressed("secondary"):
        if active_skills[1]:
            active_skills[1].shoot_skill()