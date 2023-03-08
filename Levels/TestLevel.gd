extends Node2D

onready var weapon_library: Array = [
	"MarineWeapon",
]

onready var weapon_att_library: Array = [
	"MaineWeaponAtt.tres"
]

func _ready() -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	for child in get_children():
		if child is Player:
			for node in child.get_children():
				if node is WeaponManager:
					# add preset weapons as child
					for i in weapon_library.size():
						var weapon_name = weapon_library[i]
						var weapon_att_res_path = Global.find_file_in_directory(weapon_att_library[i])
						var weapon: Weapon = Global.create_instance(weapon_name)
						var weapon_att: WeaponAttributes = load(weapon_att_res_path)
						node.add_weapon(weapon, true)
						# # change weapon attributes
						weapon.weapon_attributes = weapon_att


	GameSaver.save_game_data()
	GameSaver.load_game_data()

