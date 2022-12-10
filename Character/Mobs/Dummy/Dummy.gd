extends Character

# warning-ignore-all:RETURN_VALUE_DISCARDED

export (bool) var _follow_player = false
export (float) var _distance_to_player = 100.0

onready var _health_bar := $HealthBar
onready var _animation_player := $AnimationPlayer
onready var _player_detector: Area2D = $PlayerDetector

var _target: Character = null

# current velocity
var velocity := Vector2.ZERO

func setup() -> void:
	.setup()
	
	connect("health_changed", self, "_on_health_changed")
	connect("max_health_changed", self, "_on_max_health_changed")
	connect("take_damage", self, "_on_take_damage")
	connect("die", self, "_on_die")

	_player_detector.connect("body_entered", self, "_on_detect_player")
	_player_detector.connect("body_exited", self, "_on_player_out_of_range")

	_update_health_bar()

func move_character(delta:float) -> void:
	if _follow_player:
		follow_player(delta)

func follow_player(_delta:float):
	if not _target: return
	
	var direction: Vector2 = _target.global_position - global_position
	var dist_to_target: float = global_position.distance_to(_target.global_position)
	if is_equal_approx(dist_to_target, _distance_to_player) or dist_to_target < _distance_to_player:
		return

	var desired_dist: float = dist_to_target - _distance_to_player
	var desired_velocity: Vector2 = direction.normalized() * get_movement_speed() * sign(desired_dist)
	var steering_velocity = desired_velocity - velocity
	steering_velocity  = steering_velocity * _drag_factor
	velocity += steering_velocity

	# Move player
	velocity = move_and_slide(velocity)


func _on_detect_player(body:Node) -> void:
	var character: Character = body as Character
	if character:
		_target = character

func _on_player_out_of_range(body:Node) -> void:
	var character: Character = body as Character
	if _target and character == _target:
		_target = null

func _update_health_bar() -> void:
	_health_bar.min_value = float(0)
	_health_bar.max_value = float(_max_health)
	_health_bar.value = float(_health)

func _on_health_changed(_from_health:int, _to_health:int) -> void:
	_update_health_bar()

func _on_max_health_changed(_from_max_health:int, _to_max_health:int) -> void:
	_update_health_bar()

func _on_take_damage(_hit_damage:HitDamage, _total_damage:int) -> void:
	_animation_player.stop()
	_animation_player.play("hit", -1, 2)

func _on_die(_character:Character) -> void:
	_health_bar.hide()
	_animation_player.play("die")
	print("dummy die %d / %d" %[_health, _max_health])



