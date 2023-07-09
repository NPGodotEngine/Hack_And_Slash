# A generice class for weapon
# Any weapons must subclass of this class
# and implement execute method then call
# reload method at right time to 
# begin reloading process
tool 
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


# Weapon attributes resource
export(Resource) var weapon_attributes:Resource = null setget set_weapon_attributes
export(NodePath) var ranged_damage: NodePath
export(NodePath) var critical: NodePath

onready var _ranged_damage: RangedDamageComponent = get_node(ranged_damage) as RangedDamageComponent
onready var _critical: CriticalComponent = get_node(critical) as CriticalComponent


# Weapon manager manage this weapon
var weapon_manager = null


## Getter Setter ##


func set_weapon_attributes(value:Resource) -> void:
	if value == null or not value is WeaponAttributes:
		push_error("Unable to apply weapon attributes")
		return

	yield(self, "ready")
	weapon_attributes = value
	apply_weapon_attributes(value)
	
## Getter Setter ## 



func _get_configuration_warning() -> String:
	if ranged_damage.is_empty():
		return "ranged_damage node path is missing"
	if not get_node(ranged_damage) is RangedDamageComponent:
		return "ranged_damage must be a RangedDamageComponent node"
	if critical.is_empty():
		return "critical node path is missing"
	if not get_node(critical) is CriticalComponent:
		return "critical must be a CriticalComponent node"
	if weapon_attributes:
		if not weapon_attributes is WeaponAttributes:
			return "weapon_attributes must be a WeaponAttributes resource"
	return ""

func _ready() -> void:
	if not is_inside_tree():
		yield(self, "ready")
		apply_weapon_attributes(weapon_attributes)

func _physics_process(delta: float) -> void:
	update_weapon_skin()

func queue_free() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	.queue_free()

# Call when weapon trigger is pulled
func _on_trigger_pulled() -> void:
	pass

# Get hit damage for this weapon
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

# Execute weapon
##
# `from_position` global position for weapon to shoot from
# `to_position` global position for weapon to shoot to
# `direction` for weapon's projectile to travel
func execute() -> void:
	pass

# Cancel weapon execution
##
# Specific to weapon that need to warm up
func cancel_execution() -> void:
	pass

# Execute weapon's alternative fire
##
# `from_position` global position for weapon to shoot from
# `to_position` global position for weapon to shoot to
# `direction` for weapon's projectile to travel
func execute_alt() -> void:
	pass

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

func apply_weapon_attributes(attributes:WeaponAttributes) -> void:
	print(attributes.trigger_duration)
	_ranged_damage.min_damage = attributes.min_damage
	_ranged_damage.max_damage = attributes.max_damage
	_critical.critical_chance = attributes.critical_chance
	_critical.critical_multiplier = attributes.critical_multiplier

func serialize() -> Dictionary:
	var state: Dictionary = {
		WEAPON_NAME: name,
	}
	
	return state

func deserialize(dict:Dictionary) -> void:
	pass





