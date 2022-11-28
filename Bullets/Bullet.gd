extends Area2D

# Bullet speed
export var speed := 200.0

# Bullet damage
export var damage := 0

# Bullet life span duration
export var life_span := 3.0

# Life span timer
onready var life_span_timer := $LifeSpanTimer

# Bullet travel direction
var direction := Vector2.ZERO

func _ready() -> void:
    life_span_timer.wait_time = life_span
    life_span_timer.one_shot = true
    life_span_timer.connect("timeout", self, "queue_free")
    life_span_timer.start()

func _exit_tree() -> void:
    if life_span_timer:
        life_span_timer.disconnect("timeout", self, "queue_free")
        
func _physics_process(delta: float) -> void:
    var velocity := direction.normalized() * speed * delta
    global_rotation = direction.angle()
    global_position += velocity
