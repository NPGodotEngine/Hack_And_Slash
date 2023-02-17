tool
class_name DashComponent
extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED


# Emit when dash begin
signal dash_begin()

# Emit when dash finished
signal dash_finished()

# Emit when dash begin cooldown
signal dash_cooldown_begin()


# Emit when dash cooldown end
signal dash_cooldown_end()


# Node path to KenimaticBody2D
export(NodePath) var target: NodePath

# Dash speed
export (float) var dash_speed: float = 1200.0

# Dash duration
export (float) var dash_duration: float = 0.2

# Dash cooldown duration
export (float) var dash_cooldown_duration: float = 1.0 


onready var _target: KinematicBody2D = get_node(target) as KinematicBody2D
onready var _dash_timer: Timer = $DashTimer
onready var _cooldown_timer: Timer = $CooldownTimer

# Whether is in dashing or not
var _is_dashing: bool = false

# Whether is in cooldown or not
var _is_cooldown: bool = false

func _get_configuration_warning() -> String:
	if target.is_empty():
		return "target node path is missing"
	
	if not get_node(target) is KinematicBody2D:
		return "target must be a KinematicBody2D node" 

	return ""

func _ready() -> void:
	_dash_timer.connect("timeout", self, "_on_dash_timer_timeout")
	_cooldown_timer.connect("timeout", self, "_on_cooldown_timer_timeout")

func _on_dash_timer_timeout() -> void:
	_dash_completed()

func _dash_completed() -> void:
	_is_dashing = false
	emit_signal("dash_finished")

	_is_cooldown = true
	emit_signal("dash_cooldown_begin")
	_cooldown_timer.start(dash_cooldown_duration)
	
func _on_cooldown_timer_timeout() -> void:
	_is_cooldown = false
	emit_signal("dash_cooldown_end")

func dash(direction:Vector2) -> void:
	if _target == null or target.is_empty():
		push_error("Could not find target to dash")
		return

	if _is_cooldown:
		return

	if _is_dashing:
		var dash_velocity: Vector2 = direction * dash_speed
		_target.move_and_slide(dash_velocity, Vector2.ZERO)

		# if collide with wall
		if _target.is_on_wall():
			_dash_timer.stop()
			_dash_completed()
	else:
		_is_dashing = true
		emit_signal("dash_begin")
		_dash_timer.start(dash_duration)
