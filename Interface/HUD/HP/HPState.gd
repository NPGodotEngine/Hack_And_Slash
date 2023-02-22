class_name HPState
extends HBoxContainer

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT


onready var healthbar: HealthBar = $HealthBar

var health_component: HealthComponent setget set_health_component

func set_health_component(comp:HealthComponent) -> void:
	if comp.is_connected("health_updated", self, "_on_health_updated"):
		comp.disconnect("health_updated", self, "_on_health_updated")
	if comp.is_connected("max_health_updated", self, "_on_max_health_updated"):
		comp.disconnect("max_health_updated", self, "_on_max_health_updated")
	if comp.is_connected("low_health_alert", self, "_on_low_health"):
		comp.disconnect("low_health_alert", self, "_on_low_health")
	if comp.is_connected("die", self, "_on_die"):
		comp.disconnect("die", self, "_on_die")

	comp.connect("health_updated", self, "_on_health_updated")
	comp.connect("max_health_updated", self, "_on_max_health_updated")
	comp.connect("low_health_alert", self, "_on_low_health")
	comp.connect("die", self, "_on_die")

	healthbar.health = comp._health
	healthbar.max_health = comp.max_health

func _on_health_updated(health_context:HealthComponent.HealthContext) -> void:
	healthbar.health = health_context.updated_health

func _on_max_health_updated(max_health_context:HealthComponent.MaxHealthContext) -> void:
	healthbar.max_health = max_health_context.updated_max_health

func _on_low_health(health_context:HealthComponent.HealthContext) -> void:
	pass

func _on_die() -> void:
	healthbar.health = 0.0
