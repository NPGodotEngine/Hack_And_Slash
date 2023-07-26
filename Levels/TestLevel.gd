extends Node2D

@export var test_weapon_name: String = "AKM"
 
func _ready() -> void:
	for player_spanwer in get_tree().get_nodes_in_group("PlayerSpawner"):
		player_spanwer.spawn()
	
	await get_tree().process_frame
	GameSaver.save_game_data()
	GameSaver.load_game_data()
	
	if test_weapon_name:
		var test_wp: Weapon = ResourceLibrary.weapons[test_weapon_name].instantiate()
		var test_wp_atter: WeaponAttributes = ResourceLibrary.weapon_attributes[test_weapon_name]

		for wp_mgr in get_tree().get_nodes_in_group("WeaponManager"):
			wp_mgr.add_weapon(test_wp, true)
			test_wp.weapon_attributes = test_wp_atter

	for wp_mgr in get_tree().get_nodes_in_group("WeaponManager"):
		(wp_mgr as WeaponManager).current_weapon_index = 0
