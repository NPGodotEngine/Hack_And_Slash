class_name Projectile
extends Area2D

# warning-ignore:RETURN_VALUE_DISCARDED

# Bullet _speed
export var _speed := 200.0

# Bullet life span duration
export var _life_span := 3.0

# Life span timer
var _life_span_timer: Timer = null

# Bullet travel direction
var direction := Vector2.ZERO

# Hit damage
var hit_damage: HitDamage = null

func _ready() -> void:
    # warning-ignore:RETURN_VALUE_DISCARDED 
    
    _life_span_timer = Timer.new()
    _life_span_timer.name = "LifeSpanTimer"
    add_child(_life_span_timer)
    _life_span_timer.wait_time = _life_span
    _life_span_timer.one_shot = true
    _life_span_timer.connect("timeout", self, "queue_free")
    _life_span_timer.start()

    connect("body_entered", self, "_on_body_entered")

func _exit_tree() -> void:
    if _life_span_timer:
        _life_span_timer.disconnect("timeout", self, "queue_free")
        
func _physics_process(delta: float) -> void:
    var velocity := direction.normalized() * _speed * delta
    global_rotation = direction.angle()
    global_position += velocity

func _on_body_entered(body:Node) -> void:
    if body.has_method("take_damage"):
        body.take_damage(hit_damage)
    queue_free()
