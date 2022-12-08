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

# Penetration chance
var penetration_chance: float = 0.0

## Getter Setter ##
func set_life_span(value:float) -> void:
    if not is_inside_tree() or not _life_span_timer:
        yield(self, "ready")
    life_span = value
    _life_span_timer.start(life_span)
## Getter Setter ##



## Override ##
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
    _move_projectile(delta)
## Override ##


## Singal callback ##
func _on_body_entered(body:Node) -> void:
    _on_projectile_hit_body(body)
## Singal callback ##


# Move projectile
##
# Move projectile straight line direction
# or subclass override to behave differently
func _move_projectile(delta:float) -> void:
    var velocity := direction.normalized() * speed * delta
    global_rotation = direction.angle()
    global_position += velocity

# Can this projectile penetrate the target
func _is_penetrated() -> bool:
    if is_equal_approx(penetration_chance, 0.0): return false
    
    # RNG
    randomize()
    var rolled_chance = rand_range(0.0001, 1.0)
    if (rolled_chance < penetration_chance or 
        is_equal_approx(rolled_chance, penetration_chance)):
        return true
    return false

# Call when this projectile hit a physics body
func _on_projectile_hit_body(body:Node) -> void:
    if body.has_method("take_damage"):
        body.take_damage(hit_damage)
    
    # free projectile if not penetrated
    if not _is_penetrated():
        queue_free()
