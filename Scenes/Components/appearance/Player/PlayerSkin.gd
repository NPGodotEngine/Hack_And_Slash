@tool
extends CharacterSkin

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT



const DODGE = "dodge"
const HIT = "hit"

## NodePath to DodgeComponent
@export var dodge_ref: NodePath

## NodePath to PlayerController
@export var player_controller_ref: NodePath

@onready var _dodge: DodgeComponent = get_node_or_null(dodge_ref)
@onready var _player_controller: PlayerController = get_node_or_null(player_controller_ref)
@onready var _anim_player: AnimationPlayer = $AnimationPlayer

var _character: Character = null
var _can_update_skin: bool = true

func _get_configuration_warnings() -> PackedStringArray:
	if not super().is_empty():
		return super()

	if not is_instance_of(get_parent(), Character):
		return ["This node must be a child of Character node"]

	if dodge_ref.is_empty():
		return ["dodge node path is missing"]
	if not get_node(dodge_ref) is DodgeComponent:
		return ["dodge must be a DodgeComponent node"]

	if player_controller_ref.is_empty():
		return ["player_controller_ref node path is missing"]
	if not get_node(player_controller_ref) is PlayerController:
		return ["player_controller_ref must be a PlayerController node"]
	
	var anim_player_exists = false
	for child in get_children():
		if child is AnimationPlayer:
			anim_player_exists = true
			break
	if not anim_player_exists:
		return ["Must have a child node of AnimationPlayer with name AnimationPlayer"]

	return []

func _ready() -> void:
	super()
	if Engine.is_editor_hint():
		return

	await get_parent().ready
	_player_controller.connect("on_enabled_control", Callable(self, "_on_player_control_enabled"))
	_player_controller.connect("on_disabled_control", Callable(self, "_on_player_control_disabled"))
	_character = get_parent() as Character	
	_character.connect("on_character_take_damage", Callable(self, "_on_charater_take_damage"))

	
func _on_player_control_enabled() -> void:
	_can_update_skin = true

func _on_player_control_disabled() -> void:
	_can_update_skin = false
	
func _on_charater_take_damage(_hit_damage:HitDamage, _total_damage:int) -> void:
	_anim_player.play("hit")

func _on_anim_finished() -> void:
	if animation == DIE:
		randomize()
		var index: float = randf_range(0.0, 1.0)
		if index <= 0.5:
			_anim_player.play("die_roll_forward")
		else:
			_anim_player.play("die_roll_backward")

func process_animation(delta:float) -> void:
	if _health_comp._health <= 0.0:
		return 

	if _dodge._is_dodging:
		play(DODGE)
	else:
		super(delta)

func update_skin() -> void:
	super()
	
	if not _can_update_skin:
		return
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
	
		
		


