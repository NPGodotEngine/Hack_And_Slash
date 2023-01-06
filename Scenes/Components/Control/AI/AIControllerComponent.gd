tool
class_name AIControllerComponent
extends Controller

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED



export(NodePath) var actor: NodePath
export(NodePath) var target_follower: NodePath

onready var _target_follower: TargetFollowerComponent = get_node(target_follower) as TargetFollowerComponent
onready var _actor: KinematicBody2D = get_node(actor) as KinematicBody2D


func _get_configuration_warning() -> String:
	if target_follower.is_empty():
		return "target_follower node path is missing"
	if not get_node(target_follower) is TargetFollowerComponent:
		return "target_follower must be a TargetFollowerComponent"  
	if actor.is_empty():
		return "actor node path is missing"
	if not get_node(actor) is KinematicBody2D:
		return "actor must be a KinematicBody2D"  
	return ""


func enable_control() -> void:
	.enable_control()
	if _target_follower:
		_target_follower.enable_follow = true

func disable_control() -> void:
	.disable_control()
	if _target_follower:
		_target_follower.enable_follow = false











