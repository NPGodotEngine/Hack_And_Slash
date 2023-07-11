extends Node2D

export (String) var test_weapon_name: String = "AKM"
 
func _ready() -> void:
	for player_spanwer in get_tree().get_nodes_in_group("PlayerSpawner"):
		player_spanwer.spawn()

	yield(get_tree(), "idle_frame")
	GameSaver.save_game_data()
	GameSaver.load_game_data()
