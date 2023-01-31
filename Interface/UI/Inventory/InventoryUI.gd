extends Panel

export var item_slot_scene: PackedScene = null

onready var grid_container: GridContainer = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/GridContainer

func _ready() -> void:
    InventoryManager.connect("inventory_updated", self, "_on_inventory_updated")

func _on_inventory_updated(items:Array) -> void:
    for child in get_children():
        if child is ItemSlotUI:
            remove_child(child)
            child.queue_free()

    if item_slot_scene:
        for item in items:
            var item_slot: ItemSlotUI = item_slot_scene.instance()
            grid_container.add_child(item_slot)
            item_slot.display_item(item)
    else:
        push_error("Item slot packed scene is missing")
