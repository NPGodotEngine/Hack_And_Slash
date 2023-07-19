@tool
class_name TargetFollowerComponent
extends Node

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED

@export var movement: NodePath
@export var actor: NodePath

@export var enable_follow: bool = false
@export var keep_distance: float = 100.0
@export var keep_dist_threshold: float = 1.0

# Once target is assigned, follow the target
# permanently until new target is assigned
##
# Target will never out of range
@export var permanent_target: bool = false

@onready var _movement: MovementComponent = get_node(movement) as MovementComponent
@onready var _actor: CharacterBody2D = get_node(actor) as CharacterBody2D

# The target this follower will move to
var target = null


func _get_configuration_warnings() -> PackedStringArray:
	if movement.is_empty():
		return ["movement node path is missing"]
	if not get_node(movement) is MovementComponent:
		return ["movement must be a MovementComponent" ]
	if actor.is_empty():
		return ["actor node path is missing"]
	if not get_node(actor) is CharacterBody2D:
		return ["actor must be a CharacterBody2D"]  
	return []

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
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
