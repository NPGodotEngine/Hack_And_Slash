@tool
extends Marker2D

# warning-ignore-all: RETURN_VALUE_DISCARDED


## PackedScene for damage text
@export var damage_text: PackedScene

var _character: Character = null


func _get_configuration_warnings() -> PackedStringArray:
	if damage_text == null:
		return ["damage text PackedScene is missing"]
	
	if not is_instance_of(get_parent(), Character):
		return ["This node must be a child of Character node"]
	
	return []

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	await get_parent().ready
	_character = get_parent() as Character	
	if _character != null:
		_character.connect("on_character_take_damage", Callable(self, "on_take_damage"))

func on_take_damage(hit_damage, total_damage) -> void:
	if damage_text == null: return
	
	var damage_text_ui: Node2D = damage_text.instantiate() as Node2D
	damage_text_ui.global_position = get_global_transform_with_canvas().origin

	UIEvents.emit_signal("display_damage_text", hit_damage, total_damage, damage_text_ui)

