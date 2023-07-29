extends Node

# Weapon module type
##
# `TRIGGER` gun trigger
# `AMMO` gun ammo
# `Receiver` gun Receiver
# `ALT` fun alternative fire
enum WeaponModuleType {
	TRIGGER = 1,
	AMMO = 2,
	ALT = 4
}

# Bullet type
enum BulletType {
	PROJECTILE = 1,
	BEAM = 2
}

# Add object to current scene tree
##
# `object` object to be added to scene tree
# `deferrd` if `true` then object will be added to scene tree next frame
# otherwise `false` add object immediatelly default is `true`
func add_to_scene_tree(object:Node, deferrd:bool = true, group_name=null) -> void:
	if object:
		var scene: Node = get_tree().current_scene
		if group_name:
			var nodes := get_tree().get_nodes_in_group(group_name)
			if not nodes.is_empty():
				scene = nodes[0]
		if deferrd:
			scene.call_deferred("add_child", object)
		else:
			scene.add_child(object)

# RNG check value is in a range
##
# Roll a randomized value between from_range and to_range
# and then return `true` if the randomized value is under 
# and equal to `threshold` otherwise false
##  
# `from_range`, `to_range` are inclusived
func is_in_threshold(threshold, from_range, to_range) -> bool:
	# RNG
	randomize()
	var rolled_chance = randf_range(from_range, to_range)
	if (rolled_chance < threshold or 
		is_equal_approx(rolled_chance, threshold)):
		return true
	return false

# Return an absolute file path if found the specific file
# in directories
# This will search directories recursively
##
# `file_name`: file name with extension
# `path`: directory path to search 
func find_file_in_directory(file_name:String, path:String="res://"):
	var absolute_file_path = null
	var opend_dir := DirAccess.open(path)
	if opend_dir == null || DirAccess.get_open_error() != OK:
		push_error("Unable to open directory %s" % path)
		return null

	if opend_dir.list_dir_begin()  != OK:# TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		push_error("Unable to open directory %s" % path)
		return null

	var file_or_dir: String = opend_dir.get_next()
	while file_or_dir != "":
		if opend_dir.current_is_dir():
			absolute_file_path = find_file_in_directory(file_name, path.path_join(file_or_dir))
			if absolute_file_path != null: 
				break
		elif file_or_dir == file_name:
			absolute_file_path = path.path_join(file_or_dir)
			break
		file_or_dir = opend_dir.get_next()

	return absolute_file_path

# Create an instance from file name
# Return null if not found
##
# `file_name`: name of file
# `extension`: file extension default is `tscn`
# `search_dir`: directory to search from default is project root
func create_instance(file_name:String, extension:String = "tscn", search_dir:String = "res://") -> Object:
	var basename: String = file_name.get_basename()
	basename = basename + "." + extension

	var file_path: String = Global.find_file_in_directory(basename, search_dir)
	if file_path == null:
		return null
	
	var instance: Node = load(file_path).instantiate()
	if instance:
		return instance
		
	return null
	
