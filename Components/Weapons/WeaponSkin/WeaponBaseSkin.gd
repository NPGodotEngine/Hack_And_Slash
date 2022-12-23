class_name WeaponBaseSkin
extends Component

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED

onready var _stock_pos: Position2D = $StockPos
onready var _trigger_pos: Position2D = $TriggerPos
onready var _ammo_pos: Position2D = $AmmoPos
onready var _barrel_pos: Position2D = $BarrelPos

var stock_skin setget set_stock_skin, get_stock_skin
var trigger_skin setget set_trigger_skin, get_trigger_skin
var ammo_skin setget set_ammo_skin, get_ammo_skin
var barrel_skin setget set_barrel_skin, get_barrel_skin

func get_stock_skin():
    return _stock_pos.get_child(0)

func get_trigger_skin():
    return _trigger_pos.get_child(0)

func get_ammo_skin():
    return _ammo_pos.get_child(0)

func get_barrel_skin():
    return _barrel_pos.get_child(0)

func set_stock_skin(stock:Node2D) -> void:
    for node in _stock_pos.get_children():
        remove_child(node)
    _stock_pos.add_child(stock)

func set_trigger_skin(trigger:Node2D) -> void:
    for node in _trigger_pos.get_children():
        remove_child(node)
    _trigger_pos.add_child(trigger)

func set_ammo_skin(ammo:Node2D) -> void:
    for node in _ammo_pos.get_children():
        remove_child(node)
    _ammo_pos.add_child(ammo)

func set_barrel_skin(barrel:Node2D) -> void:
    for node in _barrel_pos.get_children():
        remove_child(node)
    _barrel_pos.add_child(barrel)

func get_component_state(ignore_private: bool = true, property_prefix: String = "_") -> Dictionary:
    var skin_state: Dictionary = .get_component_state()
    skin_state.erase("stock_skin")
    skin_state.erase("trigger_skin")
    skin_state.erase("ammo_skin")
    skin_state.erase("barrel_skin")

    var attachements_state = {}
    attachements_state["Stock"] = _stock_pos.get_children()[0].get_component_state()
    attachements_state["Trigger"] = _trigger_pos.get_children()[0].get_component_state()
    attachements_state["Ammo"] = _ammo_pos.get_children()[0].get_component_state()
    attachements_state["Barrel"] = _barrel_pos.get_children()[0].get_component_state()

    skin_state["attachments"] = attachements_state

    return skin_state

func apply_component_state(state: Dictionary) -> void:
    .apply_component_state(state)
    var attachement_state = state["attachements"]

    var stock_name = attachement_state["Stock"]["name"] + ".tscn"
    var stock_skin_node = load(Global.find_file_in_directory(stock_name)).instance()
    set_stock_skin(stock_skin_node)

    var trigger_name = attachement_state["Trigger"]["name"] + ".tscn"
    var trigger_skin_node = load(Global.find_file_in_directory(trigger_name)).instance()
    set_trigger_skin(trigger_skin_node)

    var ammo_name = attachement_state["Ammo"]["name"] + ".tscn"
    var ammo_skin_node = load(Global.find_file_in_directory(ammo_name)).instance()
    set_ammo_skin(ammo_skin_node)

    var barrel_name = attachement_state["Barrel"]["name"] + ".tscn"
    var barrel_skin_node = load(Global.find_file_in_directory(barrel_name)).instance()
    set_barrel_skin(barrel_skin_node)
        




