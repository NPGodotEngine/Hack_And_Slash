extends Node

# warning-ignore-all: UNUSED_SIGNAL


# Emit when need to display damage text
##
# `hit_damage`: `HitDamage`
# `total_damage`: `float`
# `position`: global position
# `damage_text_ui`: ui for damage text
signal display_damage_text(hit_damage, total_damage, damage_text_ui)

# Emit when player health HUD need to be updated
##
# `health`: current health
# `max_health`: max health
signal player_health_updated(health, max_health)

# Emit when player dash HUD need to be updated
# `progress`: dash progress
# `duration`: duration of dash
signal player_dash_updated(progress, duration)

# Emit when player ammo count HUD need to be updated
# `ammo_count`: current ammo count
# `max_ammo_count`: ammo count at max
signal player_ammo_updated(ammo_count, max_ammo_count)

# Emit when a weapon crosshair need to be added
# to HUD
##
# `crosshair`: crosshair  Node2D object
signal add_weapon_crosshair(crosshair)

# Emit when a weapon reload indicator need to be add
# to HUD
##
# `reload_indicator`: indicator Node2D object
signal add_weapon_reload_indicator(reload_indicator)

# Emit when a float health bar ui need to be added
# to World UI
##
# `float_health_bar_ui`: the ui for float health bar
signal add_float_health_bar_ui(float_health_bar_ui)
