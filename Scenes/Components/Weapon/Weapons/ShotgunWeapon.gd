@tool
class_name ShotgunWeapon
extends ProjectileWeapon

# Number of projectile per each shot
@export var rounds_per_shot: int = 4

func _on_trigger_pulled() -> void:
	if not _ammo is ShotgunAmmo:
		push_error("Ammo is not a type of ShotgunAmmo")
		return

	if _ammo._is_reloading:
		return

	var shotgun_ammo: ShotgunAmmo = _ammo as ShotgunAmmo

	var rounds: Array = shotgun_ammo.consume_ammo(rounds_per_shot)

	for bullet in rounds:
		bullet.hit_damage = get_hit_damage()
		bullet.show_behind_parent = true

	for point in _fire_points:
		var muzzle_position = (point as Marker2D).global_position
		var distance: float = muzzle_position.distance_to(current_fire_position)

		for bullet in rounds:
			var end_position = _angle_spread.get_random_spread(global_position.direction_to(current_fire_position), 
													_accuracy.accuracy) * distance + muzzle_position
			Global.add_to_scene_tree(bullet)
			bullet.setup_direction(muzzle_position, end_position)

	puff_muzzle_flash()
