extends Spawner

# warning-ignore-all: UNUSED_ARGUMENT


func handle_spawn(resource_name) -> void:
	var player: Player = ResourceLibrary.player_characters[resource_name].instantiate()
	Global.add_to_scene_tree(player, true, Global.GN_MAP)

	if not player.is_inside_tree():
		await player.ready
		configure_player(player)
	else:
		configure_player(player)

func configure_player(player:Player) -> void:
	player.global_position = random_point_inside_circle(global_position, 0.0, spawn_radius)


