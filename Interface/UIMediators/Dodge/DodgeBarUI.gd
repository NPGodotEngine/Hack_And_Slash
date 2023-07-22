@tool
extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT


## Whether to update UI in physics process or not
@export var physics_update: bool = true

var _dodge_comp: DodgeComponent = null

func _get_configuration_warnings() -> PackedStringArray:
    if not is_instance_of(get_parent(), DodgeComponent):
        return ["This node must be a child of DodgeComponent node"] 

    return []

func _ready() -> void:
    if Engine.is_editor_hint():
        return
    
    await get_parent().ready
    _dodge_comp = get_parent() as DodgeComponent
    _dodge_comp.connect("dodge_cooldown_end", Callable(self, "_on_dodge_cooldown_end"))
    _dodge_comp.connect("dodge_finished", Callable(self, "_on_dodge_finished"))

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

func _process(_delta) -> void:
    update_dodge_bar_ui()

func _physics_process(_delta: float) -> void:
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