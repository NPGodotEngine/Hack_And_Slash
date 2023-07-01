extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED


func _ready() -> void:
    UIEvents.connect("display_damage_text", self, "_on_display_damage_text")

func _on_display_damage_text(hit_damage:HitDamage, total_damage:float, damage_text_ui) -> void:
    if damage_text_ui:
        var dmg_str = str(int(round(total_damage)))
        var is_critical: bool = hit_damage._is_critical
        var color: Color = hit_damage._color_of_damage
        add_child(damage_text_ui)
        damage_text_ui.set_damage(
            dmg_str,
            is_critical, 
            color,
            Color.black,
            "-",
            " (Crit)" if is_critical else ""
        )

