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

# Skill base damage
export (int) var damage := 10

# Skill damage amplifier
# base on its owner's damage
# E.g 1.0 = 100% of its owner's damage
# E.g 0.75 = 75% of its owner's damage
export (float) var damage_amplifier := 1.0

# CoolDown timer
var cool_dwon_timer: Timer = null

# Is skill ready to be used
var is_skill_ready: bool = true

# The object that own this skill
var executer = null

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
func setup(skill_owner) -> void:
    executer = skill_owner

# Begin skill cool down 
func start_cool_down() -> void:
    is_skill_ready = false

    # Don't start timer if during cool down
    if cool_dwon_timer.time_left > 0:
        return

    cool_dwon_timer.start()

    emit_signal("cool_down_started")

# Get total damage output from this skill
func get_damage_output() -> int:
    # caculate amplified damage
    var amplified_damage: int = 0
    if executer and "damage" in executer:
        amplified_damage = int(executer.damage * damage_amplifier)
    
    var damage_output = int(damage + amplified_damage)

    return damage_output

# Execute skill
func execute() -> void:
    pass