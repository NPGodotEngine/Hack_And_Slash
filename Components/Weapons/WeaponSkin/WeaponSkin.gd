class_name WeaponSkin
extends Component

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED

onready var _weapon_base_pos: Position2D = $WeaponBasePos

var base_skin: WeaponBaseSkin = null setget set_base_skin, get_base_skin
var stock_skin: Component = null setget set_stock_skin, get_stock_skin
var trigger_skin: Component = null setget set_trigger_skin, get_trigger_skin
var ammo_skin: Component = null setget set_ammo_skin, get_ammo_skin
var barrel_skin: Component = null setget set_barrel_skin, get_barrel_skin
var fire_positions: Array = [] setget , get_fire_positions

func get_base_skin():
	if _weapon_base_pos == null: return null
	return _weapon_base_pos.get_child(0)

func set_base_skin(new_base_skin:WeaponBaseSkin) -> void:
	if not _weapon_base_pos == null:
		var existing_base_skin: WeaponBaseSkin = _weapon_base_pos.get_child(0)
		if existing_base_skin:
			var tmp_stock_skin: Component = existing_base_skin.stock_skin
			tmp_stock_skin.remove_from_parent(false)
			var tmp_trigger_skin: Component = existing_base_skin.trigger_skin
			tmp_trigger_skin.remove_from_parent(false)
			var tmp_ammo_skin: Component = existing_base_skin.ammo_skin
			tmp_ammo_skin.remove_from_parent(false)
			var tmp_barrel_skin: Component = existing_base_skin.barrel_skin
			tmp_barrel_skin.remove_from_parent(false)

			existing_base_skin.remove_from_parent()
			_weapon_base_pos.add_child(new_base_skin)

			new_base_skin.stock_skin = tmp_stock_skin
			new_base_skin.trigger_skin = tmp_trigger_skin
			new_base_skin.ammo_skin = tmp_ammo_skin
			new_base_skin.barrel_skin = tmp_barrel_skin

func get_stock_skin():
	var base_skin_node: WeaponBaseSkin = get_base_skin()
	if base_skin_node:
		return base_skin_node.stock_skin
	return null

func set_stock_skin(new_stock_skin:Component) -> void:
	var base_skin_node: WeaponBaseSkin = get_base_skin()
	if base_skin_node:
		base_skin_node.stock_skin = new_stock_skin

func get_trigger_skin():
	var base_skin_node: WeaponBaseSkin = get_base_skin()
	if base_skin_node:
		return base_skin_node.trigger_skin
	return null

func set_trigger_skin(new_trigger_skin:Component) -> void:
	var base_skin_node: WeaponBaseSkin = get_base_skin()
	if base_skin_node:
		base_skin_node.trigger_skin = new_trigger_skin

func get_ammo_skin():
	var base_skin_node: WeaponBaseSkin = get_base_skin()
	if base_skin_node:
		return base_skin_node.ammo_skin
	return null

func set_ammo_skin(new_ammo_skin:Component) -> void:
	var base_skin_node: WeaponBaseSkin = get_base_skin()
	if base_skin_node:
		base_skin_node.ammo_skin = new_ammo_skin

func get_barrel_skin():
	var base_skin_node: WeaponBaseSkin = get_base_skin()
	if base_skin_node:
		return base_skin_node.barrel_skin
	return null

func set_barrel_skin(new_barrel_skin:Component):
	var base_skin_node: WeaponBaseSkin = get_base_skin()
	if base_skin_node:
		base_skin_node.barrel_skin = new_barrel_skin

func get_fire_positions() -> Array:
	var barrel_skin_node: BarrelSkin = get_barrel_skin()
	if barrel_skin_node:
		return barrel_skin_node.fire_points

	return []

func to_dictionary() -> Dictionary:
	var state: Dictionary = .to_dictionary()

	var sub_node_states: Dictionary = {}
	sub_node_states["base_skin"] = _weapon_base_pos.get_child(0).to_dictionary()
	state["sub_node_states"] = sub_node_states

	return state

func from_dictionary(state:Dictionary) -> void:
	.from_dictionary(state)

	assert(_weapon_base_pos, "missing Position2D for weapon base skin")

	for node in _weapon_base_pos.get_children():
		var child_node: Component = _weapon_base_pos.get_child(0)
		if child_node:
			child_node.remove_from_parent()
	
	var sub_node_states: Dictionary = state["sub_node_states"]
	var base_skin_state: Dictionary = sub_node_states["base_skin"]

	var base_skin_node: WeaponBaseSkin = Global.create_instance(base_skin_state[RESOURCE_NAME_KEY])
	_weapon_base_pos.add_child(base_skin_node)
	base_skin_node.from_dictionary(base_skin_state)
		



