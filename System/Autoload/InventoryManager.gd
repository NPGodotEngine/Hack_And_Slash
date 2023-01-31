extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT


signal inventory_updated(items)


var inventory: Inventory setget set_inventory

func set_inventory(inv:Inventory) -> void:
	if inv == null:
		return
	inventory = inv

	inventory.connect("inventory_updated", self, "_on_inventory_updated")
	emit_signal("inventory_updated", inventory.inventory_items)

func _ready() -> void:
	set_inventory(Inventory.new())
	GameSaver.connect("save_game", self, "_on_save_game")
	GameSaver.connect("load_game", self, "_on_load_game")
		
	
func _on_save_game(saved_data:SavedData) -> void:
	saved_data.data["Inventory"] = inventory

func _on_load_game(saved_data:SavedData) -> void:
	set_inventory(saved_data.data["Inventory"])

func _on_inventory_updated(items) -> void:
	emit_signal("inventory_updated", items)

