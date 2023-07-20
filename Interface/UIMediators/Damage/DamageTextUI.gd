@tool
extends Marker2D

# warning-ignore-all: RETURN_VALUE_DISCARDED


@export var character: NodePath
@export var damage_text: PackedScene

@onready var _character: Character = get_node_or_null(character)


func _get_configuration_warnings() -> PackedStringArray:
	if damage_text == null:
		return ["damage text PackedScene is missing"]
	
	if character.is_empty():
		return ["character node path is missing"]
	if not get_node(character) is Character:
		return ["character must be a type of Character"]
	
	return []

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	if _character != null:
		_character.connect("on_character_take_damage", Callable(self, "on_take_damage"))

func on_take_damage(hit_damage, total_damage) -> void:
	if damage_text == null: return
	
	var damage_text_ui: Node2D = damage_text.instantiate() as Node2D
	damage_text_ui.global_position = get_global_transform_with_canvas().origin

	UIEvents.emit_signal("display_damage_text", hit_damage, total_damage, damage_text_ui)

