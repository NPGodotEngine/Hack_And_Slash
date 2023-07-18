@tool
extends Node2D

@export var distance: float = 100.0
@export var target_detector: NodePath

@onready var _target_detector: TargetDetector = get_node(target_detector) as TargetDetector
@onready var raycast: RayCast2D = $RayCast2D

var target = null
var is_target_in_sight: bool = false

func _get_configuration_warnings() -> PackedStringArray:
    if not super._get_configuration_warnings().is_empty():
        return super._get_configuration_warnings()

    if target_detector.is_empty():
        return ["target_detector node path is missing"]
    if not get_node(target_detector) is TargetDetector:
        return ["target_detector must be a TargetDetector"]
    return []

func _ready() -> void:
    if Engine.is_editor_hint():
        return

    _target_detector.connect("target_detected", Callable(self, "_on_target_detected"))
    _target_detector.connect("target_lost", Callable(self, "_on_target_lost"))

    super._ready()

func _on_target_detected(detected_context:TargetDetector.DetectedContext) -> void:
    raycast.enabled = true
    if target == null:
        target = detected_context.detected_target

func _on_target_lost(_target_lost_context:TargetDetector.TargetLostContext) -> void:
    raycast.enabled = false
    if target:
        target = null
    is_target_in_sight = false

func _physics_process(delta: float) -> void:
    super._physics_process(delta)
    
    if target != null and raycast.enabled:
        # update raycast
        var target_dir: Vector2 = global_position.direction_to(target.global_position)
        var target_position: Vector2 = target_dir * distance
        raycast.target_position = target_position
        raycast.force_raycast_update()

        # check if target is in sight
        if raycast.is_colliding() and raycast.get_collider() == target:
            is_target_in_sight = true
        else:
            is_target_in_sight = false
    
