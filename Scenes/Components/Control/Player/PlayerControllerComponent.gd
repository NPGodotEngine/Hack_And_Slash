tool
class_name PlayerControllerComponent
extends Controller

# warning-ignore-all: UNUSED_ARGUMENT
# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_SIGNAL



# Node path to MovementComponent
export(NodePath) var movement: NodePath

# Node path to DodgeComponent
export(NodePath) var dodge: NodePath

# Node path to WeaponManager
export(NodePath) var weapon_manager: NodePath

export(NodePath) var actor: NodePath

# MovementComponent
onready var _movement: MovementComponent = get_node(movement) as MovementComponent

# DodgeComponent
onready var _dodge: DodgeComponent = get_node(dodge) as DodgeComponent

# WeaponManager
onready var _weapon_manager: WeaponManager = get_node(weapon_manager) as WeaponManager

onready var _actor: Player = get_node(actor) as Player

# Whether actor is in dodging or not
var _is_dodging: bool = false
var _dodge_direction: Vector2 = Vector2.RIGHT

func _get_configuration_warning() -> String:
    if movement.is_empty():
        return "movement node path is missing"
    if not get_node(movement) is MovementComponent:
        return "movement must be a MovementComponent node"

    if dodge.is_empty():
        return "dodge node path is missing"
    if not get_node(dodge) is DodgeComponent:
        return "dodge must be a DodgeComponent node"  

    if weapon_manager.is_empty():
        return "weapon_manager node path is missing"
    if not get_node(weapon_manager) is WeaponManager:
        return "weapon_manager must be WeaponManager node"

    if actor.is_empty():
        return "actor node path is missing"
    if not get_node(actor) is Player:
            return "actor must be Player node"

    return ""

func _ready() -> void:
    _dodge.connect("dodge_finished", self, "_on_dodge_finished")
    _dodge.connect("dodge_cooldown_begin", self, "_on_dodge_cooldown_begin")
    _dodge.connect("dodge_cooldown_end", self, "_on_dodge_cooldown_end")

func _on_dodge_finished() -> void:
    _is_dodging = false

func _on_dodge_cooldown_begin() -> void:
    print("dodge cooldown begin")

func _on_dodge_cooldown_end() -> void:
    print("dodge cooldown end")

func _physics_process(delta: float) -> void:
    if Engine.editor_hint:
        return
    
    if _actor.is_dead:
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
    
    if not _is_dodging:
        # Get direction from input
        var direction: Vector2 = Vector2(
            Input.get_axis("move_left", "move_right"),
            Input.get_axis("move_up", "move_down")
        ).normalized()

        _movement.process_move(direction)
    else:
        _dodge.process_dodge(_dodge_direction)

    if (Input.is_action_just_pressed("Dodge") and 
        not _is_dodging and _dodge.is_dodge_avaliable):
        _is_dodging = true
        _dodge_direction = Vector2(
            Input.get_axis("move_left", "move_right"),
            Input.get_axis("move_up", "move_down")
        ).normalized()
    
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

