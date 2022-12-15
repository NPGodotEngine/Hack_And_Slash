# A class holde 2 weapons both primary and
# secondary and manage weapons
class_name WeaponManager
extends Component

var weapon_library: Array = [
	preload("res://Weapons/Projectile/FireWeapon/FireWeapon.tscn"),
	preload("res://Weapons/Projectile/CryoWeapon/CryoWeapon.tscn")
]

# Hold list of weapons 
var weapon_slots: Array = []

# Current index point to the weapon
var current_weapon_index: int = 0 setget set_current_weapon_index


func set_current_weapon_index(value:int) -> void:
	var old_weapon_index = current_weapon_index
	current_weapon_index = min(max(0, value), weapon_slots.size()-1)
	# TODO: switch weapon

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
# `position` global position for weapon to shoot
# `direction` if weapon shoot a projectile then this direction can be used
func execute_weapon(position:Vector2, direction:Vector2) -> void:
	var weapon: Weapon = weapon_slots[current_weapon_index]
	if weapon:
		weapon.execute(position, direction)

# Cancel current weapon's main fire
##
# Mainly for weapon requried warm up
func cancel_weapon_execution() -> void:
	var weapon: Weapon = weapon_slots[current_weapon_index]
	if weapon:
		weapon.cancel_execution()

# Excute current weapon's alternative fire
##
# `position` global position for weapon to shoot
# `direction` if weapon shoot a projectile then this direction can be used
func execute_weapon_alt(position:Vector2, direction:Vector2) -> void:
	var weapon: Weapon = weapon_slots[current_weapon_index]
	if weapon:
		weapon.execute_alt(position, direction)

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
