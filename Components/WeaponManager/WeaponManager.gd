# A class holde 2 weapons both primary and
# secondary and manage weapons
class_name WeaponManager
extends Component

signal weapon_index_changed(from_index, to_index)

var weapon_library: Array = [
	preload("res://Components/Weapons/STDWeapon.tscn"),
]

# Hold list of weapons 
var weapon_slots: Array = []

# Current index point to the weapon
var current_weapon_index: int = 0 setget set_current_weapon_index


## Getter Setter ##


func set_current_weapon_index(value:int) -> void:
	var old_weapon_index = current_weapon_index
	current_weapon_index = int(min(max(0, value), weapon_slots.size()-1))

	# disable previous weapon
	var previous_weapon: Weapon = weapon_slots[old_weapon_index]
	previous_weapon.inactive()

	# enable current weapon
	var current_weapon: Weapon = weapon_slots[current_weapon_index]
	current_weapon.active()

	emit_signal("weapon_index_changed", old_weapon_index, current_weapon_index)
## Getter Setter ##
	

# Setup weapon manager
func setup() -> void:
	.setup()
	# add preset weapons as child
	for weapon_scene in weapon_library:
		var weapon: Weapon = weapon_scene.instance()
		add_child(weapon)
		weapon_slots.append(weapon)
		weapon.setup()
		
		
# Execute current weapon's main fire
##
# `from_position` global position for weapon to shoot from
# `to_position` global position for weapon to shoot to
func execute_weapon(from_position:Vector2, to_position:Vector2) -> void:
	var weapon: Weapon = weapon_slots[current_weapon_index]
	if weapon:
		var direction: Vector2 = to_position - from_position
		weapon.execute(from_position, to_position, direction.normalized())

# Cancel current weapon's main fire
##
# Mainly for weapon requried warm up
func cancel_weapon_execution() -> void:
	var weapon: Weapon = weapon_slots[current_weapon_index]
	if weapon:
		weapon.cancel_execution()

# Excute current weapon's alternative fire
##
# `from_position` global position for weapon to shoot from
# `to_position` global position for weapon to shoot to
func execute_weapon_alt(from_position:Vector2, to_position:Vector2) -> void:
	var weapon: Weapon = weapon_slots[current_weapon_index]
	if weapon:
		var direction: Vector2 = to_position - from_position
		weapon.execute_alt(from_position, to_position, direction)

# Cancel current weapon's alternative fire 
func cancel_weapon_alt_execution() -> void:
	var weapon: Weapon = weapon_slots[current_weapon_index]
	if weapon:
		weapon.cancel_alt_execution()

# Get weapon by index
##
# `index` index of weapon in weapon slots
func get_weapon_by(index:int):
	if index >= weapon_slots.size(): return null
		
	if weapon_slots and weapon_slots.size() > 0 and index < weapon_slots.size():
		return weapon_slots[index]
	
	return null

# Get owner that own this weapon manager
func get_manager_owner():
	return get_parent()
