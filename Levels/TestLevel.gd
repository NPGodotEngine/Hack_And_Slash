extends Node2D

onready var weapon_library: Array = [
	preload("res://Components/Weapons/WeaponBlueprint.tscn"),
]

func _ready() -> void:
    for child in get_children():
        if child is Character:
            child.setup()
            for node in child.get_children():
                if node is WeaponManager:
                    # add preset weapons as child
                    for weapon_scene in weapon_library:
                        var weapon: Weapon = weapon_scene.instance()
                        node.add_weapon(weapon, true)
            
    print(GameSaver.save_game(1))
    print(GameSaver.load_saved_game(1))