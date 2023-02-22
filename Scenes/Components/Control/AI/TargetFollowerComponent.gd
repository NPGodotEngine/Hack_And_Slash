tool
class_name TargetFollowerComponent
extends Node

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED

export(NodePath) var movement: NodePath
export(NodePath) var target_detector: NodePath
export(NodePath) var actor: NodePath

export (bool) var enable_follow: bool = false
export (float) var keep_distance: float = 100.0
export(float) var keep_dist_threshold: float = 1.0

onready var _movement: MovementComponent = get_node(movement) as MovementComponent
onready var _target_detector: TargetDetector = get_node(target_detector) as TargetDetector
onready var _actor: KinematicBody2D = get_node(actor) as KinematicBody2D

var _target = null


func _get_configuration_warning() -> String:
	if movement.is_empty():
		return "movement node path is missing"
	if not get_node(movement) is MovementComponent:
		return "movement must be a MovementComponent" 
	if target_detector.is_empty():
		return "target_detector node path is missing"
	if not get_node(target_detector) is TargetDetector:
		return "target_detector must be a TargetDetector"
	if actor.is_empty():
		return "actor node path is missing"
	if not get_node(actor) is KinematicBody2D:
		return "actor must be a KinematicBody2D"  
	return ""

func _ready() -> void:
	if Engine.editor_hint:
		return

	_target_detector.connect("target_detected", self, "_on_target_detected")
	_target_detector.connect("target_lost", self, "_on_target_lost")

func _physics_process(delta: float) -> void:
	if Engine.editor_hint:
		return

	if enable_follow:
		move_close_to_target()

func _on_target_detected(detected_context:TargetDetector.DetectedContext) -> void:
	if _target == null:
		_target = detected_context.detected_target

func _on_target_lost(target_lost_context:TargetDetector.TargetLostContext) -> void:
	if _target:
		_target = null



func move_close_to_target():
	if _target == null or _movement == null or _actor == null: 
		return

	var direction: Vector2 = _target.global_position - _actor.global_position
	var dist_to_target: float = _actor.global_position.distance_to(_target.global_position)

	if (is_equal_approx(keep_dist_threshold, abs(dist_to_target - keep_distance)) or 
		abs(dist_to_target - keep_distance) < keep_dist_threshold):
		return

	direction *= sign(dist_to_target - keep_distance)
	_movement.process_move(direction)
