@tool
extends CharacterSkin

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT



const HIT = "hit"

@onready var _anim_player: AnimationPlayer = $AnimationPlayer

var _character: Character = null

func _get_configuration_warnings() -> PackedStringArray:
	if not super().is_empty():
		return super()
	
	if not is_instance_of(get_parent(), Character):
		return ["This node must be a child of Character node"]

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
	_character = get_parent() as Character
	_character.connect("on_character_take_damage", Callable(self, "_on_charater_take_damage"))


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

func on_die_anim_finished() -> void:
	_character.queue_free()

func update_skin() -> void:
	# This will be updated my AI
	pass
	# if _velocity.x < 0.0:
	# 	self.flip_h = true
	# elif _velocity.x > 0.0:
	# 	self.flip_h = false
