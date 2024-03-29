tool
class_name Controller
extends Node

export(bool) var enable_controller: bool = true

func _ready() -> void:
    if Engine.editor_hint:
        return 
        
    if enable_controller:
        call_deferred("enable_control")
    else:
        call_deferred("disable_control")



func enable_control() -> void:
    set_process(true)
    set_physics_process(true)

func disable_control() -> void:
    set_process(false)
    set_physics_process(false)

