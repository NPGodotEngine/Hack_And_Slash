tool
extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED

export (NodePath) var healthComponent: NodePath

onready var _health_comp: HealthComponent = get_node(healthComponent) as HealthComponent

func _get_configuration_warning() -> String:
    if healthComponent.is_empty():
        return "healthComponent node path is missing"
    if not get_node(healthComponent) is HealthComponent:
        return "healthComponent must be HealthComponent"

    return ""

func _ready() -> void:
    _health_comp.connect("health_updated", self, "_on_health_updated")
    _health_comp.connect("max_health_updated", self, "_on_max_health_updated")
    UIEvents.emit_signal("player_health_updated",
        _health_comp._health, _health_comp.max_health)

func _on_health_updated(health_context:HealthComponent.HealthContext) -> void:
    UIEvents.emit_signal("player_health_updated", 
        health_context.updated_health, health_context.max_health)

func _on_max_health_updated(max_health_context:HealthComponent.MaxHealthContext) -> void:
    UIEvents.emit_signal("player_health_updated", 
        _health_comp._health, max_health_context.updated_max_health)
