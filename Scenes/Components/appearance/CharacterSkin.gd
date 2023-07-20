@tool
class_name CharacterSkin
extends AnimatedSprite2D

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT



const IDLE = "idle"
const RUN = "run"
const DIE = "die"



# Node path to MovementComponent
@export var movement: NodePath
@export var health: NodePath
@export var character: NodePath

# MovementComponent
@onready var _movement: MovementComponent = get_node_or_null(movement)
@onready var _health_comp: HealthComponent = get_node_or_null(health)
@onready var _character: Character = get_node_or_null(character)


# Velocity from MovementComponent
var _velocity: Vector2 = Vector2.ZERO



func _get_configuration_warnings() -> PackedStringArray:
	if movement.is_empty():
		return ["movement node path is missing"]
	if not get_node(movement) is MovementComponent:
		return ["movement must be a MovementComponent node"]
	if health.is_empty():
		return ["health node path is missing"]
	if not get_node(health) is HealthComponent:
		return ["health must be a HealthComponent"]
	if character.is_empty():
		return ["character node path is missing"]
	if not get_node(character) is Character:
		return ["character must be a Character"]

	return []

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	# wait for parent node to be ready
	var _player = get_parent()
	await _player.ready

	_movement.connect("velocity_updated", Callable(self, "_on_velocity_updated"))
	_health_comp.connect("die", Callable(self, "_on_die"))
	connect("animation_finished", Callable(self, "_on_anim_finished"))

	play(IDLE)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	update_skin()
	process_animation(delta)

func _on_velocity_updated(velocity_context:MovementComponent.VelocityContext) -> void:
		_velocity = velocity_context.updated_velocity

func _on_die() -> void:
	play(DIE)


func update_skin() -> void:
	pass

func process_animation(_delta:float) -> void:
	if _health_comp._health <= 0.0:
		return 

	if abs(_velocity.x) <= 0.1 and abs(_velocity.y) <= 0.1:
		play(IDLE)
	elif get_global_mouse_position().x < global_position.x and _velocity.x > 0.0:
		play(RUN, true)
	elif get_global_mouse_position().x > global_position.x and _velocity.x < 0.0:
		play(RUN, true)
	else:
		play(RUN)



