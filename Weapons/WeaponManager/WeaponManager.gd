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
	

# Setup weapon manager
func setup() -> void:
	.setup()
	# add preset weapons as child
	for weapon_scene in weapon_library:
		var weapon: Weapon = weapon_scene.instance()
		add_child(weapon)
		weapon_slots.append(weapon)
		weapon.setup()
		
		
# Execute a weapon by index
##
# `index` index of weapon in weapon slots
# `position` global position for weapon to shoot
# `direction` if weapon shoot a projectile then this direction can be used
func execute_weapon(index:int, position:Vector2, direction:Vector2) -> void:
	if index >= weapon_slots.size(): return 

	var weapon: Weapon = weapon_slots[index]
	if weapon and weapon.is_weapon_ready:
		weapon.execute(position, direction)

# Cancel a weapon execution by index
##
# Mainly for weapon requried warm up
# `index` index of weapon in weapon slots
func cancel_weapon_execution(index:int) -> void:
	if index >= weapon_slots.size(): return 

	var weapon: Weapon = weapon_slots[index]
	if weapon:
		weapon.cancel_execution()

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