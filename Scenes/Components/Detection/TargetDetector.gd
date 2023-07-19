class_name TargetDetector
extends Area2D

# warning-ignore-all: RETURN_VALUE_DISCARDED

class DetectedContext extends Resource:
    var detected_target = null

class TargetLostContext extends Resource:
    var lost_target = null

# Emit when target detected
##
# `detected_context`: class `DetectedContext`
signal target_detected(detected_context)

# Emit when target out of detection area
##
# `target_lost_context`: class `TargetLostContext`
signal target_lost(target_lost_context)


# `true` to detect KinematicBody2D
@export var detect_kinematic_body2d: bool = true: set = set_detect_kinematic_body2d

# `true` to detect Aread2D
@export var detect_area2d: bool = false: set = set_detect_area2d

func set_detect_kinematic_body2d(value:bool) -> void:
    detect_kinematic_body2d = value

    if detect_kinematic_body2d == true:
        if not is_connected("body_entered", Callable(self, "_on_body_entered")):
            connect("body_entered", Callable(self, "_on_body_entered"))
        if not is_connected("body_exited", Callable(self, "_on_body_exited")):
            connect("body_exited", Callable(self, "_on_body_exited"))
    else:
        if is_connected("body_entered", Callable(self, "_on_body_entered")):
            disconnect("body_entered", Callable(self, "_on_body_entered"))
        if is_connected("body_exited", Callable(self, "_on_body_exited")):
            disconnect("body_exited", Callable(self, "_on_body_exited"))

func set_detect_area2d(value:bool) -> void:
    detect_area2d = value

    if detect_area2d == true:
        if not is_connected("area_entered", Callable(self, "_on_area_entered")):
            connect("area_entered", Callable(self, "_on_area_entered"))
        if not is_connected("area_exited", Callable(self, "_on_area_exited")):
            connect("area_exited", Callable(self, "_on_area_exited"))
    else:
        if is_connected("area_entered", Callable(self, "_on_area_entered")):
            disconnect("area_entered", Callable(self, "_on_area_entered"))
        if is_connected("area_exited", Callable(self, "_on_area_exited")):
            disconnect("area_exited", Callable(self, "_on_area_exited"))



func _ready() -> void:
    collision_layer = 0
    set_detect_kinematic_body2d(detect_kinematic_body2d)
    set_detect_area2d(detect_area2d)

    
func _on_body_entered(body:Node) -> void:
    var detected_context: DetectedContext = DetectedContext.new()

    if detect_kinematic_body2d and body is CharacterBody2D:
        detected_context.detected_target = body as CharacterBody2D
    else:
        detected_context.detected_target = body

    emit_signal("target_detected", detected_context)

func _on_body_exited(body:Node) -> void:
    var target_lost_context: TargetLostContext = TargetLostContext.new()

    if detect_kinematic_body2d and body is CharacterBody2D:
        target_lost_context.lost_target = body as CharacterBody2D
    else:
        target_lost_context.lost_target = body

    emit_signal("target_lost", target_lost_context)

func _on_area_entered(area2d:Area2D) -> void:
    var detected_context: DetectedContext = DetectedContext.new()
    detected_context.detected_target = area2d
    emit_signal("target_detected", detected_context)

func _on_area_exited(area2d:Area2D) -> void:
    var target_lost_context: TargetLostContext = TargetLostContext.new()
    target_lost_context.lost_target = area2d
    emit_signal("target_lost", target_lost_context)


# Add a new mask for detection
func add_detecting_mask(new_mask:int) -> void:
    collision_mask |= new_mask

# Remove a mask from detection
func remove_detecting_mask(mask:int) -> void:
    collision_mask ^= mask

