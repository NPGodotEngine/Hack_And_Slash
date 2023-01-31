class_name EquipmentItem
extends InventoryItem

# warning-ignore-all: UNUSED_ARGUMENT

export(PackedScene) var equipment_scene: PackedScene
export(Resource) var equipment_attr: Resource

func is_same_item(item:InventoryItem) -> bool:
    return false

