class_name CriticalComponent
extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED


class CriticalMinChanceContext extends Resource:
    var previous_min_critical_chance: float = 0.0
    var updated_min_critical_chance: float = 0.0

class CriticalMaxChanceContext extends Resource:
    var previous_max_critical_chance: float = 0.0
    var updated_max_critical_chance: float = 0.0

class CriticalChanceContext extends Resource:
    var previous_critical_chance: float = 0.0
    var updated_critical_chance: float = 0.0


# Emit when min critical strike chance changed
##
# `critical_min_chance_context`: class `CriticalMinChanceContext`
signal min_critical_chance_updated(critical_min_chance_context)

# Emit whe max critical strike chance changed
##
# `critical_max_chance_context`: class : `CriticalMaxChanceContext`
signal max_critical_chance_updated(critical_max_chance_context)

# Emit when critical strike chance changed
##
# `critical_chance_context`: class `CriticalChanceContext`
signal critical_chance_updated(critical_chance_context)



# Critical strike multiplier
##
# Used to increase damage
export (float) var critical_multiplier: float = 1.0 setget set_critical_multiplier

# Minimum critical strike chance
export (float) var min_critical_chance: float = 0.0 setget set_min_critical_chance

# Maximum critical strike chance
export (float) var max_critical_chance: float = 1.0 setget set_max_critical_chance

# Color of critical strike
export (Color) var critical_color: Color = Color.red

# Critical strike chance
##
# The chance to hit a
# critical strike
export (float, 0.0, 1.0) var critical_chance = 0.3 setget set_critical_strike_chance



## Getter Setter ##


func set_critical_multiplier(value:float) -> void:
    critical_multiplier = max(0.0, value)

func set_min_critical_chance(value:float) -> void:
    var prev_min_critical: float = min_critical_chance
    min_critical_chance = max(0.0, value)

    var critical_min_context: CriticalMinChanceContext = CriticalMinChanceContext.new()
    critical_min_context.previous_min_critical_chance = prev_min_critical
    critical_min_context.updated_min_critical_chance = min_critical_chance

    emit_signal("min_critical_chance_updated", critical_min_context)

func set_max_critical_chance(value:float) -> void:
    var prev_max_critical: float = max_critical_chance
    max_critical_chance = max(min_critical_chance, value)

    var critical_max_context: CriticalMaxChanceContext = CriticalMaxChanceContext.new()
    critical_max_context.previous_max_critical_chance = prev_max_critical
    critical_max_context.updated_max_critical_chance = max_critical_chance

    emit_signal("max_critical_chance_updated", critical_max_context)

func set_critical_strike_chance(value:float) -> void:
    var prev_critical: float = critical_chance
    critical_chance = min(max(min_critical_chance, value), max_critical_chance)

    var critical_chance_context: CriticalChanceContext = CriticalChanceContext.new()
    critical_chance_context.previous_critical_chance = prev_critical
    critical_chance_context.updated_critical_chance = critical_chance

    emit_signal("critical_chance_updated", critical_chance_context)
## Getter Setter ##


# Return `true` if critical strike otherwise `false`
## 
# RGN base each calls
# Call this for each attacks
func is_critical() -> bool:
	if is_equal_approx(critical_chance, 0.0):
		return false
	
	# check if critical
	return Global.is_in_threshold(critical_chance, 
	min_critical_chance, max_critical_chance)

