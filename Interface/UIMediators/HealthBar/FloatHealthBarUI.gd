tool
class_name FloatHealthBar
extends Position2D

# warning-ignore-all: RETURN_VALUE_DISCARDED


export (NodePath) var healthComponent: NodePath

export (PackedScene) var healthbar_scene: PackedScene
export (Vector2) var healthbar_size: Vector2 = Vector2(1.0, 1.0)

onready var _health_comp: HealthComponent = get_node(healthComponent) as HealthComponent

# Health bar UI
var healthbar:HealthBar

# A position 2d whose global position will 
# be updated by this component with healthbar 
# ui attached as child
var _pos: Position2D

func _get_configuration_warning() -> String:
	if healthComponent.is_empty():
		return "healthComponent node path is missing"
	if not get_node(healthComponent) is HealthComponent:
		return "healthComponent must be a type of HealthComponent"

	return ""

func _init() -> void:
	_pos = Position2D.new()
	
func _ready() -> void:
	healthbar = healthbar_scene.instance() as HealthBar

	# add to ui
	_pos.add_child(healthbar)
	_pos.scale = healthbar_size
	UIEvents.emit_signal("add_float_health_bar_ui", _pos)

	_health_comp.connect("health_updated", self, "_on_health_updated")
	_health_comp.connect("max_health_updated", self, "_on_max_health_updated")
	_health_comp.connect("die", self, "_on_die")

	if not healthbar.is_inside_tree():
		yield(healthbar, "ready")
		configure_healthbar()
	else:
		configure_healthbar()

func _on_health_updated(health_context:HealthComponent.HealthContext) -> void:
	healthbar.health = health_context.updated_health

func _on_max_health_updated(max_health_context:HealthComponent.MaxHealthContext) -> void:
	healthbar.max_health = max_health_context.updated_max_health

func _on_die() -> void:
	_pos.hide()
	
func _process(_delta: float) -> void:
	if Engine.editor_hint:
		return

	_pos.global_position = get_global_transform_with_canvas().origin

func queue_free() -> void:
	if _pos.get_parent():
		_pos.get_parent().remove_child(_pos)
		_pos.queue_free()
	.queue_free()

func configure_healthbar() -> void:
	healthbar.max_health = _health_comp.max_health
	healthbar.health = _health_comp._health

	# center health bar
	healthbar.rect_position.x = -healthbar.health_bar_over.rect_size.x / 2.0

