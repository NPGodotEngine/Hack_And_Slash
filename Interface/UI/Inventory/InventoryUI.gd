extends Panel

export var item_slot_scene: PackedScene = null

onready var grid_container: GridContainer = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/GridContainer

func _ready() -> void:
    if item_slot_scene:
        for item in InventoryManager.inventory.inventory_items:
            var item_slot: ItemSlotUI = item_slot_scene.instance()
            grid_container.add_child(item_slot)
            item_slot.display_item(item)
