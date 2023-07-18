class_name Projectile
extends Bullet

# warning-ignore-all:RETURN_VALUE_DISCARDED 
# warning-ignore-all:UNUSED_SIGNAL 


# Emit when projectile hit a HurtBox
signal projectile_hit(hurt_box)


# Bullet _speed
var speed := 200.0

# Bullet life span duration
var life_span := 3.0

# Bullet travel direction
var direction: Vector2 = Vector2.ZERO

# Penetration chance 0.0 ~ 1.0
var penetration_chance: float = 0.0

# Life span timer
var _life_span_timer: Timer = null

# Projectile's current velocity
var _velocity: Vector2 = Vector2.ZERO

# Bodies to ignored by projectile
var _ignored_bodies: Array = []


## Override ##
func _init() -> void:
	super._init()
	bullet_type = Global.BulletType.PROJECTILE
	
func _ready() -> void:
	if Engine.is_editor_hint(): return

	_life_span_timer = Timer.new()
	_life_span_timer.name = "LifeSpanTimer"
	add_child(_life_span_timer)
	_life_span_timer.one_shot = true
	_life_span_timer.connect("timeout", Callable(self, "queue_free"))
	super._ready()

func _exit_tree() -> void:
	if _life_span_timer:
		_life_span_timer.disconnect("timeout", Callable(self, "queue_free"))
	
	super._exit_tree()

func _process(delta: float) -> void:
	super._process(delta)

	if Engine.is_editor_hint():
		update_configuration_warnings()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if Engine.is_editor_hint(): return
	_move_projectile(delta)
	
## Override ##


# Setup projectile direction
# and send projectile to fly
##
# `from_position` global position this projectile start
# `to_position` global position this projectile will travel to
func setup_direction(from_position:Vector2, to_position:Vector2) -> void:
	global_position = from_position
	direction = (to_position - from_position).normalized()

	_start_life_span_timer() 

func _start_life_span_timer() -> void:
	if not _life_span_timer:
		await self.ready 
		# start life span timer
		_life_span_timer.start(life_span)

# Move projectile
##
# Move projectile straight line direction by default
# or subclass override to behave differently
func _move_projectile(delta:float) -> void:
	_velocity = direction.normalized() * speed * delta
	global_rotation = direction.angle()
	global_position += _velocity

# Can this projectile penetrate the target
func _is_penetrated() -> bool:
	if is_equal_approx(penetration_chance, 0.0): return false
	
	# check if penetrated
	return Global.is_in_threshold(penetration_chance, 0.0001, 1.0)

# Return a normalized projectile's direction
func get_projectile_direction() -> Vector2:
	return direction.normalized()

# Add bodies that can be ignored by this projectile
func add_ignored_bodies(bodies:Array) -> void:
	for body in bodies:
		if body is Node:
			_ignored_bodies.append(body)
		else:
			assert(false, "%s can not be added as it is not a Node" % body.name)

