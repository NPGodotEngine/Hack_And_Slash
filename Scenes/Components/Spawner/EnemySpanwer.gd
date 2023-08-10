extends Spawner


func handle_spawn(resource_name) -> void:
	var mob: Mob = ResourceLibrary.enemy_characters[resource_name].instantiate()
	Global.add_to_scene_tree(mob, true, Global.GN_MAP)

	if not mob.is_inside_tree():
		await mob.ready
		configure_enemy(mob)
	else:
		configure_enemy(mob)

func configure_enemy(mob:Mob) -> void:
	mob.global_position = random_point_inside_circle(global_position, 0.0, spawn_radius)
