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
                 
    # print(GameSaver.save_game(1))
    print(GameSaver.load_saved_game(1))
    change()

func change() -> void:
    var player: Player = null
    for child in get_children():
        if child is Player:
            player = child
    
    # change weapon appearances
    var weapon: Weapon = player.weapon_manager.get_weapon_by(0)
    var weapon_skin: WeaponSkin = weapon.weapon_appearance
    weapon_skin.ammo_skin = load("res://Components/Weapons/WeaponSkin/AmmoSkins/TestAmmoSkin.tscn").instance()
    weapon_skin.stock_skin = load("res://Components/Weapons/WeaponSkin/StockSkins/TestStockSkin.tscn").instance()
    weapon_skin.trigger_skin = load("res://Components/Weapons/WeaponSkin/TriggerSkins/TestTriggerSkin.tscn").instance()
    weapon_skin.barrel_skin = load("res://Components/Weapons/WeaponSkin/BarrelSkins/TestBarrelSkin.tscn").instance()
    weapon_skin.base_skin = load("res://Components/Weapons/WeaponSkin/BaseSkins/TestBaseSkin.tscn").instance()
    
    # # change weapon trigger script
    # weapon.trigger.set_script(load("res://Components/Attachments/Triggers/BurstTrigger.gd"))
    print(GameSaver.save_game(1))