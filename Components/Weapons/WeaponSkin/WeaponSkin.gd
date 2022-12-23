class_name WeaponSkin
extends Component

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED

onready var _weapon_base_pos: Position2D = $WeaponBasePos

var base_skin setget , get_base_skin
var stock_skin setget , get_stock_skin
var trigger_skin setget , get_trigger_skin
var ammo_skin setget , get_ammo_skin
var barrel_skin setget , get_barrel_skin
var fire_positions setget, get_fire_positions

func get_base_skin():
	return _weapon_base_pos.get_child(0)

func get_stock_skin():
	var base_skin_node: WeaponBaseSkin = get_base_skin()
	if base_skin_node:
		return base_skin_node.stock_skin
	return null

func get_trigger_skin():
	var base_skin_node: WeaponBaseSkin = get_base_skin()
	if base_skin_node:
		return base_skin_node.trigger_skin
	return null

func get_ammo_skin():
	var base_skin_node: WeaponBaseSkin = get_base_skin()
	if base_skin_node:
		return base_skin_node.ammo_skin
	return null

func get_barrel_skin():
	var base_skin_node: WeaponBaseSkin = get_base_skin()
	if base_skin_node:
		return base_skin_node.barrel_skin
	return null

func get_fire_positions() -> Array:
	var barrel_skin_node: BarrelSkin = get_barrel_skin()
	if barrel_skin_node:
		return barrel_skin_node.fire_points

	return []

func get_component_state(ignore_private: bool = true, property_prefix: String = "_") -> Dictionary:
	var state: Dictionary = .get_component_state(ignore_private, property_prefix)
	state.erase("base_skin")
	state.erase("stock_skin")
	state.erase("trigger_skin")
	state.erase("ammo_skin")
	state.erase("barrel_skin")
	state.erase("fire_positions")

	state["weapon_base_skin"] = _weapon_base_pos.get_child(0).get_component_state()

	return state

func apply_component_state(state:Dictionary) -> void:
	.apply_component_state(state)

	var base_skin_state: Dictionary = state["weapon_base_skin"]

	for node in _weapon_base_pos.get_children():
		_weapon_base_pos.remove_child(node)
	var base_skin_name = base_skin_state["name"] + ".tscn"
	var base_skin_node = load(Global.find_file_in_directory(base_skin_name)).instance()
	_weapon_base_pos.add_child(base_skin_node)
		



