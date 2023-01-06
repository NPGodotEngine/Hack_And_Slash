extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED

export (PackedScene) var damage_text_scene = preload("res://Interface/HUD/DamageLabel.tscn")

func _ready() -> void:
    Events.connect("present_damage_text", self, "_on_present_damage_text")

func _on_present_damage_text(hit_damage:HitDamage, position:Vector2) -> void:
    # Instance a damage label if any
    if damage_text_scene:
        var damage_text = damage_text_scene.instance()
        var dmg_str = str(int(round(hit_damage._damage)))
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
