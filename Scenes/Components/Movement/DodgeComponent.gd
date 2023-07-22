@tool
class_name DodgeComponent
extends Node2D

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT

enum DodgeStates {
	DODGE,
	COOLDOWN,
	UNKNOWN
}

class DodgeProgress:
	var state: int 
	var progress: float = 0.0
	var duration: float = 0.0

class DodgeVisualEffect:
	var effect: Node2D = null

class DodgeParticlesEffect:
	var particles: GPUParticles2D = null

# Emit when dodge begin
signal dodge_begin()

# Emit when dodge finished
signal dodge_finished()

# Emit when dodge begin cooldown
signal dodge_cooldown_begin()

# Emit when dodge cooldown end
signal dodge_cooldown_end()

# Emit when need to display a dodge visual effect
signal display_dodge_effect(visual_effect)

# Emit when need to display a dodge particles effect
signal display_dodge_particles(particles_effect)



# Dodge speed
@export var dodge_speed: float = 2000.0

# Dodge duration
@export var dodge_duration: float = 0.2

# Dodge delay recover
@export var dodge_delay_recover: float = 0.2

# Dodge cooldown duration
@export var dodge_cooldown_duration: float = 1.0 

# The layer mask target will be in during dodging
@export_flags_2d_physics var dodge_layer: int = 0

# The mask target will be in during dodging
@export_flags_2d_physics var dodge_mask: int = 0

# dodge effect
@export var dodge_effect: PackedScene

# dodge particles
@export var dodge_particles: PackedScene


@onready var _dodge_timer: Timer = $DodgeTimer
@onready var _cooldown_timer: Timer = $CooldownTimer
@onready var _dodge_delay_recover_timer: Timer = $DelayTimer

var _target: CharacterBody2D = null

# Return dodge progress
##
# Setting this value does nothing
var dodge_progress: DodgeProgress = null: get = get_dodge_progress, set = no_set

# Return `true` if dodge can be performed
# otherwise `false`
##
# Setting this value does nothing
var is_dodge_avaliable: bool = true: get = get_is_dodge_avaliable, set = no_set

# Reference to target's layer mask
var _target_layer: int = 0

# Reference to target's layer mask
var _target_mask: int = 0

# Whether is in dodging or not
var _is_dodging: bool = false

# Whether is in cooldown or not
var _is_cooldown: bool = false

# Whether is in delay before cooldown process begin
var _is_delay_recover: bool = false


func no_set(_value):
	pass

func get_dodge_progress() -> DodgeProgress:
	var progress: DodgeProgress = DodgeProgress.new()

	if _is_dodging:
		progress.state = DodgeStates.DODGE
		progress.progress = _dodge_timer.time_left
		progress.duration = _dodge_timer.wait_time
	elif _is_cooldown:
		progress.state = DodgeStates.COOLDOWN
		progress.progress = _cooldown_timer.time_left
		progress.duration = _cooldown_timer.wait_time
	else:
		progress.state = DodgeStates.UNKNOWN
		progress.progress = 1.0
		progress.duration = 1.0
	
	return progress

func get_is_dodge_avaliable() -> bool:
	if _is_dodging or _is_delay_recover or _is_cooldown:
		return false
	return true

func _get_configuration_warnings() -> PackedStringArray:
	if not is_instance_of(get_parent(), CharacterBody2D):
		return ["This node must be a child of CharacterBody2D node"]

	return []

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	_target = get_parent()
	_dodge_timer.connect("timeout", Callable(self, "_on_dodge_timer_timeout"))
	_cooldown_timer.connect("timeout", Callable(self, "_on_cooldown_timer_timeout"))
	_dodge_delay_recover_timer.connect("timeout", Callable(self, "_on_dodge_delay_timeout"))

func _on_dodge_delay_timeout() -> void:
	_is_delay_recover = false

	# start cooldown
	_is_cooldown = true
	emit_signal("dodge_cooldown_begin")
	_cooldown_timer.start(dodge_cooldown_duration)

func _on_dodge_timer_timeout() -> void:
	_dodge_completed()

func _dodge_completed() -> void:
	_is_dodging = false

	# recover target's original layer mask
	_target.collision_layer = _target_layer
	
	# recover target's original mask
	_target.collision_mask = _target_mask

	emit_signal("dodge_finished")

	# start delay recover
	_is_delay_recover = true
	if is_equal_approx(dodge_delay_recover, 0.0):
		_on_dodge_delay_timeout()
	else:
		_dodge_delay_recover_timer.start(dodge_delay_recover)
	
func _on_cooldown_timer_timeout() -> void:
	_is_cooldown = false
	emit_signal("dodge_cooldown_end")

# Perform dodge
# Called this method in physics process in order
# to update dodge
##
# `direction`: dodge direction
func process_dodge(direction:Vector2) -> void:
	if _target == null:
		push_error("Could not find target to dodge")
		return

	if _is_cooldown or _is_delay_recover:
		return

	if _is_dodging:
		var dodge_velocity: Vector2 = direction * dodge_speed
		_target.set_velocity(dodge_velocity)
		_target.move_and_slide()
		# _target.velocity

		if dodge_effect:
			var effect = dodge_effect.instantiate()
			var dodge_visual_effect: DodgeVisualEffect = DodgeVisualEffect.new()
			dodge_visual_effect.effect = effect
			emit_signal("display_dodge_effect", dodge_visual_effect)

		# if collide with wall
		if _target.is_on_wall():
			_dodge_timer.stop()
			_dodge_completed()
	else:
		_is_dodging = true
		emit_signal("dodge_begin")
		_dodge_timer.start(dodge_duration)

		# Change target to dodge layer
		_target_layer = _target.collision_layer
		_target.collision_layer = dodge_layer

		# Change target mask
		_target_mask = _target.collision_mask
		_target.collision_mask = dodge_mask
		
		# handle dodge particles
		if dodge_particles:
			var particles = dodge_particles.instantiate()

			# set particles direction
			if particles is GPUParticles2D:
				var dir_norm: Vector2 = direction.normalized()
				particles.process_material.direction = -Vector3(dir_norm.x, dir_norm.y, 0.0)
			else:
				push_error("dodge particles is not a GPUParticles2D node")

			var particles_effect: DodgeParticlesEffect = DodgeParticlesEffect.new()
			particles_effect.particles = particles
			emit_signal("display_dodge_particles", particles_effect)
