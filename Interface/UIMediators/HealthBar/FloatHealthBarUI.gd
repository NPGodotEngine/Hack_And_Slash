@tool
class_name FloatHealthBar
extends Marker2D

# warning-ignore-all: RETURN_VALUE_DISCARDED


@export var healthComponent: NodePath

@export var healthbar_scene: PackedScene
@export var healthbar_size: Vector2 = Vector2(1.0, 1.0)

@onready var _health_comp: HealthComponent = get_node(healthComponent) as HealthComponent

# Health bar UI
var healthbar:HealthBar

# A position 2d whose global position will 
# be updated by this component with healthbar 
# ui attached as child
var _pos: Node2D

func _get_configuration_warnings() -> PackedStringArray:
	if healthComponent.is_empty():
		return ["healthComponent node path is missing"]
	if not get_node(healthComponent) is HealthComponent:
		return ["healthComponent must be a type of HealthComponent"]

	return []

func _init() -> void:
	super()

	_pos = Node2D.new()
	
func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	healthbar = healthbar_scene.instantiate() as HealthBar

	# add to ui
	_pos.add_child(healthbar)
	_pos.scale = healthbar_size
	UIEvents.emit_signal("add_float_health_bar_ui", _pos)

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
	_pos.hide()
	
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	_pos.global_position = get_global_transform_with_canvas().origin

func _exit_tree() -> void:
	if _pos.get_parent():
		_pos.get_parent().remove_child(_pos)
		_pos.queue_free()

func configure_healthbar() -> void:
	healthbar.max_health = _health_comp.max_health
	healthbar.health = _health_comp._health

	# center health bar
	healthbar.position.x = -healthbar.health_bar_over.size.x / 2.0

