extends Node

const SCENE_RES_SUFFIX = "_Res.tscn"
const WEAPON_ATTR_SUFFIX = "_Attr_Res.tres"

const weapons_res_path = "res://Scenes/Prefabs/Weapons/"
const weapon_attributes_res_path = "res://Scenes/Prefabs/Weapons/Attributes/"
const player_character_res_path = "res://Scenes/Prefabs/Characters/Players/"
const enemy_character_res_path = "res://Scenes/Prefabs/Characters/Enemies/"

# Dictionary contain all weapon resources as
# type of Resource
var weapons := {}

# Dictionary contain all weapon attribute resources
# as type of Resource
var weapon_attributes := {}

var player_characters := {}

var enemy_characters := {}

func _ready() -> void:
	iterate_directory(weapons_res_path, Callable(self, "load_resource"), weapons, SCENE_RES_SUFFIX)
	iterate_directory(weapon_attributes_res_path, Callable(self, "load_resource"), weapon_attributes, WEAPON_ATTR_SUFFIX)
	iterate_directory(player_character_res_path, Callable(self, "load_resource"), player_characters, SCENE_RES_SUFFIX)
	iterate_directory(enemy_character_res_path, Callable(self, "load_resource"), enemy_characters, SCENE_RES_SUFFIX)

## Iterate a directory and handle file by
## a given function
##
## `path`: absolute path to directory
## `file_handler`: a `Callable` function that take parameters when
## a file need to be handled and function's parameters are:
## 	- `filename` as string
## 	- `current_dir` as string
## 	- `store_in`: as dictionary
## 	- `match_suffix`: as string
## `store_in`: a dictionary the resource will be stored as key value pair
## file_handler function need to deal with storage
## `match_suffix`: the filename end with this suffix will be consider only
## `recursive`: `true` iterate sub directories recursively otherwise `false`  
func iterate_directory(path:String, file_handler:Callable, store_in:Dictionary,
						match_suffix:String, recursive:bool=true) -> void:
	var opend_dir := DirAccess.open(path)
	if opend_dir == null || DirAccess.get_open_error() != OK:
		push_error("Unable to open directory %s" % path)
		return

	if opend_dir.list_dir_begin()  != OK:# TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		push_error("Unable to open directory %s" % path)
		return
	
	var filename: String = opend_dir.get_next()
	while filename != "":
		if file_handler:
			# if recursive iteration (subfloders)
			# and current is a directory (folder)
			# then iterate sub directories
			if recursive && opend_dir.current_is_dir():
				iterate_directory("%s/%s" % [opend_dir.get_current_dir(), filename], 
									file_handler, store_in, match_suffix, recursive)
			else: # call function to handle file
				file_handler.call(filename, opend_dir.get_current_dir(), store_in, match_suffix)

		filename = opend_dir.get_next()

func load_resource(filename:String, current_dir:String, storage:Dictionary, match_suffix:String) -> void:
	if filename.ends_with(match_suffix):
		var res_name: String= filename.replace(match_suffix, "")
		storage[res_name] = load("%s/%s" % [current_dir, filename])
		print("Load resource: %s \t store as name: %s" % [filename, res_name])
