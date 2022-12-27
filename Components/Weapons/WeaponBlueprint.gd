# WeaponBlueprint that extended from Weapon
tool
extends Weapon

# warning-ignore-all: UNUSED_ARGUMENT

func setup() -> void:
	.setup()

	weapon_appearance.setup()

func execute() -> void:
	.execute()

	if trigger:
		trigger.pull_trigger()


func cancel_execution() -> void:
	.cancel_execution()

func execute_alt() -> void:
	.execute_alt()

func cancel_alt_execution() -> void:
	.cancel_alt_execution()

func active() -> void:
	.active()

func inactive() -> void:
	.inactive()

func _on_trigger_pulled() -> void:
	._on_trigger_pulled()

	for fire_position in weapon_appearance.fire_positions:
		var hit_damage: HitDamage = get_hit_damage()
		var global_mouse_pos: Vector2 = get_global_mouse_position()
		var direction = global_mouse_pos - global_position
		var spread_direction: Vector2 = _accuracy_comp.get_random_spread(direction, get_weapon_accuracy())
		var to_new_pos: Vector2 =  (spread_direction * global_position.distance_to(global_mouse_pos) 
														+ fire_position)
		if ammo:
			ammo.shoot_ammo(fire_position, to_new_pos, hit_damage)

func _on_ammo_depleted(ammo_count:int, round_per_clip:int) -> void:
	._on_ammo_depleted(ammo_count, round_per_clip)

	if ammo:
		ammo.reload_ammo()

func _on_ammo_count_changed(ammo_count:int, round_per_clip:int) -> void:
	._on_ammo_count_changed(ammo_count, round_per_clip)

func _on_begin_reloading(ammo_count:int, round_per_clip:int) -> void:
	._on_begin_reloading(ammo_count, round_per_clip)

func _on_end_reloading(ammo_count:int, round_per_clip:int) -> void:
	._on_end_reloading(ammo_count, round_per_clip)

func _on_damage_changed(from, to) -> void:
	._on_damage_changed(from, to)

func _on_accuracy_changed(from, to) -> void:
	._on_accuracy_changed(from, to)


# Get hit damage from weapon
func get_hit_damage() -> HitDamage:
	var damage: int = get_weapon_damage()
	var critical: bool = _critical_strike_comp.is_critical()
	var color: Color = (_critical_strike_comp.critical_strike_color if critical 
										else _damage_comp.damage_color)
	var hit_damage: HitDamage = HitDamage.new().init(
		weapon_manager.get_manager_owner(),
		self,
		damage,
		critical,
		_critical_strike_comp.critical_strike_multiplier,
		color
	)

	return hit_damage

func to_dictionary() -> Dictionary:
	var state: Dictionary = .to_dictionary()

	for node in get_children():
		if node is Component:
			var comp_state = node.to_dictionary()
			state[node.name] = comp_state

	return state

func from_dictionary(state:Dictionary) -> void:
	.from_dictionary(state)
	for key in state:
		var node: Component = get_node(key)
		node.from_dictionary(state[key])
	

