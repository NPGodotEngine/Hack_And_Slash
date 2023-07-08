tool
extends Position2D

# warning-ignore-all: RETURN_VALUE_DISCARDED


export (NodePath) var character: NodePath
export (PackedScene) var damage_text: PackedScene

onready var _character: Character = get_node(character) as Character


func _get_configuration_warning() -> String:
	if damage_text == null:
		return "damage text PackedScene is missing"
	
	if character.is_empty():
		return "character node path is missing"
	if not get_node(character) is Character:
		return "character must be a type of Character"
	
	return ""

func _ready() -> void:
	if _character != null:
		_character.connect("on_character_take_damage", self, "on_take_damage")

func on_take_damage(hit_damage, total_damage) -> void:
	if damage_text == null: return
	
	var damage_text_ui: Node2D = damage_text.instance() as Node2D
	damage_text_ui.global_position = get_global_transform_with_canvas().origin

	UIEvents.emit_signal("display_damage_text", hit_damage, total_damage, damage_text_ui)

