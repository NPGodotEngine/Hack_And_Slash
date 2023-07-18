extends HBoxContainer

# warning-ignore-all: RETURN_VALUE_DISCARDED


@onready var ammo_count_ui: AmmoCount = $AmmoCount

func _ready() -> void:
    UIEvents.connect("player_ammo_updated", Callable(self, "_on_player_ammo_updated"))
    UIEvents.connect("hide_player_ammo_ui", Callable(self, "_on_hide_player_ammo_ui"))
    UIEvents.connect("show_player_ammo_ui", Callable(self, "_on_show_player_ammo_ui"))

    super._ready()

func _on_player_ammo_updated(ammo_count:int, max_ammo_count:int) -> void:
    ammo_count_ui.ammo_count = ammo_count
    ammo_count_ui.max_ammo_count = max_ammo_count

func _on_show_player_ammo_ui() -> void:
    self.show()
    
func _on_hide_player_ammo_ui() -> void:
    self.hide()