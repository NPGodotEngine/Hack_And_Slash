tool
extends Node

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED


export (NodePath) var weapon: NodePath
export (NodePath) var ammo: NodePath
export (PackedScene) var reloadbar_scene: PackedScene

onready var _weapon: Weapon = get_node(weapon) as Weapon
onready var _ammo: Ammo = get_node(ammo) as Ammo

var _reloadbar: Node2D

func _ready() -> void:
    _reloadbar = reloadbar_scene.instance() as Node2D
    _reloadbar.hide()

    UIEvents.emit_signal("add_weapon_reload_indicator", _reloadbar)

    _weapon.connect("weapon_active", self, "_on_weapon_active")
    _weapon.connect("weapon_inactive", self, "on_weapon_inactive")

    _ammo.connect("begin_reloading", self, "_on_begin_reloading")
    _ammo.connect("end_reloading", self, "_on_end_reloading")

func _get_configuration_warning() -> String:
    if weapon.is_empty():
        return "weapon node path is missing"
    if not get_node(weapon) is Weapon:
        return "weapon must be a type of Weapon"
    if ammo.is_empty():
        return "ammo node path is missing"
    if not get_node(ammo) is Ammo:
        return "ammo must be a type of Ammo"
    if reloadbar_scene == null:
        return "reloadbar_scene is missing"
    if not reloadbar_scene.instance() is Node2D:
        return "reloadbar_scene must be a type of Node2D"  

    return "" 

func _on_weapon_active(target_weapon:Weapon) -> void:
    if _ammo._is_reloading:
        _reloadbar.show()

func on_weapon_inactive(target_weapon:Weapon) -> void:
    _reloadbar.hide()   

func _on_begin_reloading(ammo_context) -> void:
    _reloadbar.show()

func _on_end_reloading(ammo_context) -> void:
    var circular_bar:CircularFillBar = _reloadbar.get_child(0) as CircularFillBar
    circular_bar.update_progress(1.0, 1.0)
    _reloadbar.hide()

func _process(delta: float) -> void:
    if Engine.editor_hint:
        return

    if _reloadbar:
        _reloadbar.global_position = _reloadbar.get_global_mouse_position()

    if _ammo._is_reloading:
        var progress: Ammo.AmmoReloadProgress = _ammo.progress
        var circular_bar:CircularFillBar = _reloadbar.get_child(0) as CircularFillBar
        circular_bar.update_progress(progress.progress, progress.max_progress)

func queue_free() -> void:
    if _reloadbar:
        _reloadbar.queue_free()

        if _reloadbar.get_parent():
            _reloadbar.get_parent().remove_child(_reloadbar)
    
    .queue_free()