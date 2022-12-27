# Class compoent extend from Node2D
class_name Component
extends Node2D

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED

func _ready() -> void:
    connect("script_changed", self, "_on_script_changed")
    _on_component_ready()

    
# Call to setup component
func setup() -> void:
    pass
        
func _on_component_ready() -> void:
    pass

func _begin_component_ready_process() -> void:
    _on_component_ready()
    yield(get_tree(), "idle_frame")

func _on_script_changed() -> void:
    yield(_begin_component_ready_process(), "completed")
    setup()
    
# Remove self from parent node
##
# `delete`: `true` then call queue_free() after removed from parent
func remove_from_parent(delete:bool = true):
    var parent: Node = get_parent()
    if parent:
        parent.remove_child(self)
    if delete:
        queue_free()


# Serialize component into a dictionary
##
# Return a dictionary which contain the name of script
# attached to component and node name
# `{name: "node_name", script_name: "script_file_name"}`
func to_dictionary() -> Dictionary:
    var component_dict: Dictionary = {}

    # add component name
    component_dict["name"] = name

    # add component script name
    var script = get_script()
    if script:
        component_dict["script_name"] = script.get_path().get_file()
    else:
        component_dict["script_name"] = ""

    return component_dict

# Apply state dictionary to component
##
# The method will set compoenent node name 
# load a new script and attache it 
# to this component and then apply all properties' value 
# from state dictionary to the component
##
# In most case it is not reuqired to override this method 
# only to do so if needed
func from_dictionary(state:Dictionary) -> void:
    name = state["name"]
    state.erase("name")

    # get script name
    var script_name: String = state["script_name"]

    if script_name != "":
        # find script file in project
        var script_file_path: String = Global.find_file_in_directory(script_name)
        
        # attach script file to component
        if script_file_path:
            var script_ref: Reference = load(script_file_path)
            set_script(script_ref)
        else:
            push_error("Attach script fail, script not found %s" % script_name)

    # remove script name key
    state.erase("script_name")
    
    # apply rest of component's properties
    for key in state.keys():
        if not get(key) == null:
            set(key, state[key])
        else:
            push_warning("Can not apply value to property %s in %s" % [key, name])