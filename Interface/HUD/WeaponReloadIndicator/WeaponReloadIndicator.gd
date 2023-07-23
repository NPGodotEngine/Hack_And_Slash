@tool
extends Node2D

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED


## NodePath to weapon
@export var weapon_ref: NodePath

## NodePath to ammo
@export var ammo_ref: NodePath

## PackedScene for relaod bar
@export var reload_indicator_scene: PackedScene

@onready var _weapon: Weapon = get_node_or_null(weapon_ref)
@onready var _ammo: Ammo = get_node_or_null(ammo_ref)

var _reload_indicator: ReloadIndicator = null

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	_reload_indicator = reload_indicator_scene.instantiate() as ReloadIndicator
	_reload_indicator.hide()

	UIEvents.emit_signal("add_weapon_reload_indicator", _reload_indicator)

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
	if reload_indicator_scene == null:
		return ["reload_indicator_scene is missing"]
	if not reload_indicator_scene.instantiate() is ReloadIndicator:
		return ["reload_indicator_scene must be a type of ReloadIndicator"]  

	return []

func _on_weapon_active(_target_weapon:Weapon) -> void:
	if _ammo._is_reloading:
		_reload_indicator.animate_show()

func on_weapon_inactive(_target_weapon:Weapon) -> void:
	_reload_indicator.hide()

func _on_begin_reloading(_ammo_context) -> void:
	_reload_indicator.animate_show()

func _on_end_reloading(_ammo_context) -> void:
	_reload_indicator.update_reload_progress(1.0, 1.0)
	_reload_indicator.animate_hide()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if _ammo._is_reloading:
		var progress: Ammo.AmmoReloadProgress = _ammo.progress
		_reload_indicator.update_reload_progress(progress.progress, progress.max_progress)

func _exit_tree():
	if _reload_indicator.get_parent():
		_reload_indicator.get_parent().remove_child(_reload_indicator)
		_reload_indicator.queue_free()
