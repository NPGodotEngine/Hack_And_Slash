tool
extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED

export (PackedScene) var damage_text_scene: PackedScene

func _get_configuration_warning() -> String:
    if damage_text_scene == null:
        return "damage text PackedScene is missing and will not display damage text"
    
    return ""

func _ready() -> void:
    UIEvents.connect("display_damage_text", self, "_on_display_damage_text")

func _on_display_damage_text(hit_damage:HitDamage, total_damage:float, position:Vector2) -> void:
    # Instance a damage label if any
    if damage_text_scene:
        var damage_text = damage_text_scene.instance()
        var dmg_str = str(int(round(total_damage)))
        var is_critical: bool = hit_damage._is_critical
        var color: Color = hit_damage._color_of_damage

        if damage_text:
            add_child(damage_text)
            damage_text.global_position = position
            damage_text.set_damage(
                dmg_str,
                is_critical, 
                color,
                Color.black,
                "-",
                " (Crit)" if is_critical else ""
            )

