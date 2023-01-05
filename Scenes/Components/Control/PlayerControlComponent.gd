tool
class_name PlayerControl
extends Node

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED

# Node path to MovementComponent
export(NodePath) var movement: NodePath

# Node path to WeaponManager
export(NodePath) var weapon_manager: NodePath

# MovementComponent
onready var _movement: MovementComponent = get_node(movement)

# WeaponManager
onready var _weapon_manager: WeaponManager = get_node(weapon_manager)



func _get_configuration_warning() -> String:
    if movement.is_empty():
        return "movement node path is missing"

    if not get_node(movement) is MovementComponent:
        return "movement must be a MovementComponent node" 

    if weapon_manager.is_empty():
        return "weapon_manager node path is missing"

    if not get_node(weapon_manager) is WeaponManager:
        return "weapon_manager must be WeaponManager node"

    return ""

func _physics_process(delta: float) -> void:
    if Engine.editor_hint:
        return

    update_movement()
    update_weapon_input()

func update_movement() -> void:
    if _movement == null or movement.is_empty():
        return

    # Get direction from input
    var direction: Vector2 = Vector2(
        Input.get_axis("move_left", "move_right"),
        Input.get_axis("move_up", "move_down")
    ).normalized()

    _movement.move(direction)

func update_weapon_input() -> void:
    if _weapon_manager == null:
        return

    # execute weapon 
    if Input.is_action_pressed("primary"): 
        _weapon_manager.execute_weapon()
    elif Input.is_action_just_released("primary"):
        _weapon_manager.cancel_weapon_execution()

    if Input.is_action_pressed("secondary"):
        _weapon_manager.execute_weapon_alt()
    elif Input.is_action_just_released("secondary"):
        _weapon_manager.cancel_weapon_alt_execution()

