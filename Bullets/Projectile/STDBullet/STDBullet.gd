extends Projectile

onready var detection_area = $DetectionArea

func _ready() -> void:
    detection_area.connect("body_entered", self, "_on_bullet_hit_body")

# Call when this projectile hit a physics body
func _on_bullet_hit_body(body:Node) -> void:
    if _ignored_bodies.has(body): return

    if not body is Character:
        queue_free()
        return

    if body.has_method("take_damage"):
        emit_signal("on_projectile_hit", self, body)
        body.take_damage(_hit_damage)
    
    # free projectile if not penetrated
    if not _is_penetrated():
        queue_free()

