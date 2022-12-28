class_name WeaponBaseSkin
extends Component

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED

onready var _stock_pos: Position2D = $StockPos
onready var _trigger_pos: Position2D = $TriggerPos
onready var _ammo_pos: Position2D = $AmmoPos
onready var _barrel_pos: Position2D = $BarrelPos

var stock_skin: Component = null setget set_stock_skin, get_stock_skin
var trigger_skin: Component = null setget set_trigger_skin, get_trigger_skin
var ammo_skin: Component = null setget set_ammo_skin, get_ammo_skin
var barrel_skin: Component = null setget set_barrel_skin, get_barrel_skin

func get_stock_skin():
    if _stock_pos == null: return null
    return _stock_pos.get_child(0)

func get_trigger_skin():
    if _trigger_pos == null: return null
    return _trigger_pos.get_child(0)

func get_ammo_skin():
    if _ammo_pos == null: return null
    return _ammo_pos.get_child(0)

func get_barrel_skin():
    if _barrel_pos == null: return null
    return _barrel_pos.get_child(0)

func set_stock_skin(new_stock_skin:Component) -> void:
    for node in _stock_pos.get_children():
        (node as Component).remove_from_parent()
    _stock_pos.add_child(new_stock_skin)

func set_trigger_skin(new_trigger_skin:Component) -> void:
    for node in _trigger_pos.get_children():
        (node as Component).remove_from_parent()
    _trigger_pos.add_child(new_trigger_skin)

func set_ammo_skin(new_ammoskin:Component) -> void:
    for node in _ammo_pos.get_children():
        (node as Component).remove_from_parent()
    _ammo_pos.add_child(new_ammoskin)

func set_barrel_skin(new_barrel_skin:Component) -> void:
    for node in _barrel_pos.get_children():
        (node as Component).remove_from_parent()
    _barrel_pos.add_child(new_barrel_skin)

func to_dictionary() -> Dictionary:
    var state: Dictionary = .to_dictionary()

    var sub_node_states: Dictionary = state[SUB_NODE_STATE_KEY]
    sub_node_states["stock"] = _stock_pos.get_child(0).to_dictionary()
    sub_node_states["trigger"] = _trigger_pos.get_child(0).to_dictionary()
    sub_node_states["ammo"] = _ammo_pos.get_child(0).to_dictionary()
    sub_node_states["barrel"] = _barrel_pos.get_child(0).to_dictionary()

    return state

func from_dictionary(state: Dictionary) -> void:
    .from_dictionary(state)

    var sub_node_states: Dictionary = state[SUB_NODE_STATE_KEY]

    var stock_skin_node: Component = Global.create_instance(sub_node_states["stock"][RESOURCE_NAME_KEY])
    set_stock_skin(stock_skin_node)
    stock_skin_node.from_dictionary(sub_node_states["stock"])

    var trigger_skin_node: Component = Global.create_instance(sub_node_states["trigger"][RESOURCE_NAME_KEY])
    set_trigger_skin(trigger_skin_node)
    trigger_skin_node.from_dictionary(sub_node_states["trigger"])

    var ammo_skin_node: Component = Global.create_instance(sub_node_states["ammo"][RESOURCE_NAME_KEY])
    set_ammo_skin(ammo_skin_node)
    ammo_skin_node.from_dictionary(sub_node_states["ammo"])

    var barrel_skin_node: Component = Global.create_instance(sub_node_states["barrel"][RESOURCE_NAME_KEY])
    set_barrel_skin(barrel_skin_node)
    barrel_skin_node.from_dictionary(sub_node_states["barrel"])
        




