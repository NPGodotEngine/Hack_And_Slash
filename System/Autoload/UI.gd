extends Node

var gui: GUI = null

func _ready() -> void:
	var found_gui: Array = get_tree().get_nodes_in_group("GUI")

	if found_gui.size() == 0:
		push_error("Must at least a GUI instance need to be attached to game world with group name `GUI`")
		return
	elif found_gui.size() > 1:
		push_warning("Multiple GUI instances found and only first one will be used")
		return

	if not found_gui[0] is GUI:
		push_error("GUI instance must have GUI script attached")
		return

	gui = found_gui[0] as GUI

	# make sure gui is at first in game world in node order
	gui.get_parent().move_child(gui, 0)

	
