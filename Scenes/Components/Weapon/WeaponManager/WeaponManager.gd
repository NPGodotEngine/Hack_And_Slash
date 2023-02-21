# A class holde number of weapons
class_name WeaponManager
extends Node2D

# warning-ignore-all: RETURN_VALUE_DISCARDED

class SwitchWeaponContext extends Resource:
	var previous_weapon_index = -1
	var current_weapon_index = -1

signal switch_weapon(switch_weapon_context)


# Hold list of weapons 
var weapon_slots: Array = []

# Current index point to the weapon
var current_weapon_index: int = -1 setget set_current_weapon_index

# Whether weapon manager is enabled
var _is_enabled: bool = true


## Getter Setter ##


func set_current_weapon_index(value:int) -> void:
	var pre_weapon_index = current_weapon_index
	current_weapon_index = wrapi(value, 0, weapon_slots.size() - 1)

	if current_weapon_index >= weapon_slots.size():
		current_weapon_index = -1 
		return 

	# disable previous weapon
	if pre_weapon_index >= 0:
		var previous_weapon: Weapon = weapon_slots[pre_weapon_index]
		previous_weapon.inactive()

	# enable current weapon
	var current_weapon: Weapon = weapon_slots[current_weapon_index]
	current_weapon.active()
	
	var switch_weapon_context: SwitchWeaponContext = SwitchWeaponContext.new()
	switch_weapon_context.previous_weapon_index = pre_weapon_index
	switch_weapon_context.current_weapon_index = current_weapon_index

	emit_signal("switch_weapon", switch_weapon_context)
## Getter Setter ##
	

func _ready() -> void:
	collect_weapons()

	GameSaver.connect("save_game", self, "_on_save_game")
	GameSaver.connect("load_game", self, "_on_load_game")

func _on_save_game(saved_data:SavedData) -> void:
	var serialized_weapons := []
	for weapon in weapon_slots:
		# serialized weapon
		serialized_weapons.append((weapon as Weapon).serialize())
	saved_data.data["weapons"] = serialized_weapons

func _on_load_game(saved_data:SavedData) -> void:
	# remove all existing weapons
	if weapon_slots.size() > 0 or get_child_count() > 0:
		weapon_slots.clear()
		for child in get_children():
			child.queue_free()
	
	# deserialize each weapons
	var serizlied_weapons: Array = saved_data.data["weapons"]
	for serialized_weapon in serizlied_weapons:
		# deserialized weapon
		var weapon: Weapon = Global.create_instance(serialized_weapon[Weapon.RESOURCE_NAME_KEY])
		weapon.deserialize(serialized_weapon)
		add_weapon(weapon)

	set_current_weapon_index(0)

func collect_weapons() -> void:
	if weapon_slots.size() > 0:
		for weapon in weapon_slots:
			weapon.queue_free()
	for child in get_children():
		if child is Weapon:
			(child as Weapon).inactive()
			child.weapon_manager = self
			weapon_slots.append(child)

# Execute current weapon's main fire
##
# `from_position` global position for weapon to shoot from
# `to_position` global position for weapon to shoot to
func execute_weapon() -> void:
	if not _is_enabled:
		return

	if weapon_slots.size() <= 0 or current_weapon_index == -1: 
		return

	var weapon: Weapon = weapon_slots[current_weapon_index]
	if weapon:
		weapon.execute()

# Cancel current weapon's main fire
##
# Mainly for weapon requried warm up
func cancel_weapon_execution() -> void:
	if weapon_slots.size() <= 0 or current_weapon_index == -1: 
		return

	var weapon: Weapon = weapon_slots[current_weapon_index]
	if weapon:
		weapon.cancel_execution()

# Excute current weapon's alternative fire
##
# `from_position` global position for weapon to shoot from
# `to_position` global position for weapon to shoot to
func execute_weapon_alt() -> void:
	if not _is_enabled:
		return
		
	if weapon_slots.size() <= 0 or current_weapon_index == -1: 
		return

	var weapon: Weapon = weapon_slots[current_weapon_index]
	if weapon:
		weapon.execute_alt()

# Cancel current weapon's alternative fire 
func cancel_weapon_alt_execution() -> void:
	if weapon_slots.size() <= 0 or current_weapon_index == -1: 
		return

	var weapon: Weapon = weapon_slots[current_weapon_index]
	if weapon:
		weapon.cancel_alt_execution()

# Get weapon by index
##
# `index` index of weapon in weapon slots
func get_weapon_by(index:int):
	if index == -1 or index >= weapon_slots.size(): 
		return null
		
	return weapon_slots[index]

# Add new weapon
##
# `make_current`: `true` make new weapon as current weapon
func add_weapon(new_weapon, make_current:bool=false) -> void:
	if not new_weapon is Weapon:
		return 

	add_child(new_weapon)
	weapon_slots.append(new_weapon)
	new_weapon.weapon_manager = self
	if make_current:
		set_current_weapon_index(weapon_slots.size() - 1)

# Remove a weapon
##
# `index`: index of weapon to remove
func remove_weapon_by(index:int) -> void:
	index = wrapi(index, 0, weapon_slots.size() - 1)
	var weapon: Weapon = weapon_slots[index]
	weapon.inactive()
	weapon_slots.erase(weapon)
	remove_child(weapon)
	if index <= current_weapon_index:
		set_current_weapon_index(current_weapon_index)

# Enable weapon manager
##
# When weapon manager is enabled
# weapon manager can execute current weapon
##
# Eanble weapon manager also active current weapon
func enable() -> void:
	_is_enabled = true

	if current_weapon_index != -1:
		# enable current weapon
		var weapon: Weapon = weapon_slots[current_weapon_index]
		weapon.active()

# Diable weapon manager
##
# When weapon manager is disabled
# weapon manager can't execute current weapon
##
# Disable weapon manager also inactive current weapon
func disable() -> void:
	_is_enabled = false

	if current_weapon_index != -1:
		# disable current weapon
		var weapon: Weapon = weapon_slots[current_weapon_index]
		weapon.inactive()		
