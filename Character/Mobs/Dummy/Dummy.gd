extends Character

# warning-ignore-all:RETURN_VALUE_DISCARDED
# warning-ignore-all:UNUSED_ARGUMENT

export (bool) var _follow_player = false
export (float) var _distance_to_player = 100.0
export (PackedScene) var _damage_label_scene = preload("res://Interface/HUD/DamageLabel.tscn")
export (Vector2) var _damage_label_offset = Vector2.ZERO 

onready var _health_bar := $HealthBar
onready var _animation_player := $AnimationPlayer
onready var _player_detector: Area2D = $PlayerDetector

onready var _health_comp: HealthComp = $HealthComp


var _target: Character = null


func setup() -> void:
	.setup()
	
	# health component signal
	_health_comp.connect("health_depleted", self, "_on_health_depleted")
	_health_comp.connect("health_changed", self, "_on_health_changed")
	_health_comp.connect("max_health_changed", self, "_on_max_health_changed")

	# character signal
	connect("take_damage", self, "_on_take_damage")
	connect("die", self, "_on_die")

	# player detector signal
	_player_detector.connect("body_entered", self, "_on_detect_player")
	_player_detector.connect("body_exited", self, "_on_player_out_of_range")

	# update state
	_update_state()

	# update health bar
	_update_health_bar()

func move_character(delta:float) -> void:
	if _follow_player:
		follow_player(delta)

# Character take damage
func take_damage(hit_damage:HitDamage) -> void:
	.take_damage(hit_damage)
	# if character is dead do nothing
	if is_dead: return

	var total_damage = hit_damage._damage

	# if critical hit
	if hit_damage._is_critical:
		total_damage += total_damage * hit_damage._critical_multiplier

	# set new health
	_health_comp.health -= total_damage

	emit_signal("take_damage", hit_damage, total_damage)

	print("%s take damage:%d, critical:%s critical_multiplier:%f" % [
		self.name, 
		total_damage, 
		hit_damage._is_critical,
		hit_damage._critical_multiplier])

# Update player current state
##
# health, damage
func _update_state() -> void :
	
	# set current health to max health
	_health_comp.health = _health_comp.max_health

# Prompt damage number
func prompt_damage_number(total_damage:int, hit_damage:HitDamage) -> void:
	# Instance a damage label if any
	if _damage_label_scene:
		var damage_label = _damage_label_scene.instance()
		if damage_label:
			call_deferred("add_child", damage_label)
			damage_label.global_position = global_position + _damage_label_offset
			damage_label.set_damage(
				total_damage,
				hit_damage._is_critical, 
				hit_damage._color_of_damage,
				Color.black,
				"-",
				" (Crit)" if hit_damage._is_critical else ""
			)

func follow_player(_delta:float):
	if not _target: return
	
	var direction: Vector2 = _target.global_position - global_position
	var dist_to_target: float = global_position.distance_to(_target.global_position)
	if is_equal_approx(dist_to_target, _distance_to_player) or dist_to_target < _distance_to_player:
		return

	var desired_dist: float = dist_to_target - _distance_to_player
	var desired_velocity: Vector2 = direction.normalized() * get_movement_speed() * sign(desired_dist)
	var steering_velocity = desired_velocity - velocity
	steering_velocity  = steering_velocity * drag_factor
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
	_health_bar.max_value = float(_health_comp.max_health)
	_health_bar.value = float(_health_comp.health)

func _on_health_changed(_from_health:int, _to_health:int) -> void:
	_update_health_bar()

func _on_max_health_changed(_from_max_health:int, _to_max_health:int) -> void:
	_update_health_bar()

func _on_health_depleted() -> void:
	set_is_dead(true)

func _on_take_damage(hit_damage:HitDamage, total_damage:int) -> void:
	# prompt damage number
	prompt_damage_number(total_damage, hit_damage)

	if not is_dead:
		_animation_player.stop()
		_animation_player.play("hit", -1, 2)

func _on_die(_character:Character) -> void:
	_health_bar.hide()
	_animation_player.stop()
	_animation_player.play("dead")
	print("dummy die %d / %d" %[_health_comp.health, _health_comp.max_health])

