@tool
class_name PlayerController
extends Controller

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_SIGNAL


## Emit when player controller enabled
signal on_enabled_control()

## Emit when player controller disabled
signal on_disabled_control()

## Nodepath to MovementComponent
@export var movement_ref: NodePath

## Nodepath to DodgeComponent
@export var dodge_ref: NodePath

## Nodepath to WeaponManager
@export var weapon_manager_ref: NodePath

## The name of group this player controller belong to
@export var group_name: String = "PlayerController"

## If `true` it will make other player controller
## disabled when scene tree ready
## @
## Change this value at runtime will do nothing
@export var current: bool = false


## MovementComponent
@onready var _movement: MovementComponent = get_node_or_null(movement_ref)

## DodgeComponent
@onready var _dodge: DodgeComponent = get_node_or_null(dodge_ref)

## WeaponManager
@onready var _weapon_manager: WeaponManager = get_node_or_null(weapon_manager_ref)

var _player: Player = null

## Whether actor is in dodging or not
var _is_dodging: bool = false

## Is player in control
## @
## `true` will disabled any other player controllers in scene tree
## `false` will only disable this player controller
var is_player_control: bool = false: set = set_is_player_control

## Dodge direction
var _dodge_direction: Vector2 = Vector2.RIGHT

func set_is_player_control(value:bool) -> void:
	is_player_control = value

	if Engine.is_editor_hint():
		return
	
	if is_player_control == true:
		# enable this player controller
		enable_control()

		# disable other player controller
		_disable_other_player_controller()
	else:
		# disable this player controller
		disable_control()

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

	if is_inside_tree():
		add_to_group(group_name)
		set_is_player_control(current)
	else:
		await self.ready
		add_to_group(group_name)
		set_is_player_control(current)

func _on_dodge_finished() -> void:
	_is_dodging = false

func _on_dodge_cooldown_begin() -> void:
	print("dodge cooldown begin")

func _on_dodge_cooldown_end() -> void:
	print("dodge cooldown end")

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if not is_player_control:
		return

	if _player.is_dead:
		return

	update_weapon_input()

func _physics_process(_delta):
	if Engine.is_editor_hint():
		return

	if not is_player_control:
		return

	if _player.is_dead:
		return
	
	update_movement()

func _disable_other_player_controller() -> void:
	var player_controllers := get_tree().get_nodes_in_group(group_name)

	if not player_controllers or player_controllers.is_empty():
		return

	for player_controller in player_controllers:
		if player_controller != self:
			(player_controller as PlayerController).is_player_control = false

func enable_control() -> void:
	super()
	emit_signal("on_enabled_control")

func disable_control() -> void:
	super()
	emit_signal("on_disabled_control")

func update_movement() -> void:
	if _movement == null:
		return
	
	if not _is_dodging:
		# Get direction from input
		var direction: Vector2 = Vector2(
			Input.get_axis("move_left", "move_right"),
			Input.get_axis("move_up", "move_down")
		)

		_movement.movement_velocity = _movement.direction_to_velocity(direction)
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

