tool
class_name DashComponent
extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT

enum DashStates {
	DASH,
	COOLDOWN,
	UNKNOWN
}

class DashProgress:
	var state: int 
	var progress: float = 0.0
	var duration: float = 0.0

class DashVisualEffect:
	var effect: Node2D = null

class DashParticlesEffect:
	var particles: Particles2D = null

# Emit when dash begin
signal dash_begin()

# Emit when dash finished
signal dash_finished()

# Emit when dash begin cooldown
signal dash_cooldown_begin()

# Emit when dash cooldown end
signal dash_cooldown_end()

# Emit when need to display a dash visual effect
signal display_dash_effect(visual_effect)

# Emit when need to display a dash particles effect
signal display_dash_particles(particles_effect)



# Node path to KenimaticBody2D
export(NodePath) var target: NodePath

# Dash speed
export (float) var dash_speed: float = 2000.0

# Dash duration
export (float) var dash_duration: float = 0.2

# Dash delay recover
export (float) var dash_delay_recover: float = 0.2

# Dash cooldown duration
export (float) var dash_cooldown_duration: float = 1.0 

# The layer mask target will be in during dashing
export (int, LAYERS_2D_PHYSICS)	var dash_layer: int = 0

# The mask target will be in during dashing
export (int, LAYERS_2D_PHYSICS) var dash_mask: int = 0

# Dash effect
export (PackedScene) var dash_effect: PackedScene

# Dash particles
export (PackedScene) var dash_particles: PackedScene


onready var _target: KinematicBody2D = get_node(target) as KinematicBody2D
onready var _dash_timer: Timer = $DashTimer
onready var _cooldown_timer: Timer = $CooldownTimer
onready var _dash_delay_recover_timer: Timer = $DelayTimer

# Return dash progress
##
# Setting this value does nothing
var dash_progress: DashProgress = null setget no_set, get_dash_progress

# Return `true` if dash can be performed
# otherwise `false`
##
# Setting this value does nothing
var is_dash_avaliable: bool = true setget no_set, get_is_dash_avaliable

# Reference to target's layer mask
var _target_layer: int = 0

# Reference to target's layer mask
var _target_mask: int = 0

# Whether is in dashing or not
var _is_dashing: bool = false

# Whether is in cooldown or not
var _is_cooldown: bool = false

# Whether is in delay before cooldown process begin
var _is_delay_recover: bool = false


func no_set(value):
	pass

func get_dash_progress() -> DashProgress:
	var progress: DashProgress = DashProgress.new()

	if _is_dashing:
		progress.state = DashStates.DASH
		progress.progress = _dash_timer.time_left
		progress.duration = _dash_timer.wait_time
	elif _is_cooldown:
		progress.state = DashStates.COOLDOWN
		progress.progress = _cooldown_timer.time_left
		progress.duration = _cooldown_timer.wait_time
	else:
		progress.state = DashStates.UNKNOWN
		progress.progress = 1.0
		progress.duration = 1.0
	
	return progress

func get_is_dash_avaliable() -> bool:
	if _is_dashing or _is_delay_recover or _is_cooldown:
		return false
	return true

func _get_configuration_warning() -> String:
	if target.is_empty():
		return "target node path is missing"
	
	if not get_node(target) is KinematicBody2D:
		return "target must be a KinematicBody2D node" 

	return ""

func _ready() -> void:
	_dash_timer.connect("timeout", self, "_on_dash_timer_timeout")
	_cooldown_timer.connect("timeout", self, "_on_cooldown_timer_timeout")
	_dash_delay_recover_timer.connect("timeout", self, "_on_dash_delay_timeout")

func _on_dash_delay_timeout() -> void:
	_is_delay_recover = false

	# start cooldown
	_is_cooldown = true
	emit_signal("dash_cooldown_begin")
	_cooldown_timer.start(dash_cooldown_duration)

func _on_dash_timer_timeout() -> void:
	_dash_completed()

func _dash_completed() -> void:
	_is_dashing = false

	# recover target's original layer mask
	_target.collision_layer = _target_layer
	
	# recover target's original mask
	_target.collision_mask = _target_mask

	emit_signal("dash_finished")

	# start delay recover
	_is_delay_recover = true
	if is_equal_approx(dash_delay_recover, 0.0):
		_on_dash_delay_timeout()
	else:
		_dash_delay_recover_timer.start(dash_delay_recover)
	
func _on_cooldown_timer_timeout() -> void:
	_is_cooldown = false
	emit_signal("dash_cooldown_end")

# Perform dash
# Called this method in physics process in order
# to update dash
##
# `direction`: dash direction
func process_dash(direction:Vector2) -> void:
	if _target == null or target.is_empty():
		push_error("Could not find target to dash")
		return

	if _is_cooldown or _is_delay_recover:
		return

	if _is_dashing:
		var dash_velocity: Vector2 = direction * dash_speed
		_target.move_and_slide(dash_velocity, Vector2.ZERO)

		if dash_effect:
			var effect = dash_effect.instance()
			var dash_visual_effect: DashVisualEffect = DashVisualEffect.new()
			dash_visual_effect.effect = effect
			emit_signal("display_dash_effect", dash_visual_effect)

		# if collide with wall
		if _target.is_on_wall():
			_dash_timer.stop()
			_dash_completed()
	else:
		_is_dashing = true
		emit_signal("dash_begin")
		_dash_timer.start(dash_duration)

		# Change target to dash layer
		_target_layer = _target.collision_layer
		_target.collision_layer = dash_layer

		# Change target mask
		_target_mask = _target.collision_mask
		_target.collision_mask = dash_mask
		
		# handle dash particles
		if dash_particles:
			var particles = dash_particles.instance()

			# set particles direction
			if particles is Particles2D:
				var dir_norm: Vector2 = direction.normalized()
				particles.process_material.direction = -Vector3(dir_norm.x, dir_norm.y, 0.0)
			else:
				push_error("dash particles is not a Particles2D node")

			var particles_effect: DashParticlesEffect = DashParticlesEffect.new()
			particles_effect.particles = particles
			emit_signal("display_dash_particles", particles_effect)
