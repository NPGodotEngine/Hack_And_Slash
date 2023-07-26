@tool
class_name PlayerControllerComponent
extends Controller

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_SIGNAL



# Nodepath to MovementComponent
@export var movement_ref: NodePath

# Nodepath to DodgeComponent
@export var dodge_ref: NodePath

# Nodepath to WeaponManager
@export var weapon_manager_ref: NodePath


# MovementComponent
@onready var _movement: MovementComponent = get_node_or_null(movement_ref)

# DodgeComponent
@onready var _dodge: DodgeComponent = get_node_or_null(dodge_ref)

# WeaponManager
@onready var _weapon_manager: WeaponManager = get_node_or_null(weapon_manager_ref)

var _player: Player = null

# Whether actor is in dodging or not
var _is_dodging: bool = false
var _dodge_direction: Vector2 = Vector2.RIGHT

func _get_configuration_warnings() -> PackedStringArray:
	if not is_instance_of(get_parent(), Player):
		return ["This node must be a child of Player node"]

	if movement_ref.is_empty():
		return ["movement node path is missing"]
	if not get_node(movement_ref) is MovementComponent:
		return ["movement must be a MovementComponent node"]
	if dodge_ref.is_empty():
		return ["dodge node path is missing"]
	if not get_node(dodge_ref) is DodgeComponent:
		return ["dodge must be a DodgeComponent node"]
	if weapon_manager_ref.is_empty():
		return ["weapon_manager node path is missing"]
	if not get_node(weapon_manager_ref) is WeaponManager:
		return ["weapon_manager must be WeaponManager node"]

	return []

func _ready() -> void:
	super()
	if Engine.is_editor_hint():
		return
	
	await  get_parent().ready
	_player = get_parent() as Player
	_dodge.connect("dodge_finished", Callable(self, "_on_dodge_finished"))
	_dodge.connect("dodge_cooldown_begin", Callable(self, "_on_dodge_cooldown_begin"))
	_dodge.connect("dodge_cooldown_end", Callable(self, "_on_dodge_cooldown_end"))

func _on_dodge_finished() -> void:
	_is_dodging = false

func _on_dodge_cooldown_begin() -> void:
	print("dodge cooldown begin")

func _on_dodge_cooldown_end() -> void:
	print("dodge cooldown end")

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if _player.is_dead:
		return

	update_movement()
	update_weapon_input()

func enable_control() -> void:
	super()

func disable_control() -> void:
	super()

func update_movement() -> void:
	if _movement == null:
		return
	
	if not _is_dodging:
		# Get direction from input
		var direction: Vector2 = Vector2(
			Input.get_axis("move_left", "move_right"),
			Input.get_axis("move_up", "move_down")
		).normalized()

		_movement.process_move(direction)
	else:
		_dodge.process_dodge(_dodge_direction)

	if (Input.is_action_just_pressed("Dodge") and 
		not _is_dodging and _dodge.is_dodge_avaliable):
		_is_dodging = true
		_dodge_direction = Vector2(
			Input.get_axis("move_left", "move_right"),
			Input.get_axis("move_up", "move_down")
		).normalized()
	
func update_weapon_input() -> void:
	if _weapon_manager == null:
		return

	# point weapon at
	_weapon_manager.point_weapon_at(get_global_mouse_position())

	# execute weapon 
	if Input.is_action_pressed("primary"): 
		_weapon_manager.execute_weapon(get_global_mouse_position())
	elif Input.is_action_just_released("primary"):
		_weapon_manager.cancel_weapon_execution()

	if Input.is_action_pressed("secondary"):
		_weapon_manager.execute_weapon_alt(get_global_mouse_position())
	elif Input.is_action_just_released("secondary"):
		_weapon_manager.cancel_weapon_alt_execution()

