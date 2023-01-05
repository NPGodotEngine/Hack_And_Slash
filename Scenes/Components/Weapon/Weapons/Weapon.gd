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

export(NodePath) var ranged_damage: NodePath
export(NodePath) var critical: NodePath

onready var _ranged_damage: RangedDamageComponent = get_node(ranged_damage)
onready var _critical: CriticalComponent = get_node(critical)

# Weapon manager manage this weapon
var weapon_manager = null



func _get_configuration_warning() -> String:
	if ranged_damage.is_empty():
		return "ranged_damage node path is missing"
	if not get_node(ranged_damage) is RangedDamageComponent:
		return "ranged_damage must be a RangedDamageComponent node"
	if critical.is_empty():
		return "critical node path is missing"
	if not get_node(critical) is CriticalComponent:
		return "critical must be a CriticalComponent node"
	return ""

func _physics_process(delta: float) -> void:
	update_weapon_skin()

# Call when weapon trigger is pulled
func _on_trigger_pulled() -> void:
	pass

# Get hit damage from weapon
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

# Inactive this weapon
func inactive() -> void:
	set_process(false)
	set_physics_process(false)



