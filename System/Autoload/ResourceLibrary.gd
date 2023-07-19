extends Node

const WEAPON = "_Weapon.tscn"
const WEAPON_ATTRIBUTE = "_Attr.tres"
const PLAYER = "_Pl.tscn"

const weapons_res_path = "res://Scenes/Prefabs/Weapons/"
const player_character_res_path = "res://Scenes/Prefabs/Characters/Players/"

# Dictionary contain all weapon resources as
# type of Resource
var weapons := {}

# Dictionary contain all weapon attribute resources
# as type of Resource
var weapon_attributes := {}

var player_characters := {}

func _ready() -> void:
    iterate_directory(weapons_res_path, "load_weapon_resource")
    iterate_directory(player_character_res_path, "load_player_character_resource")
    print(player_characters)

# Iterate a directory and handle file by
# a given function
##
# `path`: absolute path to directory
# `file_handler`: a function that take arguments when
# a file need to be handled 
#  - `filename` as string
#  - `current_dir` as string
# `recursive`: `true` iterate sub directories recursively otherwise `false`  
func iterate_directory(path:String, file_handler:String, recursive:bool=true) -> void:
    var opend_dir := DirAccess.open(path)
    if opend_dir == null || DirAccess.get_open_error() != OK:
        push_error("Unable to open directory %s" % path)
        return

    if opend_dir.list_dir_begin()  != OK:# TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
        push_error("Unable to open directory %s" % path)
        return
    
    var filename: String = opend_dir.get_next()
    while filename != "":
        if file_handler != "" or not file_handler.is_empty():
            # if recursive iteration (subfloders)
            # and current is a directory (folder)
            # then iterate sub directories
            if recursive && opend_dir.current_is_dir():
                iterate_directory("%s/%s" % [opend_dir.get_current_dir(), filename], 
                                    file_handler, recursive)
            else: # call function to handle file
                call(file_handler, filename, opend_dir.get_current_dir())

        filename = opend_dir.get_next()

func load_weapon_resource(filename:String, current_dir:String) -> void:
    # if file is weapon .tscn
    if filename.ends_with(WEAPON):
        var weapon_name: String= filename.replace(WEAPON, "")
        weapons[weapon_name] = load("%s/%s" % [current_dir, filename])
        print("load weapon: %s" % weapon_name)
    # if file is weapon attribute .tres
    elif filename.ends_with(WEAPON_ATTRIBUTE):
        var weapon_name: String= filename.replace(WEAPON_ATTRIBUTE, "")
        weapon_attributes[weapon_name] = load("%s/%s" % [current_dir, filename])
        print("load weapon attribute: %s" % weapon_name)

func load_player_character_resource(filename:String, current_dir:String) -> void:
    # if file is player character .tscn
    if filename.ends_with(PLAYER):
        var character_name: String= filename.replace(PLAYER, "")
        player_characters[character_name] = load("%s/%s" % [current_dir, filename])
        print("load player character: %s" % character_name)