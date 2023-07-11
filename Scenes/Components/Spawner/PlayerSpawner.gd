extends Spawner

func handle_spawn(resource_name) -> void:
    var player: Player = ResourceLibrary.player_characters[resource_name].instance()
    Global.add_to_scene_tree(player)

    if not player.is_inside_tree():
        yield(player, "ready")
        configure_player(player)
    else:
        configure_player(player)

func configure_player(player:Player) -> void:
    player.global_position = global_position
