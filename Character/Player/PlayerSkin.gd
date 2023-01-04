extends Node2D

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT

const IDLE = "idle"
const RUN = "run"

onready var upper_body_animator: AnimationPlayer = $UpperAnimator
onready var lower_body_animator: AnimationPlayer = $LowerAnimator

# Character this skin belong to
var _player: Player = null
var _playback_speed: float = 1.0
var _max_playback_speed: float = 64.0


func _ready() -> void:
	_player = get_parent()

	yield(_player, "ready")
	
	var max_speed: float = _player._movement_comp.max_movement_speed
	var min_speed: float = _player._movement_comp.min_movement_speed
	var speed: float = _player._movement_comp.movement_speed

	_max_playback_speed = (max_speed - min_speed) / speed

	upper_body_animator.play(IDLE)

func _physics_process(delta: float) -> void:
	# update playback speed
	var max_speed: float = _player._movement_comp.max_movement_speed
	var min_speed: float = _player._movement_comp.min_movement_speed
	var speed: float = _player._movement_comp.movement_speed

	var speed_length = max_speed - min_speed
	_playback_speed = speed / speed_length * _max_playback_speed
	
	# update playback speed direction
	_playback_speed *= 1.0
	var player_direction: Vector2 = (get_global_mouse_position() - _player.global_position).normalized()
	if (not is_equal_approx(sign(_player._velocity.x), sign(player_direction.x)) and 
		not is_equal_approx(_player._velocity.x, 0.0)):
		_playback_speed *= -1.0

	if abs(_player._velocity.x) <= 0.1 and abs(_player._velocity.y) <= 0.1:
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
