# Class compoent extend from Node2D
class_name Component
extends Node2D

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED

# Call to setup component
func setup() -> void:
    pass


# Get component state as a diectionary
##
# Return a dictionary with component's 
# properties with script name
func get_component_state(ignore_private:bool=true) -> Dictionary:
    var dict: Dictionary = inst2dict(self)
    var path: String = dict["@path"]
    dict["script_name"] = path.get_file()
    dict.erase("@path")
    dict.erase("@subpath")
    for key in dict.keys():
        if key.begins_with("_"):
            dict.erase(key)
    return dict

func apply_component_state(state:Dictionary) -> void:
    var script_name: String = state["script_name"]
    var script_file_path: String = Global.find_file_in_directory(script_name)
    if script_file_path:
        var script_ref: Reference = load(script_file_path)
        set_script(script_ref)
        state.erase("script_name")
    else:
        push_error("Attach script fail script not found %s" % script_name)
    
    for key in state.keys():
        set(key, state[key])