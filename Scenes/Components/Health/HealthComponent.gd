class_name HealthComponent
extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED


# Max health context
class MaxHealthContext extends Resource:

	# Previous max health
	var previous_max_health: float = 0.0

	# Updated max health
	var updated_max_health: float = 0.0
	
# Health context
class HealthContext extends Resource:

	# Previous health
	var previous_health: float = 0.0

	# Update health
	var updated_health: float = 0.0

	# Max health
	var max_health: float = 0.0



# Emit when health is 0
signal die()

# Emit when health is lower
# or equal to low health threshold
##
# `health_context`: class `HealthContext`
signal low_health_alert(health_context)

# Emit when health changed
##
# `health_context`: class `HealthContext`
signal health_updated(health_context)

# Emit when max health changed
##
# `max_health_context`: class `MaxHealthContext`
signal max_health_updated(max_health_context)



# Max health
@export var max_health: float = 100.0: set = set_max_health

# Low health threshold
# alert when health is equal
# or lower than this value
@export var low_health_threshold: float = 25.0

# Current health
var _health: float = max_health: set = set_health



## Getter Setter ##


func set_max_health(value:float) -> void:
	if is_equal_approx(value, max_health): return

	var prev_max_health = max_health
	max_health = round(value)

	# health was as same as max health means it is full
	# health then make health as same as new max health
	if is_equal_approx(_health, prev_max_health):
		set_health(max_health)

	var max_health_context: MaxHealthContext = MaxHealthContext.new()
	max_health_context.previous_max_health = prev_max_health
	max_health_context.updated_max_health = max_health

	emit_signal("max_health_updated", max_health_context)

func set_health(value:float) -> void:
	if is_equal_approx(value, _health): return

	var prev_health = _health
	# make sure health is between 0 ~ max health
	_health = min(max(0, value), max_health)
	_health = round(_health)
	
	var health_context: HealthContext = HealthContext.new()
	health_context.previous_health = prev_health
	health_context.updated_health = _health
	health_context.max_health = max_health

	emit_signal("health_updated", health_context)
	
	# health is lower than or equal to low health threshold
	if (is_equal_approx(_health, low_health_threshold) or 
		_health < low_health_threshold):
		emit_signal("low_health_alert", health_context)

	# health reach 0 
	if is_equal_approx(_health, 0.0):
		emit_signal("die")

## Getter Setter ##



# Call to reduce health
##
# `damage_amount`: amount of damage to reduce helath
# negative value result in nothing
func damage(damage_amount:float) -> void:
	# do nothing if negative value
	if damage_amount < 0.0 or sign(damage_amount) < 0.0:
		return

	set_health(_health - damage_amount)

# Call to add health
##
# `heal_amount`: amount of heal to health
# negative value result in nothing
func heal(heal_amount:float) -> void:
	# do nothing if negative value
	if heal_amount < 0.0 or sign(heal_amount) < 0.0:
		return
	
	set_health(_health + heal_amount)