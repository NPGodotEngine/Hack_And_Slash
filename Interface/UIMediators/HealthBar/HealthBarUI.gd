@tool
extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED

var _health_comp: HealthComponent = null

func _get_configuration_warnings() -> PackedStringArray:
    if not is_instance_of(get_parent(), HealthComponent):
        return ["This node must be child of HealthComponent node"]

    return []

func _ready() -> void:
    if Engine.is_editor_hint():
        return
    
    await get_parent().ready
    _health_comp = get_parent() as HealthComponent
    _health_comp.connect("health_updated", Callable(self, "_on_health_updated"))
    _health_comp.connect("max_health_updated", Callable(self, "_on_max_health_updated"))
    UIEvents.emit_signal("player_health_updated",
        _health_comp._health, _health_comp.max_health)

func _on_health_updated(health_context:HealthComponent.HealthContext) -> void:
    UIEvents.emit_signal("player_health_updated", 
        health_context.updated_health, health_context.max_health)

func _on_max_health_updated(max_health_context:HealthComponent.MaxHealthContext) -> void:
    UIEvents.emit_signal("player_health_updated", 
        _health_comp._health, max_health_context.updated_max_health)
