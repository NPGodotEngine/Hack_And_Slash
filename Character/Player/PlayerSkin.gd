extends Node2D

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT

const IDLE = "idle"
const RUN = "run"

onready var upper_body_animator: AnimationPlayer = $UpperAnimator
onready var lower_body_animator: AnimationPlayer = $LowerAnimator

# Character this skin belong to
var _character: Character = null
var _playback_speed: float = 1.0
var _max_playback_speed: float = 64.0


func _ready() -> void:
    _character = get_parent()
    assert(_character, "PlayerSkin must be a child of Character")
    _max_playback_speed = (_character.max_movement_speed - _character.min_movement_speed) / _character.movement_speed

    upper_body_animator.play(IDLE)

func _physics_process(delta: float) -> void:
    # update playback speed
    var speed_length = _character.max_movement_speed - _character.min_movement_speed
    _playback_speed = _character.movement_speed / speed_length * _max_playback_speed
    
    # update playback speed direction
    _playback_speed *= 1.0
    var character_dir: Vector2 = (get_global_mouse_position() - _character.global_position).normalized()
    if (not is_equal_approx(sign(_character.velocity.x), sign(character_dir.x)) and 
        not is_equal_approx(_character.velocity.x, 0.0)):
        _playback_speed *= -1.0

    if abs(_character.velocity.x) <= 0.1 and abs(_character.velocity.y) <= 0.1:
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
