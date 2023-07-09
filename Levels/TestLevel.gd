extends Node2D

export (String) var test_weapon_name: String = "AKM"
 
func _ready() -> void:
	# yield(get_tree().create_timer(1.0), "timeout")

	for weapon_mgr in get_tree().get_nodes_in_group("WeaponManager"):
		if weapon_mgr is WeaponManager:
			# add test weapons as child
			var weapon: Weapon = ResourceLibrary.weapons[test_weapon_name].instance()
			var weapon_att: WeaponAttributes = ResourceLibrary.weapon_attributes[test_weapon_name]
			# change weapon attributes
			weapon.weapon_attributes = weapon_att
			weapon_mgr.add_weapon(weapon, true)

	GameSaver.save_game_data()
	GameSaver.load_game_data()
