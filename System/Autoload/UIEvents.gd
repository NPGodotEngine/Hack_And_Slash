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

# Emit when player dodge HUD need to be updated
# `progress`: dodge progress
# `duration`: duration of dodge
signal player_dodge_updated(progress, duration)

## Emit when player ammo count HUD need to be updated
## `ammo_count`: current ammo count
signal player_ammo_updated(ammo_count:int)

## Emit when player ammo in ammo bag HUD need to be updated
## `ammo_count`: current ammo count int ammo bag
signal  player_ammo_bag_update(ammo_count:int)

signal show_player_ammo_ui()
signal hide_player_ammo_ui()

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