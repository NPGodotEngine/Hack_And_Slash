class_name DashState
extends HBoxContainer


onready var dashbar: DashBar = $DashBar

func _ready() -> void:
    UIEvents.connect("player_dash_updated", self, "_on_player_dash_updated")

func _on_player_dash_updated(progress:float, duration:float) -> void:
    update_dash_bar(progress, duration)

func update_dash_bar(progress, duration) -> void:
    dashbar.dash_value = progress
    dashbar.max_dash_value = duration

