tool
extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT


export (NodePath) var dashComponent: NodePath

# Whether to update UI in physics process or not
export (bool) var physics_update: bool = true

onready var _dash_comp: DashComponent = get_node(dashComponent) as DashComponent

func _get_configuration_warning() -> String:
    if dashComponent.is_empty():
        return "dashComponent node path is missing"
    if not get_node(dashComponent) is DashComponent:
        return "dashComponent must be DashComponent"

    return ""

func _ready() -> void:
    _dash_comp.connect("dash_cooldown_end", self, "_on_dash_cooldown_end")
    _dash_comp.connect("dash_finished", self, "_on_dash_finished")

    if physics_update:
        set_physics_process(true)
        set_process(false)
    else:
        set_physics_process(false)
        set_process(true)

func _on_dash_cooldown_end() -> void:
    UIEvents.emit_signal("player_dash_updated", 100.0, 100.0)

func _on_dash_finished() -> void:
    UIEvents.emit_signal("player_dash_updated", 0.0, 100.0)

func _process(delta) -> void:
    update_dash_bar_ui()

func _physics_process(delta: float) -> void:
    update_dash_bar_ui()

func update_dash_bar_ui() -> void:
    if _dash_comp:
        var dash_progress: DashComponent.DashProgress = _dash_comp.dash_progress
        var progress: float = 0.0
        var duration: float = 0.0

        if dash_progress.state == DashComponent.DashStates.DASH:
            progress = dash_progress.progress * 100.0
            duration = dash_progress.duration * 100.0
        elif dash_progress.state == DashComponent.DashStates.COOLDOWN:
            progress = (dash_progress.duration - dash_progress.progress) * 100.0
            duration = dash_progress.duration * 100.0
        else:
            return

        UIEvents.emit_signal("player_dash_updated", progress, duration)