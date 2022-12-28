class_name CriticalStrikeComp
extends Component

# warning-ignore-all: RETURN_VALUE_DISCARDED

# Emit when critical strike multiplier changed
signal critical_strike_multiplier_changed(from, to)

# Emit when min critical strike chance changed
signal min_critical_strike_chance_changed(from, to)

# Emit whe max critical strike chance changed
signal max_critical_strike_chance_changed(from, to)

# Emit when critical strike chance changed
signal critical_strike_chance_changed(from, to)



# Critical strike multiplier
##
# Used to increase damage
export (float) var critical_strike_multiplier = 1.0 setget set_critical_strike_multiplier

# Minimum critical strike chance
export (float) var min_critical_strike_chance = 0.0 setget set_min_critical_strike_chance

# Maximum critical strike chance
export (float) var max_critical_strike_chance = 1.0 setget set_max_critical_strike_chance

# Color of critical strike
export (Color) var critical_strike_color: Color = Color.red

# Critical strike chance
##
# The chance to hit a
# critical strike
export (float, 0.0, 1.0) var critical_strike_chance = min_critical_strike_chance setget set_critical_strike_chance



## Getter Setter ##


func set_critical_strike_multiplier(value:float) -> void:
    var old_value: float = critical_strike_multiplier
    critical_strike_multiplier = max(0.0, value)
    emit_signal("critical_strike_multiplier_changed", old_value, critical_strike_multiplier)

func set_min_critical_strike_chance(value:float) -> void:
    var old_value: float = min_critical_strike_chance
    min_critical_strike_chance = max(0.0, value)
    emit_signal("min_critical_strike_chance_changed", old_value, min_critical_strike_chance)

func set_max_critical_strike_chance(value:float) -> void:
    var old_value: float = max_critical_strike_chance
    max_critical_strike_chance = max(min_critical_strike_chance, value)
    emit_signal("max_critical_strike_chance_changed", old_value, max_critical_strike_chance)

func set_critical_strike_chance(value:float) -> void:
    var old_value: float = critical_strike_chance
    critical_strike_chance = min(max(min_critical_strike_chance, value), max_critical_strike_chance)
    emit_signal("critical_strike_chance_changed", old_value, critical_strike_chance)
## Getter Setter ##


# Return `true` if critical strike otherwise `false`
## 
# RGN base each calls
# Call this for each attacks
func is_critical() -> bool:
	if is_equal_approx(critical_strike_chance, 0.0):
		return false
	
	# check if critical
	return Global.is_in_threshold(critical_strike_chance, 
	min_critical_strike_chance, max_critical_strike_chance)

func to_dictionary() -> Dictionary:
    var state: Dictionary = .to_dictionary()

    var properties: Dictionary = state[PROPERTIES_KEY]
    properties["critical_strike_multiplier"] = critical_strike_multiplier
    properties["min_critical_strike_chance"] = min_critical_strike_chance
    properties["max_critical_strike_chance"] = max_critical_strike_chance
    properties["critical_strike_chance"] = critical_strike_chance

    return state

func from_dictionary(state: Dictionary) -> void:
    .from_dictionary(state)

    var properties: Dictionary = state[PROPERTIES_KEY]
    critical_strike_multiplier = properties["critical_strike_multiplier"]
    min_critical_strike_chance = properties["min_critical_strike_chance"]
    max_critical_strike_chance = properties["max_critical_strike_chance"]
    critical_strike_chance = properties["critical_strike_chance"]
