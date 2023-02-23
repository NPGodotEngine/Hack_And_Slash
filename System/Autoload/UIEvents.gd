extends Node

# warning-ignore-all: UNUSED_SIGNAL


# Emit when need to display damage text
##
# `hit_damage`: `HitDamage`
# `total_damage`: `float`
# `position`: global position
signal display_damage_text(hit_damage, total_damage, position)

# Emit when player health HUD need to be updated
##
# `health`: current health
# `max_health`: max health
signal player_health_updated(health, max_health)
