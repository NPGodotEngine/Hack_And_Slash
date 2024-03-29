class_name HPState
extends HBoxContainer

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT


onready var healthbar: HealthBar = $HealthBar

func _ready() -> void:
	UIEvents.connect("player_health_updated", self, "_on_player_health_updated")

func _on_player_health_updated(health, max_health) -> void:
	healthbar.health = health
	healthbar.max_health = max_health
