# A generice class for weapon
# Any weapons must subclass of this class
# and implement execute method then call
# reload method at right time to 
# begin reloading process
tool 
class_name Weapon
extends Node2D

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT



# Weapon skin
##
# Skin for weapon visual
# onready var weapon_appearance: WeaponSkinManager = (get_weapon_appearance()) setget set_weapon_appearance, get_weapon_appearance


# Weapon manager manage this weapon
var weapon_manager = null


## Getter Setter ##

# func get_weapon_appearance() -> WeaponSkinManager:
# 	for node in get_children():
# 		if node is WeaponSkinManager:
# 			return node
# 	var new_weapon_skin = load("res://Components/Weapons/WeaponSkin/WeaponSkinBlueprint.tscn").instance()
# 	add_child(new_weapon_skin)
# 	new_weapon_skin.owner = self
# 	return new_weapon_skin

# func set_weapon_appearance(new_weapon_appearance:WeaponSkinManager) -> void:
# 	if weapon_appearance:
# 		weapon_appearance.remove_from_parent()
# 	weapon_appearance = new_weapon_appearance
# 	add_child(weapon_appearance)
## Getter Setter ##

## Override ##
# func _get_configuration_warning() -> String:
# 	if weapon_receiver.is_empty():
# 		return "weapon_receiver node path is missing"
# 	if get_node(weapon_receiver) == null:
# 		return "weapon_receiver must"
# 	return ""
	
## Override ##


# Get hit damage from weapon
# func get_hit_damage() -> HitDamage:
# 	var damage: int = get_weapon_damage()
# 	var critical: bool = weapon_receiver.is_critical
# 	var color: Color = (weapon_receiver.critical_color if critical 
# 										else weapon_receiver.damage_color)
# 	var hit_damage: HitDamage = HitDamage.new().init(
# 		weapon_manager.get_manager_owner(),
# 		self,
# 		damage,
# 		critical,
# 		weapon_receiver.critical_multiplier,
# 		color
# 	)

# 	return hit_damage

# Execute weapon
##
# `from_position` global position for weapon to shoot from
# `to_position` global position for weapon to shoot to
# `direction` for weapon's projectile to travel
func execute() -> void:
	pass

# Cancel weapon execution
##
# Specific to weapon that need to warm up
func cancel_execution() -> void:
	pass

# Execute weapon's alternative fire
##
# `from_position` global position for weapon to shoot from
# `to_position` global position for weapon to shoot to
# `direction` for weapon's projectile to travel
func execute_alt() -> void:
	pass

# Cancel weapon's alternative fire execution
##
# Specific to weapon that need to warm up
func cancel_alt_execution() -> void:
	pass


# Active this weapon
func active() -> void:
	pass

# Inactive this weapon
func inactive() -> void:
	pass

func _on_trigger_pulled() -> void:
	print("trigger pulled")
	pass

func _on_ammo_depleted(ammo_count:int, round_per_clip:int) -> void:
	print("ammo depleted %d %d" % [ammo_count, round_per_clip])
	pass

func _on_ammo_count_changed(ammo_count:int, round_per_clip:int) -> void:
	print("ammo count changed %d %d" % [ammo_count, round_per_clip])
	pass

func _on_ammo_begin_reloading(ammo_count:int, round_per_clip:int) -> void:
	print("begin reloading %d %d" % [ammo_count, round_per_clip])
	pass

func _on_ammo_end_reloading(ammo_count:int, round_per_clip:int) -> void:
	print("end reloading %d %d" % [ammo_count, round_per_clip])
	pass



