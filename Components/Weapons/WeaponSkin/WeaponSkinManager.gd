class_name WeaponSkinManager
extends Component

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED

onready var _weapon_receiver_pos: Position2D = $WeaponReceiverPos

var receiver_skin: WeaponReceiverSkin = null setget set_receiver_skin, get_receiver_skin
var trigger_skin: Component = null setget set_trigger_skin, get_trigger_skin
var ammo_skin: Component = null setget set_ammo_skin, get_ammo_skin
var fire_positions: Array = [] setget , get_fire_positions

func get_receiver_skin():
	if _weapon_receiver_pos == null: return null
	return _weapon_receiver_pos.get_child(0)

func set_receiver_skin(new_receiver_skin:WeaponReceiverSkin) -> void:
	if not _weapon_receiver_pos == null:
		var existing_base_skin: WeaponReceiverSkin = _weapon_receiver_pos.get_child(0)
		if existing_base_skin:
			var tmp_trigger_skin: Component = existing_base_skin.trigger_skin
			tmp_trigger_skin.remove_from_parent(false)
			var tmp_ammo_skin: Component = existing_base_skin.ammo_skin
			tmp_ammo_skin.remove_from_parent(false)

			existing_base_skin.remove_from_parent()
			_weapon_receiver_pos.add_child(new_receiver_skin)

			new_receiver_skin.trigger_skin = tmp_trigger_skin
			new_receiver_skin.ammo_skin = tmp_ammo_skin

func get_trigger_skin():
	var receiver_skin_node: WeaponReceiverSkin = get_receiver_skin()
	if receiver_skin_node:
		return receiver_skin_node.trigger_skin
	return null

func set_trigger_skin(new_trigger_skin:Component) -> void:
	var receiver_skin_node: WeaponReceiverSkin = get_receiver_skin()
	if receiver_skin_node:
		receiver_skin_node.trigger_skin = new_trigger_skin

func get_ammo_skin():
	var receiver_skin_node: WeaponReceiverSkin = get_receiver_skin()
	if receiver_skin_node:
		return receiver_skin_node.ammo_skin
	return null

func set_ammo_skin(new_ammo_skin:Component) -> void:
	var receiver_skin_node: WeaponReceiverSkin = get_receiver_skin()
	if receiver_skin_node:
		receiver_skin_node.ammo_skin = new_ammo_skin

func get_fire_positions() -> Array:
	var receiver_skin_node: WeaponReceiverSkin = get_receiver_skin()
	if receiver_skin_node:
		return receiver_skin_node.fire_positions

	return []

func to_dictionary() -> Dictionary:
	var state: Dictionary = .to_dictionary()

	var sub_node_states: Dictionary = state[SUB_NODE_STATE_KEY]
	sub_node_states["receiver_skin"] = _weapon_receiver_pos.get_child(0).to_dictionary()

	return state

func from_dictionary(state:Dictionary) -> void:
	.from_dictionary(state)

	assert(_weapon_receiver_pos, "missing Position2D for weapon receiver skin")

	for node in _weapon_receiver_pos.get_children():
		var child_node: Component = _weapon_receiver_pos.get_child(0)
		if child_node:
			child_node.remove_from_parent()
	
	var sub_node_states: Dictionary = state[SUB_NODE_STATE_KEY]
	var receiver_skin_state: Dictionary = sub_node_states["receiver_skin"]

	var receiver_skin_node: WeaponReceiverSkin = Global.create_instance(receiver_skin_state[RESOURCE_NAME_KEY])
	_weapon_receiver_pos.add_child(receiver_skin_node)
	receiver_skin_node.from_dictionary(receiver_skin_state)
		



