# A generic class extended KinematicBody2D 
# and must be extended from object such as
# Player, Monster, NPC anything that is alive
##
# Class manage damge, health and die
class_name Character
extends KinematicBody2D

# Emit when level changed
signal level_changed(from_level, to_level)

# Emit when max level reached
signal max_level_reached(current_level, max_level)

# Emit when experience changed
signal current_exp_changed(from_exp, to_exp)

# Emit when experience required to next level changed
signal next_level_exp_required_changed(from_exp_required, to_exp_required)

# Emit when health changed
signal health_changed(from_health, to_health)

# Emit when max health changed
signal max_health_changed(from_max_health, to_meax_health)

# Emit when taking damage
signal take_damage(hit_damage, total_damage)

# Emit when character die
signal die(character)

# Emit when damage changed
signal damage_changed(from_damage, to_damage)



# Max level
const MAX_LEVEL = 10

# Start level
const START_LEVEL = 1


# Current level
export (int) var _level: int = START_LEVEL setget _set_level



# Max movement speed reduction
const MAX_MOVEMENT_SPEED_REDUCTION = 0.9

# Min movement speed reduction
const MIN_MOVEMENT_SPEED_REDUCTION = 0.0

# Character's basic movement _speed
export var _movement_speed := 250.0

# How fast can player turn from 
# one direction to another
#
# The higher the value the faster player can turn
# and less the smooth of player motion
export (float, 0.1, 1.0) var _drag_factor := 0.5

# Scaled movement speed
# that is included movement speed reudction
var movement_speed: float = _movement_speed setget _no_set, get_movement_speed

# Total movement speed reduction
##
# Value is between min and max usually
# is 0.0 ~ 1.0 but depend on min max setting
var movement_speed_reduction: float = 0.0 setget set_movement_speed_reduction


# Base health
##
# Character's base health 
# Use as base reference
export (int) var _base_health = 100

# Constant value for scaling up 
# character's max health
export (int) var _add_health_per_level = 10

# Max health
var _max_health: int setget _set_max_health

# Current health
var _health: int = _base_health setget _set_health




# Constant experience
##
# Constant for scaling up next level exp requirement
export (int) var _constant_exp = 10

# Next experience required to level up
var _next_level_exp_requried: int = (get_next_level_exp_required(_level)) setget _set_next_level_exp_required

# Current experience
var _current_exp: int = 0 setget _set_current_exp




# Base damage
##
# Character's base damage 
export (int) var _base_damage = 10

# Constant value for scaling up character's
# additional damage
export (int) var _add_damage_per_level = 10

# Current damage
var _damage: int = _base_damage setget _set_damage



# Critical strike multiplier
##
# Multiply incoming damage
# if critical hit on this character
export (float) var _critical_strike_multiplier = 1.0

# Minimum critical strike chance
export (float) var _min_critical_strike_chance = 0.0

# Maximum critical strike chance
export (float) var _max_critical_strike_chance = 1.0

# Critical strike chance
##
# The chance this character can hit a
# critical strike
export (float, 0.0, 1.0) var _critical_strike_chance = _min_critical_strike_chance

export (PackedScene) var _damage_label_tscn = preload("res://Interface/HUD/DamageLabel.tscn")
export (Vector2) var _damage_label_offset = Vector2.ZERO 


# Is character dead
var _is_dead:bool = false setget _set_is_dead



## Getter Setter ##
func _no_set(_value) -> void:
    push_warning("Set property not allowed")
    return

# Set movement speed reduction
##
# Cap value if it is not between min and max
func set_movement_speed_reduction(value:float) -> void:
	# Cap value between min and max
	var new_reduction: float = max(min(value, MAX_MOVEMENT_SPEED_REDUCTION), MIN_MOVEMENT_SPEED_REDUCTION)
	movement_speed_reduction = new_reduction

# Get scaled movement speed
##
# Speed is included speed reduction 
func get_movement_speed() -> float:
	return _movement_speed * (1.0 - movement_speed_reduction)

# Set character's level
##
# Cap value if it is not between min and max
# Emit signal `level_changed`
func _set_level(value:int) -> void:
	if value == _level: return

	var old_level = _level
	_level = int(max(START_LEVEL, min(value, MAX_LEVEL)))
	emit_signal("level_changed", old_level, _level)
	if _level == MAX_LEVEL:
		emit_signal("max_level_reached", _level, MAX_LEVEL)

# Set character's current health
##
# Cap value if it is not between 0.0 and max
# Emit signal `health_changed` 
func _set_health(value:int) -> void:
	if value == _health: return

	var old_health = _health
	# make sure health is between 0 ~ max health
	_health = int(min(max(0, value), _max_health))
	emit_signal("health_changed", old_health, _health)

# Set character's max health
##
# Emit signal `max_health_changed`
func _set_max_health(value:int) -> void:
	if value == _max_health: return

	var old_max_health = _max_health
	_max_health = value
	emit_signal("max_health_changed", old_max_health, _max_health)

# Set character's current experience
##
# Cap value if it is < 0
# Emit signal `current_exp_changed`
func _set_current_exp(value:int) -> void:
	if value == _current_exp: return

	var old_exp = _current_exp
	_current_exp = int(max(0, value))
	emit_signal("current_exp_changed", old_exp, _current_exp)

# Set character's next level exp requried
##
# Cap value if it is < 0.0
# Emit signal `next_level_exp_required_changed`
func _set_next_level_exp_required(value:int) -> void:
	if value == _next_level_exp_requried: return 

	var old_exp_required = _next_level_exp_requried
	_next_level_exp_requried = int(max(0, value))
	emit_signal("next_level_exp_required_changed", old_exp_required, _next_level_exp_requried)

# Set character's damage
##
# Cap value if it is < 0.0
# Emit signal `damage_changed` 
func _set_damage(value:int) -> void:
	if value == _damage: return

	var old_damage = _damage
	_damage = int(max(0, value))
	emit_signal("damage_changed", old_damage, _damage)

# Set character's dead state
##
# Emit signal `die`
func _set_is_dead(value:bool) -> void:
	if value == _is_dead: return

	_is_dead = value
	if _is_dead:
		die()
		emit_signal("die", self)
## Getter Setter ##



## Override ##
func _ready() -> void:
	# make sure character is ready before setup
	yield(self, "ready")
	setup()
	
func _process(delta: float) -> void:
	process_tick(delta)

func _physics_process(delta: float) -> void:
	if _health <= 0 and not _is_dead: 
		_set_is_dead(true)
		return 

	physics_tick(delta)
## Override ##



# Setup character
func setup() -> void:
	_update_config()

# Update character's configuration
func _update_config() -> void:
	# calculate max health and set max health
	_set_max_health(_base_health + get_additional_health_by_level(_level))
	
	# set current health to max health
	_set_health(_max_health)

	# set exp required to next level
	_set_next_level_exp_required(get_next_level_exp_required(_level))

	# increase current damage
	_set_damage(_base_damage + get_additional_damage_by_level(_level))

# Character process tick
func process_tick(_delta) -> void:
	pass

# Character physics tick
func physics_tick(delta: float) -> void:
	move_character(delta)

# Move character
func move_character(_delta:float) -> void:
	pass

# Add amount of reduction to movement speed reduction
##
# The ideal value for amount is between 0.1 ~ 0.9
func add_movement_speed_reduction(amount:float) -> void:
	set_movement_speed_reduction(movement_speed_reduction + amount)

# Remove amount of reduction to movement speed reduction
##
# The ideal value for amount is between 0.1 ~ 0.9
func remove_movement_speed_reduction(amount:float) -> void:
	set_movement_speed_reduction(movement_speed_reduction - amount)

# Character take damage
func take_damage(hit_damage:HitDamage) -> void:
	# if character is dead do nothing
	if _is_dead: return

	var total_damage = hit_damage.damage

	# if critical hit
	if hit_damage.is_critical:
		total_damage *= _critical_strike_multiplier
	
	# Instance a damage label if any
	if _damage_label_tscn:
		var damage_label = _damage_label_tscn.instance()
		if damage_label:
			call_deferred("add_child", damage_label)
			damage_label.global_position = global_position + _damage_label_offset
			damage_label.set_damage(
				total_damage,
				hit_damage.is_critical, 
				hit_damage.color_of_damage,
				Color.black,
				"-",
				" (Crit)" if hit_damage.is_critical else ""
			)

	# set new health
	_set_health(_health - total_damage)

	emit_signal("take_damage", hit_damage, total_damage)

	print("%s take damage: %d, critical: %s" % [self.name, total_damage, hit_damage.is_critical])

# Character die
func die() -> void:
	_set_health(0)
	pass

# Heal character
func heal(amount:int) -> void:
	if _is_dead: return
	
	var new_health: int = int(max(0, min(_health + amount, _max_health)))
	_set_health(new_health)

# Get amount of additional damage by character's current level
# This exclude character's base damage
func get_additional_damage_by_level(current_level:int) -> int:
	current_level = int(max(1, min(current_level, MAX_LEVEL)))
	return (current_level - 1) * _add_damage_per_level 

# Get amount of additional health by character's current level
# This exclude character's base health
func get_additional_health_by_level(current_level:int) -> int:
	current_level = int(max(1, min(current_level, MAX_LEVEL))) 
	return (current_level - 1) * _add_health_per_level

# Increase level
func level_up(amount:int = 1) -> void:
	if _is_dead: return 

	_set_level(_level + amount)

	_update_config()

	heal(_max_health)

# If character is at max level
func is_max_level_reached() -> bool:
	return _level == MAX_LEVEL

# Add exp to character
func add_exp(amount:int) -> void:
	if is_max_level_reached() or _is_dead: return
	
	# level up
	var total_exp = _current_exp + amount
	while (total_exp >= _next_level_exp_requried and 
			not is_max_level_reached()):
		level_up()
	
	# set current exp
	if is_max_level_reached():
		_set_current_exp(_next_level_exp_requried)
	else:
		_set_current_exp(total_exp)
		
# Get next level exp requried by current level
func get_next_level_exp_required(current_level:int) -> int:
	return (current_level - 1 + current_level) * _constant_exp

# If character produce critical strike
## 
# RGN base each calls
# Call this for each attacks
func is_critical() -> bool:
	if is_equal_approx(_critical_strike_chance, 0.0):
		return false
	
	# check if critical
	return Utils.is_in_threshold(_critical_strike_chance, 
	_min_critical_strike_chance, _max_critical_strike_chance)
