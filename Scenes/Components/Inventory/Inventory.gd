class_name Inventory
extends Resource

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT


# Emit when inventory updated
signal inventory_updated(items)



export var inventory_items: Array = []



# Add a new item into inventory
func add_item(item:InventoryItem) -> void:
    if item.stackable:
        var existed_item: InventoryItem = is_item_existed(item)
        # item is stackable and existed in inventory
        # increase it's stack by 1
        if existed_item != null:
            existed_item.add_to_stack()
            return 
    
    # item is either not stackable or
    # not existed in inventory
    # add it to inventory 
    inventory_items.append(item)
    _setup_item(item)

    # emit signal inventory updated
    emit_signal("inventory_updated", inventory_items)

# Remove an item from inventory
func remove_item_at(index:int) -> void:
    if index < 0 or index >= inventory_items.size():
        return

    var item: InventoryItem = inventory_items[index]
    if item.stackable:
        item.remove_from_stack()
    else:
        _destroy_item(item)
        inventory_items.remove(index)
        # emit signal inventory updated
        emit_signal("inventory_updated", inventory_items)

# Get inventory item at index
func get_item(index:int) -> InventoryItem:
    if index < 0 or index >= inventory_items.size():
        return null
    
    return inventory_items[index]

func _setup_item(item:InventoryItem) -> void:
    item.connect("item_updated", self, "_on_item_updated")
    item.connect("item_stack_full", self, "_on_item_stack_full")
    item.connect("remove_item", self, "_on_remove_item")

func _destroy_item(item:InventoryItem) -> void:
    item.disconnect("item_updated", self, "_on_item_updated")
    item.disconnect("item_stack_full", self, "_on_item_stack_full")
    item.disconnect("remove_item", self, "_on_remove_item")

func _on_item_updated(item:InventoryItem) -> void:
    # emit signal inventory updated
    emit_signal("inventory_updated", inventory_items)

func _on_item_stack_full(item:InventoryItem) -> void:
    # emit signal inventory updated
    emit_signal("inventory_updated", inventory_items)

func _on_remove_item(item:InventoryItem) -> void:
    var item_index = index_of_item(item)
    if item_index >= 0:
        remove_item_at(item_index)

    # emit signal inventory updated
    emit_signal("inventory_updated", inventory_items)

# Return inventory item if given item is existed in inventory
# otherwise return `null`
func is_item_existed(item:InventoryItem) -> InventoryItem:
    for i in inventory_items:
        if (i as InventoryItem).is_same_item(item):
            return i

    return null

# Return index of inventory item if found
# otherwise return -1
func index_of_item(item:InventoryItem) -> int:
    for i in inventory_items.size():
        var inv_item: InventoryItem = inventory_items[i]
        if inv_item.is_same_item(item):
            return i
    
    return -1
