class_name Projectile
extends Bullet

# warning-ignore-all:RETURN_VALUE_DISCARDED 
# warning-ignore-all:UNUSED_SIGNAL 
# warning-ignore-all:UNUSED_ARGUMENT 


# Emit when projectile hit a HurtBox
signal projectile_hit(hurt_box)


# Bullet _speed
var _speed := 200.0

# Bullet life span duration
var _life_span := 3.0

# Life span timer
var _life_span_timer: Timer = null

# Bullet travel direction
var _direction: Vector2 = Vector2.ZERO

# Penetration chance 0.0 ~ 1.0
var _penetration_chance: float = 0.0

# Projectile's current velocity
var _velocity: Vector2 = Vector2.ZERO

# Bodies to ignored by projectile
var _ignored_bodies: Array = []


## Override ##
func _init() -> void:
    ._init()
    bullet_type = Global.BulletType.PROJECTILE
    
func _ready() -> void:
    if Engine.editor_hint: return

    _life_span_timer = Timer.new()
    _life_span_timer.name = "LifeSpanTimer"
    add_child(_life_span_timer)
    _life_span_timer.one_shot = true
    _life_span_timer.connect("timeout", self, "queue_free")

func _exit_tree() -> void:
    if _life_span_timer:
        _life_span_timer.disconnect("timeout", self, "queue_free")

func _process(delta: float) -> void:
    if Engine.editor_hint:
        update_configuration_warning()

func _physics_process(delta: float) -> void:
    if Engine.editor_hint: return
    _move_projectile(delta)
## Override ##


# Setup projectile
# Call this in order to setup projectile
##
# `from_position` global position this projectile start
# `to_position` global position this projectile will travel to
# `speed` projectile speed
# `hit_damage` `HitDamage` this projectile will use
# `life_span` How long this projectile will live
# `penetration` penetration chance for this projectile 0.0 ~ 1.0
func setup(from_position:Vector2, to_position:Vector2, speed:float, 
        hit_damage:HitDamage, life_span:float, penetration_chance:float) -> void:
    global_position = from_position
    _direction = (to_position - from_position).normalized() 
    _speed = speed
    _life_span = life_span
    _penetration_chance = penetration_chance
    hit_damage = hit_damage

    if not _life_span_timer:
        yield(self, "ready") 
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
    return Global.is_in_threshold(_penetration_chance, 0.0001, 1.0)

# Return a normalized projectile's direction
func get_projectile_direction() -> Vector2:
    return _direction.normalized()

# Add bodies that can be ignored by this projectile
func add_ignored_bodies(bodies:Array) -> void:
    for body in bodies:
        if body is Node:
            _ignored_bodies.append(body)
        else:
            assert(false, "%s can not be added as it is not a Node" % body.name)

