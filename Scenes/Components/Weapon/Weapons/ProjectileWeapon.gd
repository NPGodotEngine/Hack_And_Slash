tool
class_name ProjectileWeapon
extends Weapon

# warning-ignore-all: RETURN_VALUE_DISCARDED

export(NodePath) var accuracy: NodePath
export(NodePath) var ranged_damage: NodePath
export(NodePath) var critical: NodePath
export(NodePath) var angle_spread: NodePath
export(NodePath) var trigger: NodePath
export(NodePath) var ammo: NodePath
export(Array, NodePath) var fire_points: Array
export(NodePath) var muzzle_flash: NodePath
export(float) var muzzle_flash_duration: float = 0.1

onready var _accuracy: AccuracyComponent = get_node(accuracy) as AccuracyComponent
onready var _ranged_damage: RangedDamageComponent = get_node(ranged_damage) as RangedDamageComponent
onready var _critical: CriticalComponent = get_node(critical) as CriticalComponent
onready var _angle_spread: AngleSpreadComponent = get_node(angle_spread) as AngleSpreadComponent
onready var _trigger: Trigger = get_node(trigger) as Trigger
onready var _ammo: Ammo = get_node(ammo) as Ammo
onready var _fire_points: Array = get_fire_points()
onready var _muzzle_flash: MuzzleFlash = get_node(muzzle_flash) as MuzzleFlash


	

func _get_configuration_warning() -> String:
	var warning =  ._get_configuration_warning()
	if warning != "":
		return warning
	
	if accuracy.is_empty():
		return "accuracy node path is missing"
	if not get_node(accuracy) is AccuracyComponent:
		return "accuracy must be a AccuracyComponent node"
	if angle_spread.is_empty():
		return "angle_spread node path is missing"
	if not get_node(angle_spread) is AngleSpreadComponent:
		return "angle_spread must be a AngleSpreadComponent node"
	if trigger.is_empty():
		return "trigger node path is missing"
	if not get_node(trigger) is Trigger:
		return "trigger must be a Trigger node"
	if ammo.is_empty():
		return "ammo node path is missing"
	if not get_node(ammo) is Ammo:
		return "ammo must be a Ammo node"
	if fire_points.size() == 0:
		return "at least 1 node path in fire_points"
	for point in get_fire_points():
		if not point is Position2D:
			return "fire_points must contain Position2D node"
	if muzzle_flash.is_empty():
		return "muzzle_flash node path is missing"
	if not get_node(muzzle_flash) is MuzzleFlash:
		return "muzzle_flash must be a MuzzleFlash node"
	if ranged_damage.is_empty():
		return "ranged_damage node path is missing"
	if not get_node(ranged_damage) is RangedDamageComponent:
		return "ranged_damage must be a RangedDamageComponent node"
	if critical.is_empty():
		return "critical node path is missing"
	if not get_node(critical) is CriticalComponent:
		return "critical must be a CriticalComponent node"
	return ""

func _ready() -> void:
	_trigger.connect("trigger_pulled", self, "_on_trigger_pulled")

	if weapon_attributes:
		if not is_inside_tree():
			yield(self, "ready")
			apply_weapon_attributes(weapon_attributes)
		else:
			apply_weapon_attributes(weapon_attributes)

func _on_trigger_pulled() -> void:
	if not _ammo is ProjectileAmmo:
		push_error("Ammo is not a type of ProjectileAmmo")
		return

	var projectile_ammo: ProjectileAmmo = _ammo as ProjectileAmmo

	for point in _fire_points:
		if _ammo._is_reloading:
			return
		var position = (point as Position2D).global_position
		var global_mouse_position = get_global_mouse_position()
		var distance: float = position.distance_to(global_mouse_position)
		var end_position = _angle_spread.get_random_spread(global_position.direction_to(global_mouse_position), 
												_accuracy.accuracy) * distance + position
		var hit_damage: HitDamage = get_hit_damage()
		var bullet: Projectile = projectile_ammo.consume_ammo()
		bullet.hit_damage = hit_damage
		bullet.show_behind_parent = true
		Global.add_to_scene_tree(bullet)
		bullet.setup_direction(position, end_position)

		puff_muzzle_flash()

func puff_muzzle_flash() -> void:
	_muzzle_flash.flash(muzzle_flash_duration, 1|2|4)

func update_weapon_skin() -> void:
	if Engine.editor_hint:
		return 
	# Update weapon facing direction
	var global_mouse_position := get_global_mouse_position()
	
	if global_mouse_position.x < global_position.x:
		self.scale.y = -1.0 * self.scale.abs().y
	else:
		self.scale.y = 1.0 * self.scale.abs().y
	
	look_at(global_mouse_position)

func get_hit_damage() -> HitDamage:
	var damage: float = _ranged_damage.damage
	var is_critical: bool = _critical.is_critical()
	var color: Color = (_critical.critical_color if is_critical 
							else _ranged_damage.damage_color)
	var hit_damage: HitDamage = HitDamage.new().init(
		weapon_manager.get_parent(),
		self,
		damage,
		is_critical,
		_critical.critical_multiplier,
		color
	)

	return hit_damage

func get_fire_points() -> Array:
	var points: Array = []
	for node_path in fire_points:
		points.append(get_node(node_path))
	return points

func execute() -> void:
	_trigger.pull_trigger()

func cancel_execution() -> void:
	pass

func execute_alt() -> void:
	pass

func cancel_alt_execution() -> void:
	pass

func active() -> void:
	.active()
	self.show()

func inactive() -> void:
	.inactive()
	self.hide()

func apply_weapon_attributes(attributes:WeaponAttributes) -> void:
	_ranged_damage.min_damage = attributes.min_damage
	_ranged_damage.max_damage = attributes.max_damage
	_critical.critical_chance = attributes.critical_chance
	_critical.critical_multiplier = attributes.critical_multiplier
	_accuracy.accuracy = attributes.accuracy
	_trigger.trigger_duration = attributes.trigger_duration
	_ammo.reload_duration = attributes.reload_duration
	_ammo.rounds_per_clip = attributes.round_per_clip

	.apply_weapon_attributes(attributes)

