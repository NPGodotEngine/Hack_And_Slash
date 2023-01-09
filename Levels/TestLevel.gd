extends Node2D

onready var weapon_library: Array = [
	"ProjectileWeapon",
]

func _ready() -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	for child in get_children():
		if child is Player:
			for node in child.get_children():
				if node is WeaponManager:
					# add preset weapons as child
					for weapon_name in weapon_library:
						var weapon: Weapon = Global.create_instance(weapon_name)
						node.add_weapon(weapon, true)
						# change weapon properties
						(weapon as ProjectileWeapon)._accuracy.accuracy = 0.5
						(weapon as ProjectileWeapon)._ranged_damage.max_damage = 10.0
						(weapon as ProjectileWeapon)._ranged_damage.min_damage = 5.0

	GameSaver.save_game_data()
	GameSaver.load_game_data()
