@tool
extends Node

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED


@export var weapon: NodePath
@export var ammo: NodePath
@export var crosshair_scene: PackedScene

@onready var _weapon: Weapon = get_node(weapon) as Weapon
@onready var _ammo:Ammo = get_node(ammo) as Ammo

var _crosshair: Node2D


func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	_crosshair = crosshair_scene.instantiate() as Node2D
	_crosshair.hide()

	UIEvents.emit_signal("add_weapon_crosshair", _crosshair)

	_weapon.connect("weapon_active", Callable(self, "_on_weapon_active"))
	_weapon.connect("weapon_inactive", Callable(self, "on_weapon_inactive"))

	_ammo.connect("begin_reloading", Callable(self, "_on_begin_reloading"))
	_ammo.connect("end_reloading", Callable(self, "_on_end_reloading"))

	await get_tree().process_frame
	_crosshair.show()

func _get_configuration_warnings() -> PackedStringArray:
	if weapon.is_empty():
		return ["weapon node path is missing"]
	if not get_node(weapon) is Weapon:
		return ["weapon must be a type of Weapon"]
	if ammo.is_empty():
		return ["ammo node path is missing"]
	if not get_node(ammo) is Ammo:
		return ["ammo must be a type of Ammo"]
	if crosshair_scene == null:
		return ["crosshair_scene is missing"]
	if not crosshair_scene.instantiate() is Node2D:
		return ["crosshair_scene must be a type of Node2D" ]

	return []

func _on_weapon_active(_target_weapon:Weapon) -> void:
	_crosshair.show()

func on_weapon_inactive(_target_weapon:Weapon) -> void:
	_crosshair.hide()   

func _on_begin_reloading(_ammo_context) -> void:
	_crosshair.hide()

func _on_end_reloading(_ammo_context) -> void:
	_crosshair.show()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if _crosshair:
		_crosshair.global_position = _crosshair.get_global_mouse_position()

# func queue_free() -> void:
#     if _crosshair:
#         _crosshair.queue_free()

#         if _crosshair.get_parent():
#             _crosshair.get_parent().remove_child(_crosshair)
	
#     super.queue_free()


