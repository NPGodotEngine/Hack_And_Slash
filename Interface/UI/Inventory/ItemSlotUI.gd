class_name ItemSlotUI
extends Panel

export var default_icon: Texture

onready var quantity_label: Label = $MarginContainer/SlotColorRect/MarginContainer/HBoxContainer/Quantity
onready var item_icon: TextureRect = $MarginContainer/SlotColorRect/MarginContainer/HBoxContainer/ItemIcon

func display_item(item:InventoryItem) -> void:
	if item.stackable:
		quantity_label.text = "x%s" % str(item._stack_quantity)
	else:
		quantity_label.text = ""

	if item.icon:
		item_icon.texture = item.icon
	else:
		item_icon.texture = default_icon
	

	
