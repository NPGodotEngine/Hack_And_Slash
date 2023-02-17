tool
class_name PlayerControllerComponent
extends Controller

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_SIGNAL


# Emit when dash is about to happen
signal prepare_for_dash()

# Node path to MovementComponent
export(NodePath) var movement: NodePath

# Node path to DashComponent
export(NodePath) var dash: NodePath

# Node path to WeaponManager
export(NodePath) var weapon_manager: NodePath

export(NodePath) var actor: NodePath

# MovementComponent
onready var _movement: MovementComponent = get_node(movement) as MovementComponent

# DashComponent
onready var _dash: DashComponent = get_node(dash) as DashComponent

# WeaponManager
onready var _weapon_manager: WeaponManager = get_node(weapon_manager) as WeaponManager

onready var _actor: KinematicBody2D = get_node(actor) as KinematicBody2D

# Whether actor is in dashing or not
var _is_dashing: bool = false
var _dash_direction: Vector2 = Vector2.RIGHT

func _get_configuration_warning() -> String:
    if movement.is_empty():
        return "movement node path is missing"
    if not get_node(movement) is MovementComponent:
        return "movement must be a MovementComponent node"

    if dash.is_empty():
        return "dash node path is missing"
    if not get_node(dash) is DashComponent:
        return "dash must be a DashComponent node"  

    if weapon_manager.is_empty():
        return "weapon_manager node path is missing"
    if not get_node(weapon_manager) is WeaponManager:
        return "weapon_manager must be WeaponManager node"

    if actor.is_empty():
        return "actor node path is missing"
    if not get_node(actor) is KinematicBody2D:
            return "actor must be KinematicBody2D node"

    return ""

func _ready() -> void:
    _dash.connect("dash_finished", self, "_on_dash_finished")
    _dash.connect("dash_cooldown_begin", self, "_on_dash_cooldown_begin")
    _dash.connect("dash_cooldown_end", self, "_on_dash_cooldown_end")

func _on_dash_finished() -> void:
    _is_dashing = false

func _on_dash_cooldown_begin() -> void:
    print("dash cooldown begin")

func _on_dash_cooldown_end() -> void:
    print("dash cooldown end")

func _physics_process(delta: float) -> void:
    if Engine.editor_hint:
        return

    update_movement()
    update_weapon_input()

func enable_control() -> void:
    .enable_control()

func disable_control() -> void:
    .disable_control()

func update_movement() -> void:
    if _movement == null:
        return
    
    if not _is_dashing:
        # Get direction from input
        var direction: Vector2 = Vector2(
            Input.get_axis("move_left", "move_right"),
            Input.get_axis("move_up", "move_down")
        ).normalized()

        _movement.move(direction)
    else:
        _dash.dash(_dash_direction)

    if (Input.is_action_just_pressed("Dash") and 
        not _is_dashing and not _dash._is_cooldown):
        _is_dashing = true
        _dash_direction = _actor.global_position.direction_to(_actor.get_global_mouse_position())
        emit_signal("prepare_for_dash")
    
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

