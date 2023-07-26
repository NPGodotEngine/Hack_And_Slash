extends ActionLeaf

## `true` to use smart shooting
## AI will not shoot at target position
## instead it will shoot at predicted position
## base on target movement direction
@export var predict_movement: bool = true

## How much the min leading distance in pixel should
## AI shoot at from target position
@export_range(0.0, 100.0) var min_leading_in_px: float = 0.0

## How much the max leading distance in pixel should
## AI shoot at from target position
@export_range(0.0, 100.0) var max_leading_in_px: float = 30.0

## AI will fire its weapon when rotation between weapon and 
## desired position smaller or equal to this threshold
@export_range(0.0, 90.0) var aiming_angle_threshold: float = 10.0

@onready var weapon: Weapon = get_node_or_null("%WeaponPlaceholder").get_child(0)
@onready var vision_area: Area2D = get_node_or_null("%Vision/VisionConeArea")

var ammo: Ammo
var trigger: Trigger 

func _ready() -> void:
	if min_leading_in_px > max_leading_in_px:
		min_leading_in_px = max_leading_in_px

	for child in weapon.get_children():
		if child is Ammo:
			ammo = child
		if child is Trigger:
			trigger = child

func tick(_actor:Node, blackboard:Blackboard) -> int:
	var is_dead: bool = blackboard.get_value(EnemyBlackboard.IS_DEAD)
	
	if is_dead:
		return FAILURE

	if not weapon:
		return FAILURE

	var target: Player = blackboard.get_value(EnemyBlackboard.PLAYER_TARGET)

	if target == null:
		return FAILURE
	
	# make sure target is in sight
	var target_in_sight = false
	for body in vision_area.get_overlapping_bodies():
		if body == target:
			target_in_sight = true
			break
	if not target_in_sight:
		return FAILURE
	
	var movement_comp: MovementComponent
	for child in target.get_children():
		if child is MovementComponent:
			movement_comp = child
			break
	
	var desired_position: Vector2 = target.global_position
	
	# predicting player movement and position
	if predict_movement:
		var target_movement_dir: Vector2 = movement_comp._velocity.normalized()
		randomize()
		var leading_in_px: float = randf_range(min_leading_in_px, max_leading_in_px)
		desired_position = desired_position + target_movement_dir * leading_in_px
	
	# point weapon at position
	weapon.weapon_point_at_position = desired_position
	
	# if weapon point at target position
	var current_rot: float = weapon.global_rotation
	var target_rot: float = current_rot + weapon.get_angle_to(desired_position)
	if abs(target_rot - current_rot) <= deg_to_rad(aiming_angle_threshold):
		if trigger._is_trigger_ready && ammo._round_left > 0:
			weapon.execute(desired_position)
			return RUNNING

	return RUNNING
