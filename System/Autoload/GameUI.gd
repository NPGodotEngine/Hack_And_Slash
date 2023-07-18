extends Node

# warning-ignore-all: UNUSED_ARGUMENT


const GUI_GROUP_NAME = "GUI"

# Point to game world's GUI instance
##
# Setting this value does nothing
var gui: GUI: get = get_gui, set = no_set


func no_set(_active_treevalue) -> void:
	pass

func get_gui() -> GUI:
	var found_gui: Array = get_tree().get_nodes_in_group(GUI_GROUP_NAME)

	if found_gui.size() == 0:
		push_error("Must at least a GUI instance need to be attached to game world with group name `GUI`")
		return null
	elif found_gui.size() > 1:
		push_warning("Multiple GUI instances found and only first one will be used")
		return null

	if not found_gui[0] is GUI:
		push_error("GUI instance must have GUI script attached")
		return null
	
	return found_gui[0]

