@tool
class_name FloatHealthBar
extends Marker2D

# warning-ignore-all: RETURN_VALUE_DISCARDED


@export var healthComponent: NodePath

@export var healthbar_scene: PackedScene
@export var healthbar_size: Vector2 = Vector2(1.0, 1.0)

@onready var _health_comp: HealthComponent = get_node_or_null(healthComponent)

# Health bar UI
# var healthbar:HealthBar
@onready var healthbar := $HealthBar

func _get_configuration_warnings() -> PackedStringArray:
	if healthComponent.is_empty():
		return ["healthComponent node path is missing"]
	if not get_node(healthComponent) is HealthComponent:
		return ["healthComponent must be a type of HealthComponent"]

	return []
	
func _ready() -> void:
	if Engine.is_editor_hint():
		return

	_health_comp.connect("health_updated", Callable(self, "_on_health_updated"))
	_health_comp.connect("max_health_updated", Callable(self, "_on_max_health_updated"))
	_health_comp.connect("die", Callable(self, "_on_die"))

	if not healthbar.is_inside_tree():
		await healthbar.ready
		configure_healthbar()
	else:
		configure_healthbar()

func _on_health_updated(health_context:HealthComponent.HealthContext) -> void:
	healthbar.health = health_context.updated_health

func _on_max_health_updated(max_health_context:HealthComponent.MaxHealthContext) -> void:
	healthbar.max_health = max_health_context.updated_max_health

func _on_die() -> void:
	healthbar.hide()

func configure_healthbar() -> void:
	healthbar.max_health = _health_comp.max_health
	healthbar.health = _health_comp._health

	# center health bar
	healthbar.position.x = -healthbar.health_bar_over.size.x / 2.0

