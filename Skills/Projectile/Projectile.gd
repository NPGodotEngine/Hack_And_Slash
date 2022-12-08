class_name Projectile
extends Area2D

# warning-ignore:RETURN_VALUE_DISCARDED

# Bullet _speed
var _speed := 200.0

# Bullet life span duration
var _life_span := 3.0

# Life span timer
var _life_span_timer: Timer = null

# Bullet travel direction
var _direction := Vector2.ZERO

# Hit damage
var _hit_damage: HitDamage = null

# Penetration chance
var _penetration_chance: float = 0.0

# Skill that shoot this projectile
var _skill: Skill = null

## Getter Setter ##
func set_life_span(value:float) -> void:
    if not is_inside_tree() or not _life_span_timer:
        yield(self, "ready")
    _life_span = value
    _life_span_timer.start(_life_span)
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


# Setup projectile
# Call this in order to setup projectile
##
# `skill` the skill fire this projectile
# `direction` the direction this projectile is flying
# `position` global position this projectile start 
func setup(skill:Skill, direction:Vector2, position:Vector2) -> void:
    if not is_inside_tree():
        yield(self, "ready")
    
    _skill = skill
    _direction = direction
    global_position = position
    _hit_damage = _skill.get_hit_damage()
    _speed = _skill.projectile_speed
    _life_span = _skill.projectile_life_span
    _penetration_chance = _skill.projectile_penetration

    # start life span timer
    _life_span_timer.start(_life_span)

# Move projectile
##
# Move projectile straight line direction
# or subclass override to behave differently
func _move_projectile(delta:float) -> void:
    var velocity := _direction.normalized() * _speed * delta
    global_rotation = _direction.angle()
    global_position += velocity

# Can this projectile penetrate the target
func _is_penetrated() -> bool:
    if is_equal_approx(_penetration_chance, 0.0): return false
    
    # check if penetrated
    return Utils.is_in_threshold(_penetration_chance, 0.0001, 1.0)

# Call when this projectile hit a physics body
func _on_projectile_hit_body(body:Node) -> void:
    if body.has_method("take_damage"):
        body.take_damage(_hit_damage)
    
    # free projectile if not penetrated
    if not _is_penetrated():
        queue_free()
