@tool
extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT



@export var weapon: NodePath
@export var ammo: NodePath

@onready var _weapon: Weapon = get_node(weapon) as Weapon
@onready var _ammo: Ammo = get_node(ammo) as Ammo

func _get_configuration_warnings() -> PackedStringArray:
    if not super._get_configuration_warnings().is_empty():
        return super._get_configuration_warnings()

    if weapon.is_empty():
        return ["weapon node path is missing"]
    if not get_node(weapon) is Weapon:
        return ["weapon must be a type of Weapon"]
    if ammo.is_empty():
        return ["ammo node path is missing"]
    if not get_node(ammo) is Ammo:
        return ["ammo must be a type of Ammo"]

    return []

func _ready() -> void:
    _weapon.connect("weapon_active", Callable(self, "on_weapon_active"))
    _weapon.connect("weapon_inactive", Callable(self, "on_weapon_inactive"))
    _weapon.connect("weapon_attributes_updated", Callable(self, "on_weapon_attributes_updated"))
    _ammo.connect("ammo_count_updated", Callable(self, "_on_ammo_count_updated"))
    _ammo.connect("ammo_depleted", Callable(self, "_on_ammo_count_updated"))

    super._ready()

func on_weapon_active(_wp:Weapon) -> void:
    UIEvents.emit_signal("show_player_ammo_ui")
    update_ammo_ui(_ammo._round_left, _ammo.rounds_per_clip)

func on_weapon_inactive(_wp:Weapon) -> void:
    UIEvents.emit_signal("hide_player_ammo_ui")

func on_weapon_attributes_updated(_wp:Weapon) -> void:
    update_ammo_ui(_ammo._round_left, _ammo.rounds_per_clip)

func _on_ammo_count_updated(ammo_context:Ammo.AmmoContext) -> void:
    update_ammo_ui(ammo_context.updated_ammo_count, ammo_context.round_per_clip)

func update_ammo_ui(ammo_count:int, max_ammo_count:int) -> void:
    UIEvents.emit_signal("player_ammo_updated", ammo_count, max_ammo_count)