# A class holde number of active skills
# and control of active skill
class_name SkillManager
extends Node2D

# List of active skills 
var active_skills: Array = [
	preload("res://Skills/Projectile/FireBulletSkill/FireBulletSkill.tscn").instance()
	# preload("res://Skills/IceSkill/IceBulletSkill.tscn").instance()
]

func _ready() -> void:
	# setup preset skills
	for i in active_skills.size():
		var skill: Skill = active_skills[i]
		add_child(skill)
		skill.setup(get_parent())
		
# Execute a skill by index
func execute_skill(index:int, position:Vector2, direction:Vector2) -> void:
	if index >= active_skills.size(): return 

	var skill: Skill = active_skills[index]
	if skill and skill.is_skill_ready:
		skill.execute(position, direction)

# Cancel a skill by index
func cancel_skill_execution(index:int) -> void:
	if index >= active_skills.size(): return 

	var skill: Skill = active_skills[index]
	if skill:
		skill.cancel_execution()

# Get skill by index
func get_skill_by(index:int) -> Skill:
	if index >= active_skills.size(): return null
		
	if active_skills and active_skills.size() > 0 and index < active_skills.size():
		return active_skills[index]
	
	return null
