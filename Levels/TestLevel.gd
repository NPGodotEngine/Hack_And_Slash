extends Node2D

func _ready() -> void:
	# yield(get_tree().create_timer(1.0), "timeout")

	for weapon_mgr in get_tree().get_nodes_in_group("WeaponManager"):
		if weapon_mgr is WeaponManager:
			# add test weapons as child
			var weapon: Weapon = ResourceLibrary.weapons["AKM"].instance()
			var weapon_att: WeaponAttributes = ResourceLibrary.weapon_attributes["AKM"]
			# change weapon attributes
			weapon.weapon_attributes = weapon_att
			weapon_mgr.add_weapon(weapon, true)

	GameSaver.save_game_data()
	GameSaver.load_game_data()
