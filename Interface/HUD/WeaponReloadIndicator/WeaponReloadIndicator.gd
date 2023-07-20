@tool
extends Node

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED


@export var weapon_ref: NodePath
@export var ammo_ref: NodePath
@export var reloadbar_scene: PackedScene

@onready var _weapon: Weapon = get_node(weapon_ref) as Weapon
@onready var _ammo: Ammo = get_node(ammo_ref) as Ammo

var _reloadbar: Node2D

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	_reloadbar = reloadbar_scene.instantiate() as Node2D
	_reloadbar.hide()

	UIEvents.emit_signal("add_weapon_reload_indicator", _reloadbar)

	_weapon.connect("weapon_active", Callable(self, "_on_weapon_active"))
	_weapon.connect("weapon_inactive", Callable(self, "on_weapon_inactive"))

	_ammo.connect("begin_reloading", Callable(self, "_on_begin_reloading"))
	_ammo.connect("end_reloading", Callable(self, "_on_end_reloading"))

func _get_configuration_warnings() -> PackedStringArray:
	if weapon_ref.is_empty():
		return ["weapon node path is missing"]
	if not get_node(weapon_ref) is Weapon:
		return ["weapon must be a type of Weapon"]
	if ammo_ref.is_empty():
		return ["ammo node path is missing"]
	if not get_node(ammo_ref) is Ammo:
		return ["ammo must be a type of Ammo"]
	if reloadbar_scene == null:
		return ["reloadbar_scene is missing"]
	if not reloadbar_scene.instantiate() is Node2D:
		return ["reloadbar_scene must be a type of Node2D"]  

	return []

func _on_weapon_active(_target_weapon:Weapon) -> void:
	if _ammo._is_reloading:
		_reloadbar.show()

func on_weapon_inactive(_target_weapon:Weapon) -> void:
	_reloadbar.hide()   

func _on_begin_reloading(_ammo_context) -> void:
	_reloadbar.show()

func _on_end_reloading(_ammo_context) -> void:
	var circular_bar:CircularFillBar = _reloadbar.get_child(0) as CircularFillBar
	circular_bar.update_progress(1.0, 1.0)
	_reloadbar.hide()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if _reloadbar:
		_reloadbar.global_position = _reloadbar.get_global_mouse_position()

	if _ammo._is_reloading:
		var progress: Ammo.AmmoReloadProgress = _ammo.progress
		var circular_bar:CircularFillBar = _reloadbar.get_child(0) as CircularFillBar
		circular_bar.update_progress(progress.progress, progress.max_progress)

# func queue_free() -> void:
#     if _reloadbar:
#         _reloadbar.queue_free()

#         if _reloadbar.get_parent():
#             _reloadbar.get_parent().remove_child(_reloadbar)
	
#     super.queue_free()
