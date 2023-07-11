tool
extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT


export (NodePath) var dodgeComponent: NodePath

# Whether to update UI in physics process or not
export (bool) var physics_update: bool = true

onready var _dodge_comp: DodgeComponent = get_node(dodgeComponent) as DodgeComponent

func _get_configuration_warning() -> String:
    if dodgeComponent.is_empty():
        return "dodgeComponent node path is missing"
    if not get_node(dodgeComponent) is DodgeComponent:
        return "dodgeComponent must be DodgeComponent"

    return ""

func _ready() -> void:
    _dodge_comp.connect("dodge_cooldown_end", self, "_on_dodge_cooldown_end")
    _dodge_comp.connect("dodge_finished", self, "_on_dodge_finished")

    if physics_update:
        set_physics_process(true)
        set_process(false)
    else:
        set_physics_process(false)
        set_process(true)

func _on_dodge_cooldown_end() -> void:
    UIEvents.emit_signal("player_dodge_updated", 100.0, 100.0)

func _on_dodge_finished() -> void:
    UIEvents.emit_signal("player_dodge_updated", 0.0, 100.0)

func _process(delta) -> void:
    update_dodge_bar_ui()

func _physics_process(delta: float) -> void:
    update_dodge_bar_ui()

func update_dodge_bar_ui() -> void:
    if _dodge_comp:
        var dodge_progress: DodgeComponent.DodgeProgress = _dodge_comp.dodge_progress
        var progress: float = 0.0
        var duration: float = 0.0

        if dodge_progress.state == DodgeComponent.DodgeStates.DODGE:
            progress = dodge_progress.progress * 100.0
            duration = dodge_progress.duration * 100.0
        elif dodge_progress.state == DodgeComponent.DodgeStates.COOLDOWN:
            progress = (dodge_progress.duration - dodge_progress.progress) * 100.0
            duration = dodge_progress.duration * 100.0
        else:
            return

        UIEvents.emit_signal("player_dodge_updated", progress, duration)