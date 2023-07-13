tool
extends Projectile

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT



func _get_configuration_warning() -> String:
    var hit_box_node: HitBox = get_node("HitBox")
    if hit_box_node == null:
        return "Requried a node of HitBox as child"

    return ""
    
func _ready() -> void:
    $HitBox.connect("contacted_hurt_box", self, "_on_contact_hurt_box")
    $HitBox.connect("contacted_static_body", self, "_on_contact_static_body")

func _on_contact_hurt_box(hurt_box:HurtBox) -> void:
    if _ignored_bodies.has(hurt_box): 
        return

    emit_signal("projectile_hit", hurt_box)

    # free projectile if not penetrated
    if not _is_penetrated():
        queue_free()

func _on_contact_static_body(body:StaticBody2D) -> void:
    queue_free()

func _hit_damage_updated(damage:HitDamage) -> void:
    $HitBox.hit_damage = damage

