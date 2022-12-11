class_name Projectile
extends Area2D

# warning-ignore-all:RETURN_VALUE_DISCARDED 

# Emit when projectile hit a body
signal on_projectile_hit(projectile, body)

# Bullet _speed
var _speed := 200.0

# Bullet life span duration
var _life_span := 3.0

# Life span timer
var _life_span_timer: Timer = null

# Bullet travel direction
var _direction: Vector2 = Vector2.ZERO

# Hit damage
var _hit_damage: HitDamage = null

# Penetration chance
var _penetration_chance: float = 0.0

# Skill that shoot this projectile
var _skill: Skill = null

# Projectile's current velocity
var _velocity: Vector2 = Vector2.ZERO

# Bodies to ignored by projectile
var _ignored_bodies: Array = []

## Getter Setter ##
func set_life_span(value:float) -> void:
    if not is_inside_tree() or not _life_span_timer:
        yield(self, "ready")
    _life_span = value
    _life_span_timer.start(_life_span)
## Getter Setter ##



## Override ##
func _ready() -> void:
    _life_span_timer = Timer.new()
    _life_span_timer.name = "LifeSpanTimer"
    add_child(_life_span_timer)
    _life_span_timer.one_shot = true
    _life_span_timer.connect("timeout", self, "queue_free")

    connect("body_entered", self, "_on_projectile_hit_body")

func _exit_tree() -> void:
    if _life_span_timer:
        _life_span_timer.disconnect("timeout", self, "queue_free")
        
func _physics_process(delta: float) -> void:
    _move_projectile(delta)
## Override ##


# Setup projectile
# Call this in order to setup projectile
##
# `skill` the skill fire this projectile
# `direction` the direction this projectile is flying
# `position` global position this projectile start
# `speed` projectile speed 
func setup(skill:Skill, direction:Vector2, position:Vector2, speed:float, 
        hit_damage:HitDamage, life_span:float, penetration:float) -> void:
    if not is_inside_tree():
        yield(self, "ready")
    
    _skill = skill
    _direction = direction
    global_position = position
    _speed = speed
    _hit_damage = hit_damage
    _life_span = life_span
    _penetration_chance = penetration

    # start life span timer
    _life_span_timer.start(_life_span)

# Move projectile
##
# Move projectile straight line direction by default
# or subclass override to behave differently
func _move_projectile(delta:float) -> void:
    _velocity = _direction.normalized() * _speed * delta
    global_rotation = _direction.angle()
    global_position += _velocity

# Can this projectile penetrate the target
func _is_penetrated() -> bool:
    if is_equal_approx(_penetration_chance, 0.0): return false
    
    # check if penetrated
    return Utils.is_in_threshold(_penetration_chance, 0.0001, 1.0)

# Return a normalized projectile's direction
func get_projectile_direction() -> Vector2:
    return _direction.normalized()

func add_ignored_bodies(bodies:Array) -> void:
    for body in bodies:
        if body is Node:
            _ignored_bodies.append(body)
        else:
            assert(false, "%s can not be added as it is not a Node" % body.name)

# Call when this projectile hit a physics body
func _on_projectile_hit_body(body:Node) -> void:
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