class_name InventoryItem
extends Resource

# warning-ignore-all: UNUSED_ARGUMENT


enum InventoryItemType {
    Equipment
}

# Emit when inventory item updated stack count
signal item_updated(item)

# Emit when inventory item stack size full
signal item_stack_full(item)

# Emit when this item need to be removed
# from inventory
signal remove_item(item)


# Inventory item type
export(InventoryItemType) var item_type: int

# Is inventory item stackable
export var stackable: bool = false

# Max size this inventory item can stack
export var stack_size: int = 10

# Item's icon to be displayed in inventory
export var icon: Texture = null

# Current stack count
export var _stack_quantity: int = 1



func _init() -> void:
    if stack_size <= 0:
        stack_size = 1

    if _stack_quantity <= 0:
        _stack_quantity = 1
    elif _stack_quantity > stack_size:
        _stack_quantity = stack_size



# Increase stack count
func add_to_stack(amount:int=1) -> void:
    if not stackable:
        return

    if amount + _stack_quantity <= stack_size:
        _stack_quantity += amount
        # emit signal item updated
        emit_signal("item_updated", self)
    else:
        # emit signal item stack full
        emit_signal("item_stack_full", self)


# Decrease stack count
func remove_from_stack(amount:int=1) -> void:
    if not stackable:
        #emit signal remove item
        emit_signal("remove_item", self)
        return
    
    var new_stack_quantity = _stack_quantity - amount
    if new_stack_quantity < 0 or new_stack_quantity == 0:
        #emit signal remove item
        emit_signal("remove_item", self)
    else:
        _stack_quantity = new_stack_quantity
        # emit signal item updated
        emit_signal("item_updated", self)

# Return `true` if given item is as same as this item
# otherwise `false`
##
# By default it check item type
# Any subclass item is recommend to override
# behaviour
func is_same_item(item:InventoryItem) -> bool:
    return item_type == item.item_type