@tool
extends Node2D

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED

## NodePath to weapon
@export var weapon_ref: NodePath

## NodePath to ammo
@export var ammo_ref: NodePath

## PackedScene for crosshair
@export var crosshair_scene: PackedScene

@onready var _weapon: Weapon = get_node_or_null(weapon_ref)
@onready var _ammo:Ammo = get_node_or_null(ammo_ref)

var _crosshair: Control


func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	_crosshair = crosshair_scene.instantiate() as Control
	_crosshair.hide()

	UIEvents.emit_signal("add_weapon_crosshair", _crosshair)

	_weapon.connect("weapon_active", Callable(self, "_on_weapon_active"))
	_weapon.connect("weapon_inactive", Callable(self, "on_weapon_inactive"))

	_ammo.connect("begin_reloading", Callable(self, "_on_begin_reloading"))
	_ammo.connect("end_reloading", Callable(self, "_on_end_reloading"))

	# await get_tree().process_frame
	# _crosshair.show()

func _get_configuration_warnings() -> PackedStringArray:
	if weapon_ref.is_empty():
		return ["weapon node path is missing"]
	if not get_node(weapon_ref) is Weapon:
		return ["weapon must be a type of Weapon"]
	if ammo_ref.is_empty():
		return ["ammo node path is missing"]
	if not get_node(ammo_ref) is Ammo:
		return ["ammo must be a type of Ammo"]
	if crosshair_scene == null:
		return ["crosshair_scene is missing"]
	if not crosshair_scene.instantiate() is Control:
		return ["crosshair_scene must be a type of Control" ]

	return []

func _on_weapon_active(_target_weapon:Weapon) -> void:
	_crosshair.show()

func on_weapon_inactive(_target_weapon:Weapon) -> void:
	_crosshair.hide()   

func _on_begin_reloading() -> void:
	_crosshair.hide()

func _on_end_reloading() -> void:
	_crosshair.show()

func _exit_tree() -> void:
	if _crosshair:
		_crosshair.queue_free()

		if _crosshair.get_parent():
			_crosshair.get_parent().remove_child(_crosshair)


