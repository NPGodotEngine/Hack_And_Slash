@tool
class_name AIControllerComponent
extends Controller

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED



@export var actor: NodePath
@export var target_follower: NodePath

@onready var _target_follower: TargetFollowerComponent = get_node(target_follower) as TargetFollowerComponent
@onready var _actor: CharacterBody2D = get_node(actor) as CharacterBody2D


func _get_configuration_warnings() -> PackedStringArray:
	if not super._get_configuration_warnings().is_empty():
		return super._get_configuration_warnings()

	if target_follower.is_empty():
		return ["target_follower node path is missing"]
	if not get_node(target_follower) is TargetFollowerComponent:
		return ["target_follower must be a TargetFollowerComponent" ] 
	if actor.is_empty():
		return ["actor node path is missing"]
	if not get_node(actor) is CharacterBody2D:
		return ["actor must be a CharacterBody2D" ] 
	return []


func enable_control() -> void:
	super.enable_control()
	if _target_follower:
		_target_follower.enable_follow = true

func disable_control() -> void:
	super.disable_control()
	if _target_follower:
		_target_follower.enable_follow = false











