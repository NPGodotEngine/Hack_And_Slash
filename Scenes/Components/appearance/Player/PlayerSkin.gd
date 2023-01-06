tool
extends Node2D

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT



const IDLE = "idle"
const RUN = "run"



# Node path to MovementComponent
export(NodePath) var movement: NodePath

onready var upper_body_animator: AnimationPlayer = $UpperAnimator
onready var lower_body_animator: AnimationPlayer = $LowerAnimator

# MovementComponent
onready var _movement: MovementComponent = get_node(movement)


var _playback_speed: float = 1.0
var _max_playback_speed: float = 64.0

# Velocity from MovementComponent
var _velocity: Vector2 = Vector2.ZERO



func _get_configuration_warning() -> String:
	if movement.is_empty():
		return "movement node path is missing"

	if not get_node(movement) is MovementComponent:
		return "movement must be a MovementComponent node" 

	return ""

func _ready() -> void:
	if Engine.editor_hint:
		return
	
	# wait for parent node to be ready
	var _player = get_parent()
	yield(_player, "ready")
	
	var max_speed: float = _movement.max_movement_speed
	var min_speed: float = _movement.min_movement_speed
	var speed: float = _movement.movement_speed

	_max_playback_speed = (max_speed - min_speed) / speed

	_movement.connect("velocity_updated", self, "_on_velocity_updated")

	upper_body_animator.play(IDLE)

func _physics_process(delta: float) -> void:
	if Engine.editor_hint:
		return

	update_skin()
	update_animation()

func _on_velocity_updated(velocity_context:MovementComponent.VelocityContext) -> void:
	_velocity = velocity_context.updated_velocity


func update_skin() -> void:
	# Update skin 
	var global_mouse_position := get_global_mouse_position()

	if global_mouse_position.x < global_position.x:
		self.scale.x = -1.0 * self.scale.abs().x
	else:
		self.scale.x = 1.0 * self.scale.abs().x

func update_animation() -> void:
	# update playback speed
	var max_speed: float = _movement.max_movement_speed
	var min_speed: float = _movement.min_movement_speed
	var speed: float = _movement.movement_speed

	var speed_length = max_speed - min_speed
	_playback_speed = speed / speed_length * _max_playback_speed
	
	# update playback speed direction
	_playback_speed *= 1.0
	var player_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	if (not is_equal_approx(sign(_velocity.x), sign(player_direction.x)) and 
		not is_equal_approx(_velocity.x, 0.0)):
		_playback_speed *= -1.0

	if abs(_velocity.x) <= 0.1 and abs(_velocity.y) <= 0.1:
		play_animation(upper_body_animator, IDLE, _playback_speed)
		stop_animation(lower_body_animator, RUN)
	else:
		play_animation(lower_body_animator, RUN, _playback_speed)
		stop_animation(upper_body_animator, IDLE)


# Return a bool value `true` indicate playback speed is
# reverse (negative) or `false` indicate forward (positive) 
func is_playing_reverse(playback_speed:float) -> bool:
	var result: bool =  true if _playback_speed < 0.0 else false
	return result

# Play an animation
##
# `player`: `AnimationPlayer` instance
# `name`: animtion name
# `speed`: animation speed, if negative then playing
# animtion reverse
func play_animation(player:AnimationPlayer, name:String, speed:float=1.0) -> void:
	if player.current_animation == name:
		return
	player.play(name, -1, speed, is_playing_reverse(speed))

# Stop an animation
##
# `player`: `AnimationPlayer` instance
# `name`: animtion name
# `reset`: if need to reset animation to frame 0
func stop_animation(player:AnimationPlayer, name:String, reset:bool=true) -> void:
	if  not player.current_animation == name:
		return
	if reset:
		player.seek(0, true)
	player.stop(reset)