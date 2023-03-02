tool
extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED

export (NodePath) var weaponManager: NodePath

onready var weapon_mgr: WeaponManager = get_node(weaponManager) as WeaponManager

func _get_configuration_warning() -> String:
    if weaponManager.is_empty():
        return "weaponManager node path is missing"
    if not get_node(weaponManager) is WeaponManager:
        return "weaponManager must be WeaponManager"

    return ""

func _ready() -> void:
    weapon_mgr.connect("switch_weapon", self, "_on_switch_weapon")

func _on_switch_weapon(switch_context:WeaponManager.SwitchWeaponContext) -> void:
    var weapon: Weapon = weapon_mgr.get_weapon_by(switch_context.current_weapon_index)

    for node in weapon.get_children():
        if node is Ammo:
            var ammo: Ammo = node as Ammo
            ammo.connect("ammo_count_updated", self, "_on_ammo_count_updated")
            ammo.connect("ammo_depleted", self, "_on_ammo_count_updated")
            UIEvents.emit_signal("player_ammo_updated", 
                ammo._round_left, ammo.rounds_per_clip)
            break

func _on_ammo_count_updated(ammo_context:Ammo.AmmoContext) -> void:
    UIEvents.emit_signal("player_ammo_updated", 
        ammo_context.updated_ammo_count, ammo_context.round_per_clip)