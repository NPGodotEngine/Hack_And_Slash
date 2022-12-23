# Class compoent extend from Node2D
class_name Component
extends Node2D

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED

# Call to setup component
func setup() -> void:
    pass


# Serialize component into a dictionary
##
# Return a dictionary which contain the name of script
# attached to component and all properties of the component
##
# `ignore_private` if `true` any properties beign with underscore `_`
# will not be added into dictionary. Default is `true`
# `property_prefix` configure property's prefix that property will be ignored
##
# The method takecare most of properties manipulation, if there is
# a case need to ignore certain property then it is required to 
# override this method and call parent of this method then remove
# it
func get_component_state(ignore_private:bool=true, property_prefix:String="_") -> Dictionary:
    # turn object into dictionary
    var dict: Dictionary = inst2dict(self)

    # get script file name only
    var path: String = dict["@path"]
    dict["script_name"] = path.get_file()

    # remove 2 keys from `inst2dict`
    dict.erase("@path")
    dict.erase("@subpath")

    # add component's properties
    for key in dict.keys():
        # if member property begin with underscore
        # and setting `ignore_private` is true
        # then remove it from dictionary
        if ignore_private and key.begins_with(property_prefix):
            dict.erase(key)

    dict["name"] = name
    return dict

# Apply state dictionary to component
##
# The method will fire load a new script and attache it 
# to component and then apply all values from state
# dictionary to the component
##
# In most case it is not reuqired to override this method 
# only to do so if needed
func apply_component_state(state:Dictionary) -> void:
    # get script name
    var script_name: String = state["script_name"]

    # find script file in project
    var script_file_path: String = Global.find_file_in_directory(script_name)
    
    # attach script file to component
    if script_file_path:
        var script_ref: Reference = load(script_file_path)
        set_script(script_ref)
        # remove script name key
        state.erase("script_name")
    else:
        push_error("Attach script fail script not found %s" % script_name)
    
    # apply rest of component's properties
    for key in state.keys():
        set(key, state[key])