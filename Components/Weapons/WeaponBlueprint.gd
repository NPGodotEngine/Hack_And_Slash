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
		var direction: Vector2 = global_mouse_pos - global_position
		var spread_direction: Vector2 = weapon_receiver.get_spread_range(direction, get_weapon_accuracy())
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


	

