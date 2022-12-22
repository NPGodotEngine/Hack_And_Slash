extends Node

const SAVE_FOLDER = "res://Debug/Saves"
const SAVE_NAME_TEMPLATE = "Save_%03d.tres"

# Save game
##
# Any nodes in group `save` and 
# have `save` method will be called on
# method `save` with argument `SaveGame`
func save_game(id:int) -> int:
    # Create a new save game
    var save_game: SaveGame = SaveGame.new()

    # Set game version
    save_game.save_version = ProjectSettings.get_setting("global/game_version")

    # Make sure directory exists
    var directory: Directory = Directory.new()
    if not directory.dir_exists(SAVE_FOLDER):
        var mk_dir_state: int =  directory.make_dir_recursive(SAVE_FOLDER)
        if not mk_dir_state == OK:
            push_error("Create directory fail %s, code: %d" % [SAVE_FOLDER, mk_dir_state])
            return mk_dir_state
    
    # Tell all nodes in tree to save
    # All nodes that are in group `save` and
    # have save method
    for node in get_tree().get_nodes_in_group("save"):
        if node.has_method("save"):
            node.save(save_game)
    
    # Save game
    var save_file_path: String = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
    var save_state: int = ResourceSaver.save(save_file_path, save_game)
    if not save_state == OK:
        push_error("Save game fail at path %s, code %d" % [save_file_path, save_state])
    
    return save_state

# Load save game
##
# Any nodes in group `save` and 
# have `load` method will be called on
# method `load` with argument `SaveGame`
func load_saved_game(id:int) -> int:
    var file: File = File.new()
    var save_file_path: String = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % id)
    if not file.file_exists(save_file_path):
        push_warning("Save game file %s dose not exist" % save_file_path)
        return ERR_FILE_NOT_FOUND
    
    var save_game: SaveGame = ResourceLoader.load(save_file_path)
    if save_game == null:
        push_error("Load save game fail %s" % save_file_path)
        return ERR_FILE_CANT_READ

    # Tell all nodes in tree to load
    # All nodes that are in group `save` and
    # have load method
    for node in get_tree().get_nodes_in_group("save"):
        if node.has_method("load"):
            node.load(save_game)

    return OK 