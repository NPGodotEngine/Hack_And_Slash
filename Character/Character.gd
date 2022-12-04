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
signal take_damage(amount)

# Emit when character die
signal die(character)

# Max level
const MAX_LEVEL = 10

# Current level
export (int) var level = 1 setget _set_level

func _set_level(value:int) -> void:
	var old_level = level
	level = int(max(1, min(value, MAX_LEVEL)))
	emit_signal("level_changed", old_level, level)
	if level == MAX_LEVEL:
		emit_signal("max_level_reached", level, MAX_LEVEL)

# Base health
# Character's base health 
# Use as base reference
export (int) var base_heatlh = 100

# Current health
export (int) var health = 100 setget _set_health

# Set character health
func _set_health(value:int) -> void:
	# make sure health is between 0 ~ max health
	var new_health = int(min(max(0, value), max_health))
	var old_health = health
	health = new_health
	emit_signal("health_changed", old_health, new_health)

# Max health
export (int) var max_health = 100 setget _set_max_health

func _set_max_health(value:int) -> void:
	var old_max_health = max_health
	max_health = value
	emit_signal("max_health_changed", old_max_health, max_health)

# Add health to player for level up
export (int) var add_health_per_level = 10

# Base experience
# Use as reference
export (int) var base_exp = 10

# Current experience
export (int) var current_exp = 0 setget _set_current_exp

func _set_current_exp(value:int) -> void:
	var old_exp = current_exp
	current_exp = max(0, value)
	emit_signal("current_exp_changed", old_exp, current_exp)

# Damage
export (int) var damage = 10

# Next experience required to level up
var next_level_exp_requried: int = 0 setget _set_next_level_exp_required

func _set_next_level_exp_required(value:int) -> void:
	var old_exp_required = next_level_exp_requried
	next_level_exp_requried = int(max(0, value))
	emit_signal("next_level_exp_required_changed", old_exp_required, next_level_exp_requried)

# Is character dead
var is_dead: bool = false

func _ready() -> void:
	yield(self, "ready")
	setup()
	
func _process(delta: float) -> void:
	process_tick(delta)

func _physics_process(delta: float) -> void:
	if health <= 0 and not is_dead: 
		die()
		return 

	physics_tick(delta)

# Setup character
func setup() -> void:
	# calculate max health
	self.max_health = base_heatlh + get_health_per_level(level)
	
	# set health to max health
	self.health = max_health

	# set exp required to next level
	self.next_level_exp_requried = get_next_level_exp_required(level)

# Character process tick
func process_tick(_delta) -> void:
	pass

# Character physics tick
func physics_tick(_delta: float) -> void:
	pass

# Character take damage
func take_damge(amount:int) -> void:
	# if character is dead do nothing
	if is_dead: return

	# set new health
	self.health = health - amount
	emit_signal("take_damage", amount)

# Character die
func die() -> void:
	if is_dead: return 
		
	is_dead = true
	emit_signal("die", self)

# Heal character
func heal(amount:int) -> void:
	if is_dead: return
	
	self.health = max(0, min(health + amount, max_health))

# Get amount of additional health by character's current level
# This exclude character's base health
func get_health_per_level(current_level:int) -> int:
	current_level = int(max(1, min(current_level, MAX_LEVEL))) 
	return (current_level - 1) * add_health_per_level

# Increase level
func level_up(amount:int = 1) -> void:
	if is_dead: return 

	self.level += amount
	self.next_level_exp_requried = get_next_level_exp_required(level)
	self.max_health = base_heatlh + get_health_per_level(level)
	heal(max_health)

# Get character's max level
func get_max_level() -> int:
	return MAX_LEVEL

# If character is at max level
func is_max_level() -> bool:
	return level == MAX_LEVEL

# Add exp to character
func add_exp(amount:int) -> void:
	if is_max_level() or is_dead: return
	
	# level up
	var total_exp = current_exp + amount
	while total_exp >= next_level_exp_requried and not is_max_level():
		level_up()
	
	# set current exp
	if is_max_level():
		self.current_exp = next_level_exp_requried
	else:
		self.current_exp = total_exp
		
# Get next level exp requried by current level
func get_next_level_exp_required(current_level:int) -> int:
	return (level - 1 + current_level) * base_exp        
