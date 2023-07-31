@tool
class_name AIControllerComponent
extends Controller

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED



@export var actor: NodePath

@onready var _actor: CharacterBody2D = get_node_or_null(actor)


func _get_configuration_warnings() -> PackedStringArray:
	if actor.is_empty():
		return ["actor node path is missing"]
	if not get_node(actor) is CharacterBody2D:
		return ["actor must be a CharacterBody2D"] 
	return []


func enable_control() -> void:
	super()

func disable_control() -> void:
	super()











