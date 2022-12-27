class_name HealthComp
extends Component

# warning-ignore-all: RETURN_VALUE_DISCARDED

# Emit when health is 0
signal health_depleted()

# Emit when health changed
signal health_changed(from_health, to_health)

# Emit when max health changed
signal max_health_changed(from_max_health, to_meax_health)



# Max health
export (int) var max_health = 100 setget set_max_health

# Current health
export (int) var health: int = max_health setget set_health



## Getter Setter ##


# Set current health
##
# Cap value if it is not between 0.0 and max
# Emit signal `health_changed` 
func set_health(value:int) -> void:
	if value == health: return

	var old_health = health
	# make sure health is between 0 ~ max health
	health = int(min(max(0, value), max_health))
	emit_signal("health_changed", old_health, health)
	
	if health == 0:
		emit_signal("health_depleted")

# Set max health
##
# Emit signal `max_health_changed`
func set_max_health(value:int) -> void:
	if value == max_health: return

	var old_max_health = max_health
	max_health = value
	emit_signal("max_health_changed", old_max_health, max_health)

## Getter Setter ##
