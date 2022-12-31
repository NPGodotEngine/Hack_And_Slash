class_name WeaponReceiverSkin
extends Component

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED


onready var _trigger_pos: Position2D = $TriggerPos
onready var _ammo_pos: Position2D = $AmmoPos
onready var _fire_point_root: Position2D = $FirePointRoot

var trigger_skin: Component = null setget set_trigger_skin, get_trigger_skin
var ammo_skin: Component = null setget set_ammo_skin, get_ammo_skin
var fire_positions: Array = [] setget , get_fire_positions


func get_trigger_skin():
    if _trigger_pos == null: return null
    return _trigger_pos.get_child(0)

func get_ammo_skin():
    if _ammo_pos == null: return null
    return _ammo_pos.get_child(0)


func set_trigger_skin(new_trigger_skin:Component) -> void:
    for node in _trigger_pos.get_children():
        (node as Component).remove_from_parent()
    _trigger_pos.add_child(new_trigger_skin)

func set_ammo_skin(new_ammoskin:Component) -> void:
    for node in _ammo_pos.get_children():
        (node as Component).remove_from_parent()
    _ammo_pos.add_child(new_ammoskin)

func get_fire_positions() -> Array:
    var fire_pos_list: Array = []

    if _fire_point_root == null:
        return fire_pos_list
    
    for fire_pos in _fire_point_root.get_children():
        fire_pos_list.append(fire_pos.global_position)
    
    return fire_pos_list


func to_dictionary() -> Dictionary:
    var state: Dictionary = .to_dictionary()

    var sub_node_states: Dictionary = state[SUB_NODE_STATE_KEY]
    sub_node_states["trigger"] = _trigger_pos.get_child(0).to_dictionary()
    sub_node_states["ammo"] = _ammo_pos.get_child(0).to_dictionary()

    return state

func from_dictionary(state: Dictionary) -> void:
    .from_dictionary(state)

    var sub_node_states: Dictionary = state[SUB_NODE_STATE_KEY]

    var trigger_skin_node: Component = Global.create_instance(sub_node_states["trigger"][RESOURCE_NAME_KEY])
    set_trigger_skin(trigger_skin_node)
    trigger_skin_node.from_dictionary(sub_node_states["trigger"])

    var ammo_skin_node: Component = Global.create_instance(sub_node_states["ammo"][RESOURCE_NAME_KEY])
    set_ammo_skin(ammo_skin_node)
    ammo_skin_node.from_dictionary(sub_node_states["ammo"])
        




