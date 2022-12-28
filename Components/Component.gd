# Class compoent extend from Node2D
class_name Component
extends Node2D

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED


# Use this key to retrieve node's name
# during deserialization
const NODE_NAME_KEY = "node_name"

# Use this key to retrieve node's resource name
# e.g `my_node.tscn`
# during deserialization
const RESOURCE_NAME_KEY = "resource_name"

# Use this key to retrieve node's script name
# during deserialization
const SCRIPT_NAME_KEY = "script_name"

# Use this key to retrieve node's properties
# during deserialization
const PROPERTIES_KEY = "properties"

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
# Use constant key e.g `NODE_NAME_KEY` to
# retrieve or add data to dictionary
##
# Return a dictionary which contain following:
##
# node's name `NODE_NAME_KEY`
##
# node's resource name if node is an instance of other scene
# `RESOURCE_NAME_KEY`
##
# node's properties only serializied properties
# `PROPERTIES_KEY`
##
# node's script name if it has script
# `SCRIPT_NAME_KEY`
func to_dictionary() -> Dictionary:
    var component_dict: Dictionary = {}

    # add component name
    component_dict[NODE_NAME_KEY] = name

    # add resource file name
    component_dict[RESOURCE_NAME_KEY] = self.filename.get_file()

    # add an empty properties dictionary
    component_dict[PROPERTIES_KEY] = {}

    # add component script name
    component_dict[SCRIPT_NAME_KEY] = ""
    var script = get_script()
    if script:
        component_dict[SCRIPT_NAME_KEY] = script.get_path().get_file()
        
    return component_dict

# Deserialize a dictionary into component
##
# Reverse what have done in `to_dictionary()`
func from_dictionary(state:Dictionary) -> void:
    pass