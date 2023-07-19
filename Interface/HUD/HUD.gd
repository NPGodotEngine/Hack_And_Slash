class_name HUD
extends CanvasLayer

# warning-ignore-all: RETURN_VALUE_DISCARDED


@onready var cursor: Control = $HUDCursor

func _ready() -> void:
    UIEvents.connect("add_weapon_crosshair", Callable(self, "_on_add_weapon_crosshair"))
    UIEvents.connect("add_weapon_reload_indicator", Callable(self, "_on_add_weapon_reload_indicator"))
    
func _on_add_weapon_crosshair(crosshair:Node2D) -> void:
    cursor.add_child(crosshair)

func _on_add_weapon_reload_indicator(indicator:Node2D) -> void:
    cursor.add_child(indicator)