class_name Projectile
extends Area2D

# warning-ignore:RETURN_VALUE_DISCARDED

# Bullet _speed
export var speed := 200.0

# Bullet life span duration
export var life_span := 3.0 setget set_life_span

# Life span timer
var _life_span_timer: Timer = null

# Bullet travel direction
var direction := Vector2.ZERO

# Hit damage
var hit_damage: HitDamage = null

## Getter Setter ##
func set_life_span(value:float) -> void:
    if not is_inside_tree() or not _life_span_timer:
        yield(self, "ready")
    life_span = value
    _life_span_timer.start(life_span)
## Getter Setter ##

func _ready() -> void:
    # warning-ignore:RETURN_VALUE_DISCARDED 
    
    _life_span_timer = Timer.new()
    _life_span_timer.name = "LifeSpanTimer"
    add_child(_life_span_timer)
    _life_span_timer.one_shot = true
    _life_span_timer.connect("timeout", self, "queue_free")

    connect("body_entered", self, "_on_body_entered")

func _exit_tree() -> void:
    if _life_span_timer:
        _life_span_timer.disconnect("timeout", self, "queue_free")
        
func _physics_process(delta: float) -> void:
    var velocity := direction.normalized() * speed * delta
    global_rotation = direction.angle()
    global_position += velocity

func _on_body_entered(body:Node) -> void:
    if body.has_method("take_damage"):
        body.take_damage(hit_damage)
    queue_free()
