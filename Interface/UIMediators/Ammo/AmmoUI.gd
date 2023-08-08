@tool
extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT


## NodePath to weapon
@export var weapon_ref: NodePath

## NodePath to ammo
@export var ammo_ref: NodePath

@onready var _weapon: Weapon = get_node_or_null(weapon_ref)
@onready var _ammo: Ammo = get_node_or_null(ammo_ref)

func _get_configuration_warnings() -> PackedStringArray:
	if weapon_ref.is_empty():
		return ["weapon node path is missing"]
	if not get_node(weapon_ref) is Weapon:
		return ["weapon must be a type of Weapon"]
	if ammo_ref.is_empty():
		return ["ammo node path is missing"]
	if not get_node(ammo_ref) is Ammo:
		return ["ammo must be a type of Ammo"]

	return []

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	_weapon.connect("weapon_active", Callable(self, "on_weapon_active"))
	_weapon.connect("weapon_inactive", Callable(self, "on_weapon_inactive"))
	_weapon.connect("weapon_attributes_updated", Callable(self, "on_weapon_attributes_updated"))
	_ammo.connect("ammo_count_updated", Callable(self, "_on_ammo_count_updated"))
	_ammo.connect("ammo_depleted", Callable(self, "_on_ammo_count_updated"))
	_ammo.connect("ammo_bag_updated", Callable(self, "_on_ammo_bag_count_updated"))
	_ammo.connect("ammo_bag_depleted", Callable(self, "_on_ammo_bag_count_updated"))

func on_weapon_active(_wp:Weapon) -> void:
	UIEvents.emit_signal("show_player_ammo_ui")
	update_ammo_bag_ui(_ammo._round_in_ammo_bag)
	update_ammo_ui(_ammo._round_left)

func on_weapon_inactive(_wp:Weapon) -> void:
	UIEvents.emit_signal("hide_player_ammo_ui")

func on_weapon_attributes_updated(_wp:Weapon) -> void:
	update_ammo_bag_ui(_ammo._round_in_ammo_bag)
	update_ammo_ui(_ammo._round_left)

func _on_ammo_count_updated(ammo_context:Ammo.AmmoContext) -> void:
	update_ammo_ui(ammo_context.updated_ammo_count)

func _on_ammo_bag_count_updated(ammo_bag_context:Ammo.AmmoBagContext) -> void:
	update_ammo_bag_ui(ammo_bag_context.updated_ammo_bag_count)

func update_ammo_ui(ammo_count:int) -> void:
	UIEvents.emit_signal("player_ammo_updated", ammo_count)

func update_ammo_bag_ui(ammo_count:int) -> void:
	UIEvents.emit_signal("player_ammo_bag_update", ammo_count)
