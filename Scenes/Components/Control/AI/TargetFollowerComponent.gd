tool
class_name TargetFollowerComponent
extends Node

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED

export(NodePath) var movement: NodePath
export(NodePath) var actor: NodePath

export (bool) var enable_follow: bool = false
export (float) var keep_distance: float = 100.0
export (float) var keep_dist_threshold: float = 1.0

# Once target is assigned, follow the target
# permanently until new target is assigned
##
# Target will never out of range
export (bool) var permanent_target: bool = false

onready var _movement: MovementComponent = get_node(movement) as MovementComponent
onready var _actor: KinematicBody2D = get_node(actor) as KinematicBody2D

# The target this follower will move to
var target = null


func _get_configuration_warning() -> String:
	if movement.is_empty():
		return "movement node path is missing"
	if not get_node(movement) is MovementComponent:
		return "movement must be a MovementComponent" 
	if actor.is_empty():
		return "actor node path is missing"
	if not get_node(actor) is KinematicBody2D:
		return "actor must be a KinematicBody2D"  
	return ""

func _ready() -> void:
	if Engine.editor_hint:
		return

func _physics_process(delta: float) -> void:
	if Engine.editor_hint:
		return

	if enable_follow:
		move_close_to_target()

func move_close_to_target():
	if target == null or _movement == null or _actor == null: 
		return

	var direction: Vector2 = target.global_position - _actor.global_position
	var dist_to_target: float = _actor.global_position.distance_to(target.global_position)

	if (is_equal_approx(keep_dist_threshold, abs(dist_to_target - keep_distance)) or 
		abs(dist_to_target - keep_distance) < keep_dist_threshold):
		return

	direction *= sign(dist_to_target - keep_distance)
	_movement.process_move(direction)
