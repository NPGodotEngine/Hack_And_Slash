# A class holde number of weapons
class_name WeaponManager
extends Component

signal weapon_index_changed(from_index, to_index)


# Hold list of weapons 
var weapon_slots: Array = []

# Current index point to the weapon
var current_weapon_index: int = -1 setget set_current_weapon_index

onready var weapon_blueprint = preload("res://Components/Weapons/WeaponBlueprint.tscn")


## Getter Setter ##


func set_current_weapon_index(value:int) -> void:
	var old_weapon_index = current_weapon_index
	current_weapon_index = wrapi(value, 0, weapon_slots.size() - 1)

	if current_weapon_index >= weapon_slots.size():
		current_weapon_index = -1 
		return 

	# disable previous weapon
	if old_weapon_index >= 0:
		var previous_weapon: Weapon = weapon_slots[old_weapon_index]
		previous_weapon.inactive()

	# enable current weapon
	var current_weapon: Weapon = weapon_slots[current_weapon_index]
	current_weapon.active()

	emit_signal("weapon_index_changed", old_weapon_index, current_weapon_index)
## Getter Setter ##
	

## Override ##


# Setup weapon manager
func setup() -> void:
	.setup()

func _physics_process(_delta: float) -> void:
	var weapon: Weapon = get_weapon_by(current_weapon_index)
	if weapon:
		# Update weapon skin facing direction
		var global_mouse_position := get_global_mouse_position()

		if global_mouse_position.x < global_position.x:
			weapon.scale.y = -1.0 * weapon.scale.abs().y
		else:
			weapon.scale.y = 1.0 * weapon.scale.abs().y

		var point_dir: Vector2 = global_mouse_position - weapon.global_position
		weapon.rotation = point_dir.angle()
		
## Override ##


# Execute current weapon's main fire
##
# `from_position` global position for weapon to shoot from
# `to_position` global position for weapon to shoot to
func execute_weapon() -> void:
	if weapon_slots.size() <= 0: return

	var weapon: Weapon = weapon_slots[current_weapon_index]
	if weapon:
		weapon.execute()

# Cancel current weapon's main fire
##
# Mainly for weapon requried warm up
func cancel_weapon_execution() -> void:
	if weapon_slots.size() <= 0: return

	var weapon: Weapon = weapon_slots[current_weapon_index]
	if weapon:
		weapon.cancel_execution()

# Excute current weapon's alternative fire
##
# `from_position` global position for weapon to shoot from
# `to_position` global position for weapon to shoot to
func execute_weapon_alt() -> void:
	if weapon_slots.size() <= 0: return

	var weapon: Weapon = weapon_slots[current_weapon_index]
	if weapon:
		weapon.execute_alt()

# Cancel current weapon's alternative fire 
func cancel_weapon_alt_execution() -> void:
	if weapon_slots.size() <= 0: return

	var weapon: Weapon = weapon_slots[current_weapon_index]
	if weapon:
		weapon.cancel_alt_execution()

# Get weapon by index
##
# `index` index of weapon in weapon slots
func get_weapon_by(index:int):
	if index < 0: return null
	if index >= weapon_slots.size(): return null
		
	if weapon_slots and weapon_slots.size() > 0 and index < weapon_slots.size():
		return weapon_slots[index]
	
	return null

func add_weapon(new_weapon:Weapon, make_current:bool=false) -> void:
	add_child(new_weapon)
	weapon_slots.append(new_weapon)
	new_weapon.weapon_manager = self
	new_weapon.setup()
	if make_current:
		set_current_weapon_index(weapon_slots.size() - 1)

func remove_weapon_by(index:int) -> void:
	index = wrapi(index, 0, weapon_slots.size() - 1)
	var weapon: Weapon = weapon_slots[index]
	weapon.inactive()
	weapon_slots.erase(weapon)
	remove_child(weapon)
	if index <= current_weapon_index:
		set_current_weapon_index(current_weapon_index)

# Get owner that own this weapon's manager
func get_manager_owner():
	return get_parent()
	
func save(save_game:SaveGame) -> void:
	var state: Dictionary = {
		"weapons": [],
	}
	for slot in weapon_slots:
		var weapon: Weapon = slot
		var weapon_state: Dictionary = weapon.to_dictionary()
		state["weapons"].append(weapon_state)
	save_game.data[name] = state

func load(save_game:SaveGame) -> void:
	for weapon in weapon_slots:
		(weapon as Component).remove_from_parent()
	weapon_slots.clear()

	var state: Dictionary = save_game.data[name]
	var weapons: Array = state["weapons"]
	
	for weapon_state in weapons:
		var new_weapon: Weapon = weapon_blueprint.instance()
		new_weapon.from_dictionary(weapon_state)
		add_weapon(new_weapon)
