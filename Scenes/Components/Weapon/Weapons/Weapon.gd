# A generice class for weapon
# Any weapons must subclass of this class
# and implement execute method then call
# reload method at right time to 
# begin reloading process
@tool 
class_name Weapon
extends Node2D

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT


const WEAPON_NAME = "name"


# Emit when weapon become active
##
# `weapon`: weapon of itself
signal weapon_active(weapon)

# Emit when weapon become inactive
##
# `weapon`: weapon of itself
signal weapon_inactive(weapon)

# Emit when weapon attributes updated
# successful
##
# `weapon`: weapon of itself
signal weapon_attributes_updated(weapon)


# Weapon attributes resource
@export var weapon_attributes: Resource = null: set = set_weapon_attributes


## Weapon manager manage this weapon
var weapon_manager = null

## weapon's primary fire position
var current_fire_position: Vector2 = Vector2.ZERO

## Weapon's alt fire position
var current_alt_fire_position: Vector2 = Vector2.ZERO


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
	pass

func _process(_delta:float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	update_weapon_skin()

# func queue_free() -> void:
# 	for child in get_children():
# 		remove_child(child)
# 		child.queue_free()
# 	super.queue_free()

# Get hit damage for this weapon
func get_hit_damage() -> HitDamage:
	return null

## Execute weapon
##
## `fire_at`: the global position bullet will travel to
func execute(fire_at:Vector2) -> void:
	current_fire_position = fire_at

# Cancel weapon execution
##
# Specific to weapon that need to warm up
func cancel_execution() -> void:
	pass

## Execute weapon's alternative fire
##
## `fire_at`: the global position bullet will travel to
func execute_alt(fire_at:Vector2) -> void:
	current_alt_fire_position = fire_at

# Cancel weapon's alternative fire execution
##
# Specific to weapon that need to warm up
func cancel_alt_execution() -> void:
	pass

# Called when weapon skin
# need to update
func update_weapon_skin() -> void:
	pass

# Active this weapon
func active() -> void:
	set_process(true)
	set_physics_process(true)
	
	emit_signal("weapon_active", self)

# Inactive this weapon
func inactive() -> void:
	set_process(false)
	set_physics_process(false)

	emit_signal("weapon_inactive", self)

# Apply weapon attributes
# subclass must call this at parent class
# at end of code
func apply_weapon_attributes(_attributes:WeaponAttributes) -> void:
	emit_signal("weapon_attributes_updated", self)

func serialize() -> Dictionary:
	var state: Dictionary = {
		WEAPON_NAME: name,
	}
	
	return state

func deserialize(_dict:Dictionary) -> void:
	pass





