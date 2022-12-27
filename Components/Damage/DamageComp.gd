class_name DamageComp
extends Component

# warning-ignore-all: RETURN_VALUE_DISCARDED

# Emit when damage changed
signal damage_changed(from_damage, to_damage)


# Current damage
export (int) var damage: int = 10 setget set_damage

# Color for damage
export (Color) var damage_color: Color = Color.white

## Getter Setter ##


# Set damage
##
# Cap value if it is < 0.0
# Emit signal `damage_changed` 
func set_damage(value:int) -> void:
	if value == damage: return

	var old_damage = damage
	damage = int(max(0, value))
	emit_signal("damage_changed", old_damage, damage)

## Getter Setter ##



func to_dictionary() -> Dictionary:
	var state: Dictionary = .to_dictionary()

	state["damage"] = damage

	return state