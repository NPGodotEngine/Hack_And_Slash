extends Node

# Emit when save game start
##
# `saved_data`: `SavedData` 
signal save_game(saved_data)

# Emit when load game start
##
# `saved_data`: `SavedData` 
signal load_game(saved_data)

# Save file folder
const SAVE_FOLDER = "res://Debug/Saves"

# Save file name template
const SAVE_NAME_TEMPLATE = "SavedData.tres"

# Current saved data
var saved_data: SavedData = null


func _init() -> void:
	saved_data = load_saved_data()

# Return a saved data
##
# Return an existing one if it had saved data
# otherwise create a new saved data
##
# Return `null` if error happend
func load_saved_data() -> SavedData:
	var file: File = File.new()
	var save_file_path: String = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE)
	var data: SavedData = null

	# create a new save if not exists or load existing one
	if not file.file_exists(save_file_path):
		push_warning("Save game file %s dose not exist, create a new save" % save_file_path)

		# Make sure directory exists
		var directory: Directory = Directory.new()

		if not directory.dir_exists(SAVE_FOLDER):
			var mk_dir_state: int =  directory.make_dir_recursive(SAVE_FOLDER)
			if not mk_dir_state == OK:
				push_error("Create directory for new saved data fail %s, code: %d" % 
						[SAVE_FOLDER, mk_dir_state])
				return null

		# Create a new save game
		data = SavedData.new()

		# Set game version
		var save_version = ProjectSettings.get_setting("global/game_version")
		if save_version != null:
			data.save_version = ProjectSettings.get_setting("global/game_version")
		else:
			push_error("Project required a setting `global/game_version`")
			data.save_version = "0.0.0"
	else:
		data = ResourceLoader.load(save_file_path)

		if data == null:
			push_error("Load save game fail %s" % save_file_path)

	return data



# Save game data
func save_game_data() -> void:
	if saved_data == null:
		saved_data = load_saved_data()

	# Tell all nodes in tree to save
	emit_signal("save_game", saved_data)

	# Save game
	var save_file_path: String = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE)
	var save_state: int = ResourceSaver.save(save_file_path, saved_data)
	if not save_state == OK:
		push_error("Save game fail at path %s, code %d" % [save_file_path, save_state])

# Load saved game data
func load_game_data() -> void:
	if saved_data == null:
		saved_data = load_saved_data()

	# Tell all nodes in tree to load
	emit_signal("load_game", saved_data)
