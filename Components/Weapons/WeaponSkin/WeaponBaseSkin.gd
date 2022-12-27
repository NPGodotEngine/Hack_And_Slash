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
    var skin_state: Dictionary = .to_dictionary()

    var attachements_state = {}
    attachements_state["Stock"] = _stock_pos.get_child(0).to_dictionary()
    attachements_state["Trigger"] = _trigger_pos.get_child(0).to_dictionary()
    attachements_state["Ammo"] = _ammo_pos.get_child(0).to_dictionary()
    attachements_state["Barrel"] = _barrel_pos.get_child(0).to_dictionary()

    skin_state["attachments"] = attachements_state

    return skin_state

func from_dictionary(state: Dictionary) -> void:
    .from_dictionary(state)
    var attachement_state = state["attachments"]

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
        




