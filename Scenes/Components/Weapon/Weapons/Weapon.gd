## A generice class for weapon
## Any weapons must subclass of this class
## and implement execute method then call
## reload method at right time to 
## begin reloading process
@tool 
class_name Weapon
extends Node2D

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT


const WEAPON_NAME = "name"


## Emit when weapon become active
##
## `weapon`: weapon of itself
signal weapon_active(weapon)

## Emit when weapon become inactive
##
## `weapon`: weapon of itself
signal weapon_inactive(weapon)

## Emit when weapon attributes updated
## successful
##
## `weapon`: weapon of itself
signal weapon_attributes_updated(weapon)


## Weapon attributes resource
@export var weapon_attributes: Resource = null: set = set_weapon_attributes

## `true` weapon will pointat specific position
## smoothly
@export var point_at_interpolate: bool = true

## How fast this weapon point at specific position
@export_range(0.01, 100.0) var point_at_speed: float = 1.0

## Weapon manager manage this weapon
var weapon_manager = null

## weapon's primary fire position
var current_fire_position: Vector2 = Vector2.ZERO

## Weapon's alt fire position
var current_alt_fire_position: Vector2 = Vector2.ZERO

## Weapon's current point at position
var weapon_point_at_position: Vector2 = Vector2.ZERO

## Tracking `weight` in `lerp_angle` function
var _lerp_angle_elapsed: float = 0.0

## Getter Setter ##


func set_weapon_attributes(value:Resource) -> void:
	if value == null or not value is WeaponAttributes:
		push_error("Unable to apply weapon attributes")
		return

	weapon_attributes = value

	if not is_inside_tree():
		await self.ready
		apply_weapon_attributes(value)
	else:
		apply_weapon_attributes(value)
	
## Getter Setter ## 



func _get_configuration_warnings() -> PackedStringArray:		
	if weapon_attributes:
		if not weapon_attributes is WeaponAttributes:
			return ["weapon_attributes must be a WeaponAttributes resource"]
	else:
		return ["a default weapon_attributes must be given"]
	return []

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	pass

func _process(_delta:float) -> void:
	if Engine.is_editor_hint():
		return
	update_weapon_skin()
	point_weapon_at(weapon_point_at_position, point_at_interpolate, point_at_speed)

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	pass

## Get hit damage for this weapon
func get_hit_damage() -> HitDamage:
	return null

## Execute weapon
##
## `fire_at`: the global position bullet will travel to
func execute(fire_at:Vector2) -> void:
	current_fire_position = fire_at

## Cancel weapon execution
##
## Specific to weapon that need to warm up
func cancel_execution() -> void:
	pass

## Execute weapon's alternative fire
##
## `fire_at`: the global position bullet will travel to
func execute_alt(fire_at:Vector2) -> void:
	current_alt_fire_position = fire_at

## Cancel weapon's alternative fire execution
##
## Specific to weapon that need to warm up
func cancel_alt_execution() -> void:
	pass

## Called when weapon skin
## need to update
func update_weapon_skin() -> void:
	pass

## Update weapon facing direction
##
## `at_position`: global position
## `interpolate`: `true` weapon will be rotated and point at position
## smoothly
## `interpolate_speed`: how fast the weapon can be rotated and poit at position
func point_weapon_at(at_position:Vector2, interpolate:bool=true, interpolate_speed:float=1.0) -> void:
	if at_position == null:
		return

	# Update weapon facing direction
	if at_position.x < global_position.x:
		self.scale.y = -1.0 * self.scale.abs().y
	else:
		self.scale.y = 1.0 * self.scale.abs().y

	# rotate weapon and point at position	
	var current_rot: float = global_rotation
	var target_rot: float = current_rot + get_angle_to(at_position)

	# if rotation is the same
	if is_equal_approx(current_rot, target_rot):
		_lerp_angle_elapsed = 0.0
		return

	# lerp rotation
	if interpolate:
		global_rotation = lerp_angle(current_rot, target_rot, clampf(_lerp_angle_elapsed, 0.0, 1.0))
		_lerp_angle_elapsed += get_process_delta_time() * interpolate_speed
	else:
		global_rotation = lerp_angle(current_rot, target_rot, 1.0)

## Active this weapon
func active() -> void:
	set_process(true)
	set_physics_process(true)
	
	emit_signal("weapon_active", self)

## Inactive this weapon
func inactive() -> void:
	set_process(false)
	set_physics_process(false)

	emit_signal("weapon_inactive", self)

## Apply weapon attributes
## subclass must call this at parent class
## at end of code
func apply_weapon_attributes(_attributes:WeaponAttributes) -> void:
	emit_signal("weapon_attributes_updated", self)

## Serialize weapon data
func serialize() -> Dictionary:
	var state: Dictionary = {
		WEAPON_NAME: name,
	}
	
	return state

## Deserialize weapon data 
func deserialize(_dict:Dictionary) -> void:
	pass





