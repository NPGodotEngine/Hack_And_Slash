class_name DodgeState
extends HBoxContainer

# warning-ignore-all: RETURN_VALUE_DISCARDED

onready var dodgebar: DodgeBar = $DodgeBar

func _ready() -> void:
    UIEvents.connect("player_dodge_updated", self, "_on_player_dodge_updated")

func _on_player_dodge_updated(progress:float, duration:float) -> void:
    update_dodge_bar(progress, duration)

func update_dodge_bar(progress, duration) -> void:
    dodgebar.dodge_value = progress
    dodgebar.max_dodge_value = duration

