tool
extends Sprite

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT


export (NodePath) var weapon: NodePath

func _get_configuration_warning() -> String:
	if weapon.is_empty():
		return "weapon node path is missing"
	if not get_node(weapon) is Weapon:
		return "weapon node path refer to none Weapon type object"

	return ""

func _ready() -> void:
	var wp: Weapon = get_node(weapon) as Weapon
	wp.connect("weapon_active", self, "on_weapon_active")
	wp.connect("weapon_inactive", self, "on_weapon_inactive")

func on_weapon_active(wp:Weapon) -> void:
	self.show()

func on_weapon_inactive(wp:Weapon) -> void:
	self.hide()

