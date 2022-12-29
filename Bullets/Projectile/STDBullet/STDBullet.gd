tool
extends Projectile

# warning-ignore-all: RETURN_VALUE_DISCARDED

func _get_configuration_warning() -> String:
    var hit_box_node: HitBox = get_node("HitBox")
    if hit_box_node == null:
        return "Requried a node of HitBox as child"

    return ""
    
func _ready() -> void:
    $HitBox.connect("contacted_hurt_box", self, "_on_contact_hurt_box")

func setup(from_position:Vector2, to_position:Vector2, speed:float, 
    hit_damage:HitDamage, life_span:float, penetration_chance:float) -> void:
    .setup(from_position, to_position, speed, hit_damage, life_span, penetration_chance)

    $HitBox.hit_damage = hit_damage

func _on_contact_hurt_box(hurt_box:HurtBox) -> void:
    if _ignored_bodies.has(hurt_box): 
        return

    emit_signal("projectile_hit", hurt_box)

    # free projectile if not penetrated
    if not _is_penetrated():
        queue_free()

