# A class for player controlled character
##
# Manage visual, movement, input
class_name Player
extends Character

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT


# Constant value for scaling up 
# character's max health
export (int) var _add_health_per_level = 10

# Constant value for scaling up character's
# additional damage
export (int) var _add_damage_per_level = 10

# Player skin visual
onready var _skin := $CharacterSkin

# Fire position
onready var _fire_position := $Gun/Position2D

# Gun
onready var _gun := $Gun

onready var _health_bar := $HealthBar

# Weapon manager
onready var weapon_manager: WeaponManager = $WeaponManager

onready var _health_comp: HealthComp = $HealthComp
onready var _level_exp_comp: LevelExpComp = $LevelExpComp
onready var _damage_comp: DamageComp = $DamageComp

export (PackedScene) var _damage_label_scene = preload("res://Interface/HUD/DamageLabel.tscn")
export (Vector2) var _damage_label_offset = Vector2.ZERO 



## Override ##

func setup() -> void:
	.setup()

	# setup components
	weapon_manager.setup()
	_health_comp.setup()
	_level_exp_comp.setup()
	_damage_comp.setup()
	
	# components' signal
	_level_exp_comp.connect("level_up", self, "_on_level_up")
	_health_comp.connect("health_depleted", self, "_on_health_depleted")
	_health_comp.connect("health_changed", self, "_on_health_changed")
	_health_comp.connect("max_health_changed", self, "_on_max_health_changed")
	_damage_comp.connect("damage_changed", self, "_on_damage_changed")

	# character signal
	connect("take_damage", self, "_on_take_damage")
	connect("die", self, "_on_die")

	# update state
	_update_state()

	# update health bar
	_update_health_bar()

	logging()

func physics_tick(delta: float) -> void:
	.physics_tick(delta)

	_update_skin()
	_execute_weapons()

func move_character(_delta:float) -> void:
	# Get direction from input
	var direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

	# Smoothing player turing direction
	var desired_velocity := direction * get_movement_speed()
	var steering_velocity = desired_velocity - velocity
	steering_velocity  = steering_velocity * drag_factor
	velocity += steering_velocity

	# Move player
	velocity = move_and_slide(velocity)

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
		self.name, total_damage, 
		hit_damage._is_critical,
		hit_damage._critical_multiplier])

func die() -> void:
	.die()
	_health_comp.health = 0

## Override ##



# Update player current state
##
# health, damage
func _update_state() -> void :
	# calculate max health and set max health
	_health_comp.max_health = _health_comp.max_health + get_additional_health_by_level(_level_exp_comp._level)
	
	# set current health to max health
	_health_comp.health = _health_comp.max_health

	# increase current damage
	_damage_comp.damage = _damage_comp.damage + get_additional_damage_by_level(_level_exp_comp._level)

func _update_skin() -> void:
	# Update skin 
	var global_mouse_position := get_global_mouse_position()

	if global_mouse_position.x < global_position.x:
		_skin.scale.x = -1.0 * _skin.scale.abs().x
	else:
		_skin.scale.x = 1.0 * _skin.scale.abs().x

func _execute_weapons() -> void:
	assert(weapon_manager, "weapon manager missing")

	# execute weapon 
	if Input.is_action_pressed("primary"): 
		weapon_manager.execute_weapon(_fire_position.global_position, get_global_mouse_position())
	elif Input.is_action_just_released("primary"):
		weapon_manager.cancel_weapon_execution()

	if Input.is_action_pressed("secondary"):
		weapon_manager.execute_weapon_alt(_fire_position.global_position, get_global_mouse_position())
	elif Input.is_action_just_released("secondary"):
		weapon_manager.cancel_weapon_alt_execution()

func _update_health_bar() -> void:
	_health_bar.min_value = float(0)
	_health_bar.max_value = float(_health_comp.max_health)
	_health_bar.value = float(_health_comp.health)

func _on_level_up(from_level:int, to_level:int) -> void:
	_update_state()

func _on_health_changed(_from_health:int, _to_health:int) -> void:
	_update_health_bar()

func _on_max_health_changed(_from_max_health:int, _to_max_health:int) -> void:
	_update_health_bar()

func _on_health_depleted() -> void:
	set_is_dead(true)

func _on_take_damage(hit_damage:HitDamage, total_damage:int) -> void:
	# prompt damage number
	prompt_damage_number(total_damage, hit_damage)
	_update_health_bar()

func _on_damage_changed(from_damage:int, to_damage:int) -> void:
	print("player damage changed %d -> %d" % [from_damage, to_damage])

func _on_die(character:Character) -> void:
	print("player die %d / %d" %[_health_comp.health, _health_comp.max_health])

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

# Get amount of additional health by character's current level
# This exclude character's base health
func get_additional_health_by_level(current_level:int) -> int:
	current_level = int(max(0, min(current_level, _level_exp_comp._max_level))) 
	return (current_level - 1) * _add_health_per_level

# Get amount of additional damage by character's current level
# This exclude character's base damage
func get_additional_damage_by_level(current_level:int) -> int:
	current_level = int(max(0, min(current_level, _level_exp_comp._max_level)))
	return (current_level - 1) * _add_damage_per_level

# Heal character
func heal(amount:int) -> void:
	if is_dead: return
	
	var new_health: int = int(max(0, min(_health_comp.health + amount,_health_comp.max_health)))
	_health_comp.health = new_health

# for testing health bar
func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("ui_down"): 
		if not is_dead:
			_level_exp_comp.add_exp(randi() % 10 + 1)
		logging()
	
	if event.is_action_pressed("ui_left"):
		var crit = randi()%2
		var hit_damage = HitDamage.new().init(
			null, 
			null, 
			randi()%10+1, 
			crit,
			0.0,
			Color.red if crit else Color.white)
		take_damage(hit_damage)
		logging()

func logging() -> void:
	print("level:%d, max_level:%d exp:%d, next_exp:%d, health:%d, max_health:%d, damage:%d, dead:%s" % 
			[_level_exp_comp._level, 
			_level_exp_comp._max_level, 
			_level_exp_comp._current_exp, 
			_level_exp_comp._next_level_exp_requried, 
			_health_comp.health,
			_health_comp.max_health, 
			_damage_comp.damage, 
			is_dead])
	print("base_movement_speed:%f, speed:%f, movement_multiplier:%f" % [
		movement_speed, 
		get_movement_speed(), 
		movement_speed_multiplier])
		
	