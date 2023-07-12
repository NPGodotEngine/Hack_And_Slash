class_name WeaponAttributes
extends Resource



# Max damage
export (float) var max_damage: float = 1000.0

# Min damage
export (float) var min_damage: float = 1.0

# Critical chance
export (float, 0.0, 1.0) var critical_chance = 0.0

# Critical_multiplier
export (float) var critical_multiplier: float = 1.0

# Accuracy
export (float, 0.0, 1.0) var accuracy = 0.5

# Trigger duration
export (float) var trigger_duration: float = 1.0

# Reload duration
export (float) var reload_duration: float = 1.0

# Round per clip
export (int) var round_per_clip: int = 30