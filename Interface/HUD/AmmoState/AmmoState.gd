extends HBoxContainer

# warning-ignore-all: RETURN_VALUE_DISCARDED


onready var ammo_count_ui: AmmoCount = $AmmoCount

func _ready() -> void:
    UIEvents.connect("player_ammo_updated", self, "_on_player_ammo_updated")

func _on_player_ammo_updated(ammo_count:int, max_ammo_count:int) -> void:
    ammo_count_ui.ammo_count = ammo_count
    ammo_count_ui.max_ammo_count = max_ammo_count