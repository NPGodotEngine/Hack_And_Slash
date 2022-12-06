# Any active skills must subclass of this class
# and implement shoot_skill method then call
# start_cool_down method at right time to 
# begin cool down 
class_name Skill
extends Node2D

# Signal for cool down started
signal cool_down_started()

# Signal for cool down ended
signal cool_down_ended()

# CoolDown duration of skill
export (float) var cooldown_duration := 1.0

# Skill damage multiplier
# base on its owner's damage
# E.g 1.0 = 100% of its owner's damage
# E.g 0.75 = 75% of its owner's damage
export (float) var damage_multiplier := 1.0

# CoolDown timer
var cool_dwon_timer: Timer = null

# Is skill ready to be used
var is_skill_ready: bool = true

# The object that own this skill
var skill_owner = null

func _ready() -> void:
	# create a cool down timer
	cool_dwon_timer = Timer.new()
	cool_dwon_timer.name = "CoolDownTimer"
	add_child(cool_dwon_timer)

	# setup cool down timer
	cool_dwon_timer.wait_time = cooldown_duration
	cool_dwon_timer.one_shot = true
	var _ret = cool_dwon_timer.connect("timeout", self, "_on_cool_down_timer_timeout")

func _exit_tree() -> void:
	if cool_dwon_timer:
		cool_dwon_timer.disconnect("timeout", self, "_on_cool_down_timer_timeout")

func _on_cool_down_timer_timeout() -> void:
	is_skill_ready = true

	emit_signal("cool_down_ended")

# Setup skill
func setup(skill_executer) -> void:
	skill_owner = skill_executer

# Begin skill cool down 
func start_cool_down() -> void:
	is_skill_ready = false

	# Don't start timer if during cool down
	if cool_dwon_timer.time_left > 0:
		return

	cool_dwon_timer.start()

	emit_signal("cool_down_started")

# Get total damage output from this skill
# Scaled from skill owner's damage 
func get_damage_output() -> int:
	# caculate amplified damage
	var damage_output = 0
	var character: Character = skill_owner as Character
	if character:
		# owner's damage * multiplier
		damage_output = int(character._damage * damage_multiplier)

	return damage_output

# Get hit damage
func get_hit_damage() -> HitDamage:
	return null

# Execute skill
# with global position and direction
func execute(_position:Vector2, _direction:Vector2) -> void:
	pass

# Cancel skill execution
##
# Specific to skill that need to warm up
func cancel_execution() -> void:
	pass
