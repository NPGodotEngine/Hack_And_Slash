extends Node

# warning-ignore-all: UNUSED_SIGNAL


# Emit when need to present damage text
##
# `hit_damage`: `HitDamage`
# `total_damage`: `float`
# `position`: global position
signal present_damage_text(hit_damage, total_damage, position)
