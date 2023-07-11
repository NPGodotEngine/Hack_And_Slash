tool
class_name PlayerSkin
extends AnimatedSprite

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT



const IDLE = "idle"
const RUN = "run"
const DODGE = "dodge"



# Node path to MovementComponent
export(NodePath) var movement: NodePath
export(NodePath) var dodge: NodePath

# MovementComponent
onready var _movement: MovementComponent = get_node(movement)
onready var _dodge: DodgeComponent = get_node(dodge)


# Velocity from MovementComponent
var _velocity: Vector2 = Vector2.ZERO



func _get_configuration_warning() -> String:
	if movement.is_empty():
		return "movement node path is missing"
	if not get_node(movement) is MovementComponent:
		return "movement must be a MovementComponent node"
	if _dodge.is_empty():
		return "dodge node path is missing"
	if not get_node(dodge) is DodgeComponent:
		return "dodge must be a DodgeComponent node"  

	return ""

func _ready() -> void:
	if Engine.editor_hint:
		return
	
	# wait for parent node to be ready
	var _player = get_parent()
	yield(_player, "ready")

	_movement.connect("velocity_updated", self, "_on_velocity_updated")

	play(IDLE)

func _physics_process(delta: float) -> void:
	if Engine.editor_hint:
		return

	update_skin()
	if _dodge._is_dodging:
		play(DODGE)
	elif abs(_velocity.x) <= 0.1 and abs(_velocity.y) <= 0.1:
		play(IDLE)
	elif get_global_mouse_position().x < global_position.x and _velocity.x > 0.0:
		play(RUN, true)
	elif get_global_mouse_position().x > global_position.x and _velocity.x < 0.0:
		play(RUN, true)
	else:
		play(RUN)

func _on_velocity_updated(velocity_context:MovementComponent.VelocityContext) -> void:
	_velocity = velocity_context.updated_velocity


func update_skin() -> void:
	# change facing direction
	# base on mouse course relative to character
	var global_mouse_position := get_global_mouse_position()

	if global_mouse_position.x < global_position.x:
		self.flip_h = true
	else:
		self.flip_h = false

	# change direction when dodging
	if _dodge._is_dodging:
		if _velocity.x < 0.0:
			self.flip_h = true
		elif _velocity.x > 0.0:
			self.flip_h = false


