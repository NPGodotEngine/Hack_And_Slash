# Any active skills must subclass of this class
# and implement shoot_skill method then call
# start_cool_down method at right time to 
# begin cool down 
class_name ActiveSkill
extends Node2D

# CoolDown duration of skill
export (float) var cooldown_duration := 1.0

# Skill damage
export (int) var damage := 10

# CoolDown timer
onready var cool_dwon_timer := $CoolDownTimer

# Is skill ready to be used
var is_skill_ready: bool = true

func _ready() -> void:
    cool_dwon_timer.wait_time = cooldown_duration
    cool_dwon_timer.one_shot = true
    cool_dwon_timer.connect("timeout", self, "_on_cool_down_timer_timeout")

func _exit_tree() -> void:
    if cool_dwon_timer:
        cool_dwon_timer.disconnect("timeout", self, "_on_cool_down_timer_timeout")

func _on_cool_down_timer_timeout() -> void:
    is_skill_ready = true

# Begin skill cool down 
func start_cool_down() -> void:
    is_skill_ready = false

    # Don't start timer if during cool down
    if cool_dwon_timer.time_left > 0:
        return

    cool_dwon_timer.start()

# Shoot skill
func shoot_skill() -> void:
    pass