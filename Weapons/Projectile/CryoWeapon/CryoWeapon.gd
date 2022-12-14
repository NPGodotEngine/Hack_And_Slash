extends ProjectileWeapon

# warning-ignore-all:RETURN_VALUE_DISCARDED

# Max projectile speed
export (float) var max_projectile_speed = (projectile_speed + 500.0) setget set_max_projectile_speed

# Acceleration curve is a CurveTexture
# that has its own defined curve and 
# CurveTexture allow curve to be defined
# in inspector
export (CurveTexture) var projectile_acc_curve

# Max angle of bullet spread both min and max
export (float) var spread_angle = 15.0

# Freeze pool scene
export (PackedScene) var _freeze_pool_scene = null

# Freeze pool speed reduction 
export (float, 0.0, 1.0) var _freeze_pool_speed_reduction = 0.5

# Freeze pool life span 
export (float) var _freeze_pool_life_span = 3.0 

# Freeze pool spawn chance
export (float, 0.0, 1.0) var _freeze_pool_spawn_chance = 0.1

# Fire interval
export (float) var fire_interval = 0.3

# Critical strike component
onready var _critical_strike_comp: CriticalStrikeComp = $CriticalStrikeComp

# Fire interval timer
var _fire_interval_timer: Timer

# How many bullets left to shoot
var _bullet_left: int = 0

# Is in fire interval
var _is_in_interval: bool = false

var _shoot_direction: Vector2
var _shoot_position: Vector2

## Getter Setter ##
func set_max_projectile_speed(value:float) -> void:
	# make sure we have at least equal to projectile basic speed
	max_projectile_speed = max(projectile_speed, value)
## Getter Setter ##


## Override ##
func _ready() -> void:
	._ready()
	# setup fire interval timer
	_fire_interval_timer = Timer.new()
	add_child(_fire_interval_timer)
	_fire_interval_timer.one_shot = true
	_fire_interval_timer.connect("timeout", self, "_on_fire_a_projectile")

func setup() -> void:
	.setup()

	# refill bullet
	_refill_bullets()

	# add default acceleration curve if not exist
	if not projectile_acc_curve:
		projectile_acc_curve = CurveTexture.new()
		projectile_acc_curve.curve = Curve.new() 
		projectile_acc_curve.curve.add_point(Vector2(0.0, 0.1))
		projectile_acc_curve.curve.add_point(Vector2(0.7, 1.0))

func execute(position:Vector2, direction:Vector2) -> void:
	.execute(position, direction)

	# make first shot
	if not _is_in_interval:
		_shoot_direction = direction.normalized()
		_shoot_position = position
		_on_fire_a_projectile()

func get_hit_damage() -> HitDamage:
	var is_critical: bool = _critical_strike_comp.is_critical()

	return HitDamage.new().init(
		get_parent().get_manager_owner(),
		self,
		get_damage_output(),
		is_critical,
		_critical_strike_comp.critical_strike_multiplier,
		Color.white if not is_critical else Color.red
	)

func _on_reloading_timer_timeout() -> void:
	._on_reloading_timer_timeout()

	# refill bullet
	_refill_bullets()
## Override ##

# Call to shoot one or many bullets in one succession
# This will also be called from fire interval timer
func _on_fire_a_projectile():
	# shoot bullet if we have bullet left
	if _bullet_left > 0:
		_shoot_bullet()

		# decrease bullet
		_bullet_left -= 1
		_bullet_left = int(min(max(0, _bullet_left), self.projectile_count))
	
	# no bullet left to shoot
	if _bullet_left == 0:
		_is_in_interval = false
		# start reloading if no bullets left
		start_reloading()
		_fire_interval_timer.stop()
	else:
		# have bullet left then wait until next shot
		_is_in_interval = true
		_fire_interval_timer.stop()
		_fire_interval_timer.start(fire_interval)

# Shoot one bullet
func _shoot_bullet() -> void:
	# get random spread direction
	var spread_direction = get_random_spread_direction(_shoot_direction, spread_angle)

	# shoot projectile
	var bullet: CryoBullet = projectile_scene.instance()
	get_tree().current_scene.call_deferred("add_child", bullet)
	bullet.setup(self, spread_direction, _shoot_position, projectile_speed,
		get_hit_damage(), projectile_life_span, projectile_penetration_chance)
	bullet.configure_movement(projectile_acc_curve.curve, max_projectile_speed)
	bullet.connect("on_projectile_hit", self, "_on_projectile_hit")

# Refill bullets
func _refill_bullets() -> void:
	_bullet_left = self.projectile_count

func _on_projectile_hit(_projectile:CryoBullet, body:Node) -> void:
	assert(_freeze_pool_scene, "freeze_pool_scene is null")

	if _freeze_pool_scene and can_spawn_freeze_pool():
		var freeze_pool: FreezePool = _freeze_pool_scene.instance()
		get_tree().current_scene.call_deferred("add_child", freeze_pool)
		freeze_pool.setup(_freeze_pool_life_span, _freeze_pool_speed_reduction)
		freeze_pool.global_position = body.global_position

func can_spawn_freeze_pool() -> bool:
	if is_equal_approx(_freeze_pool_spawn_chance, 0.0): return false
	return Utils.is_in_threshold(_freeze_pool_spawn_chance, 0.0001, 1.0)

# Return a vector2 with random direction in spread angle
##
# `face_direction` current face direction
# `spread_angle_deg` spread angle left or right in degree
func get_random_spread_direction(face_direction:Vector2, spread_angle_deg:float) -> Vector2:
	var dir_norm: Vector2 = face_direction.normalized()
	var min_spread_radian: float = (deg2rad(spread_angle_deg) if spread_angle_deg < 0.0 
																else -deg2rad(spread_angle_deg))
	var max_spread_radian: float = (-deg2rad(spread_angle_deg) if spread_angle_deg < 0.0 
																else deg2rad(spread_angle_deg))
	var random_radian: float = rand_range(min_spread_radian, max_spread_radian)
	return dir_norm.rotated(random_radian)

