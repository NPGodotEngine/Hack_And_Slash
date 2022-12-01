# A class holde number of active skills
# and control of active skill
class_name SkillManager
extends Node2D

# List of active skills 
var active_skills: Array = [
	preload("res://Skills/FireSkill/FireSkill.tscn").instance(),
	preload("res://Skills/IceSkill/IceSkill.tscn").instance()
]

func _ready() -> void:
	# setup preset skills
	for i in active_skills.size():
		var skill: Skill = active_skills[i]
		add_child(skill)
		skill.setup(owner)
		
# Execute a skill by index
func execute_skill(index:int) -> void:
	var skill: Skill = active_skills[index]
	if skill.is_skill_ready:
		skill.execute()
