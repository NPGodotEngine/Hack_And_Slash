# A generice class for weapon
# Any weapons must subclass of this class
# and implement execute method then call
# reload method at right time to 
# begin reloading process
tool 
class_name Weapon
extends Component

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT

onready var weapon_receiver: WeaponReceiver = (get_weapon_receiver()) setget set_weapon_receiver, get_weapon_receiver

# Weapon trigger module
onready var trigger: Trigger = (get_trigger()) setget set_trigger, get_trigger

# Weapon ammo module
onready var ammo: Ammo = (get_ammo()) setget set_ammo, get_ammo


# Weapon skin
##
# Skin for weapon visual
onready var weapon_appearance: WeaponSkinManager = (get_weapon_appearance()) setget set_weapon_appearance, get_weapon_appearance

# List of weapon modules
##
# Setting this value does nothing 
var weapon_modules: Array = [] setget no_set, get_weapon_modules

# Return weapon's total damage output
# The minimum is 10% of weapon's damage
##
# Weapon's receiver damage * multiplier from all weapon modules
# Multiplier is capped between 0.1 ~ 1.0
##
# Setting this value does nothing
var weapon_damage: int = 0 setget no_set, get_weapon_damage

# Return weapon's total accuracy in between
# 0.0 ~ 1.0
##
# Weapon's receiver accuracy + accuracy from all weapon modules
##
# Setting this value does nothing
var weapon_accuracy: float = 0.0 setget no_set, get_weapon_accuracy

# Weapon manager manage this weapon
var weapon_manager = null


## Getter Setter ##


func no_set(value):
	push_warning("no set property")

func get_weapon_damage() -> int:
	var receiver_damage: int = weapon_receiver.damage 

	var multiplier: float = calculate_modules_dmg_multiplier()
	multiplier = min(max(0.1, multiplier), 1.0)

	if is_equal_approx(multiplier, 0.0):
		return receiver_damage

	return int(receiver_damage * multiplier)

func get_weapon_accuracy() -> float:
	var receiver_accuracy: float = weapon_receiver.accuracy

	var mod_accuracy: float = calculate_modules_accuracy_multiplier()
	var acc = receiver_accuracy + mod_accuracy
	acc = min(max(0.0, acc), 1.0)

	return acc

func get_weapon_receiver() -> WeaponReceiver:
	for node in get_children():
		if node is WeaponReceiver:
			return node
	var new_receiver = load("res://Components/Weapons/WeaponReceiver/WeaponReceiverBlueprint.tscn").instance()
	add_child(new_receiver)
	new_receiver.owner = self
	return new_receiver

func set_weapon_receiver(new_receiver:WeaponReceiver) -> void:
	if weapon_receiver:
		weapon_receiver.remove_from_parent()
	weapon_receiver = new_receiver
	add_child(weapon_receiver)

func get_trigger() -> Trigger:
	for node in get_children():
		if node is Trigger:
			return node
	var new_trigger = load("res://Components/Weapons/WeaponModules/TriggerModules/AutoTriggerBlueprint.tscn").instance()
	add_child(new_trigger)
	new_trigger.owner = self
	return new_trigger

func set_trigger(new_trigger:Trigger) -> void:
	if trigger:
		trigger.remove_from_parent()
	trigger = new_trigger
	add_child(trigger)

func get_ammo() -> Ammo:
	for node in get_children():
		if node is Ammo:
			return node
	var new_ammo = load("res://Components/Weapons/WeaponModules/AmmoModules/AmmoBlueprint.tscn").instance()
	add_child(new_ammo)
	new_ammo.owner = self
	return new_ammo

func set_ammo(new_ammo:Ammo) -> void:
	if ammo:
		ammo.remove_from_parent()
	ammo = new_ammo
	add_child(new_ammo)

func get_weapon_appearance() -> WeaponSkinManager:
	for node in get_children():
		if node is WeaponSkinManager:
			return node
	var new_weapon_skin = load("res://Components/Weapons/WeaponSkin/WeaponSkinBlueprint.tscn").instance()
	add_child(new_weapon_skin)
	new_weapon_skin.owner = self
	return new_weapon_skin

func set_weapon_appearance(new_weapon_appearance:WeaponSkinManager) -> void:
	if weapon_appearance:
		weapon_appearance.remove_from_parent()
	weapon_appearance = new_weapon_appearance
	add_child(weapon_appearance)

func get_weapon_modules() -> Array:
	return [
		get_trigger(),
		get_ammo(),

	]

## Getter Setter ##

## Override ##
func _get_configuration_warning() -> String:

	if get_weapon_receiver() == null:
		return "Weapon must have a component WeaponReceiver"
	
	if get_module_by_type(Global.WeaponModuleType.TRIGGER) == null:
		return "Weapon must have 1 trigger module"
	if get_module_by_type(Global.WeaponModuleType.AMMO) == null:
		return "Weapon must have 1 ammo module"

	if get_weapon_appearance() == null:
		return "Weapon must have a component as child with name WeaponSkin script"

	return ""

func setup() -> void:
	.setup()

	assert(weapon_manager, "Weapon %s is not held by a WeaponManager" % name)

	assert(weapon_receiver, "Weapon requried a weapon receiver")

	assert(get_module_by_type(Global.WeaponModuleType.TRIGGER), 
	"Weapon required a trigger module as child")
	assert(get_module_by_type(Global.WeaponModuleType.AMMO), 
	"Weapon required a ammo module as child")

	assert(weapon_appearance, 
	"Weapon required a weapon skin compoent as child with name \"WeaponSkin\"")

	_setup_weapon_receiver()
	_setup_trigger()
	_setup_ammo()
	_setup_weapon_appearance()


func _setup_trigger() -> void:
	trigger.setup()
	if not trigger.is_connected("trigger_pulled", self, "_on_trigger_pulled"):
		trigger.connect("trigger_pulled", self, "_on_trigger_pulled")

func _setup_ammo() -> void:
	ammo.setup()
	if not ammo.is_connected("ammo_depleted", self, "_on_ammo_depleted"):
		ammo.connect("ammo_depleted", self, "_on_ammo_depleted")
	if not ammo.is_connected("ammo_count_changed", self, "_on_ammo_count_changed"):
		ammo.connect("ammo_count_changed", self, "_on_ammo_count_changed")
	if not ammo.is_connected("begin_reloading", self, "_on_ammo_begin_reloading"):
		ammo.connect("begin_reloading", self, "_on_ammo_begin_reloading")
	if not ammo.is_connected("end_reloading", self, "_on_ammo_end_reloading"):
		ammo.connect("end_reloading", self, "_on_ammo_end_reloading")

func _setup_weapon_receiver() -> void:
	weapon_receiver.setup()

func _setup_weapon_appearance() -> void:
	weapon_appearance.setup()
	
## Override ##


# Get weapon module by type, return null if not found
##
# `mod_type` `WeaponModule` in Global.gd
func get_module_by_type(mod_type:int) -> WeaponModule:
	var mods: Array = get_weapon_modules()
	for i in mods.size():
		var mod = mods[i] as WeaponModule
		if mod.module_type & mod_type:
			return mod
	return null

# Return damage from combination of all modules
func calculate_modules_dmg_multiplier() -> float:
	var dmg_multiplier: float = 0.0
	var mods: Array = get_weapon_modules()

	for i in mods.size():
		var mod:WeaponModule = mods[i]
		if mod:
			dmg_multiplier += mod.damage_multiplier
	
	return dmg_multiplier

# Return accuracy from combination of all modules
func calculate_modules_accuracy_multiplier() -> float:
	var total_acc: float = 0.0
	var mods: Array = get_weapon_modules()

	for i in mods.size():
		var mod:WeaponModule = mods[i]
		if mod:
			total_acc += mod.accuracy_multiplier
	
	return total_acc

# Get hit damage from weapon
func get_hit_damage() -> HitDamage:
	var damage: int = get_weapon_damage()
	var critical: bool = weapon_receiver.is_critical
	var color: Color = (weapon_receiver.critical_color if critical 
										else weapon_receiver.damage_color)
	var hit_damage: HitDamage = HitDamage.new().init(
		weapon_manager.get_manager_owner(),
		self,
		damage,
		critical,
		weapon_receiver.critical_multiplier,
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


# Active this weapon
func active() -> void:
	pass

# Inactive this weapon
func inactive() -> void:
	pass

func _on_trigger_pulled() -> void:
	print("trigger pulled")
	pass

func _on_ammo_depleted(ammo_count:int, round_per_clip:int) -> void:
	print("ammo depleted %d %d" % [ammo_count, round_per_clip])
	pass

func _on_ammo_count_changed(ammo_count:int, round_per_clip:int) -> void:
	print("ammo count changed %d %d" % [ammo_count, round_per_clip])
	pass

func _on_ammo_begin_reloading(ammo_count:int, round_per_clip:int) -> void:
	print("begin reloading %d %d" % [ammo_count, round_per_clip])
	pass

func _on_ammo_end_reloading(ammo_count:int, round_per_clip:int) -> void:
	print("end reloading %d %d" % [ammo_count, round_per_clip])
	pass


func to_dictionary() -> Dictionary:
	var state: Dictionary = .to_dictionary()

	var sub_node_states: Dictionary = state[SUB_NODE_STATE_KEY]
	sub_node_states["weapon_receiver"] = weapon_receiver.to_dictionary()
	sub_node_states["trigger_mod"] = trigger.to_dictionary()
	sub_node_states["ammo_mod"] = ammo.to_dictionary()
	sub_node_states["appearance"] = weapon_appearance.to_dictionary()

	return state

func from_dictionary(state:Dictionary) -> void:
	.from_dictionary(state)
	
	var sub_node_states: Dictionary = state[SUB_NODE_STATE_KEY]

	var receiver: WeaponReceiver = Global.create_instance(sub_node_states["weapon_receiver"][RESOURCE_NAME_KEY])
	set_weapon_receiver(receiver)
	receiver.from_dictionary(sub_node_states["weapon_receiver"])

	var trigger_mod: Trigger = Global.create_instance(sub_node_states["trigger_mod"][RESOURCE_NAME_KEY])
	set_trigger(trigger_mod)
	trigger_mod.from_dictionary(sub_node_states["trigger_mod"])

	var ammo_mod: Ammo = Global.create_instance(sub_node_states["ammo_mod"][RESOURCE_NAME_KEY])
	set_ammo(ammo_mod)
	ammo_mod.from_dictionary(sub_node_states["ammo_mod"])

	var appearance: WeaponSkinManager = Global.create_instance(sub_node_states["appearance"][RESOURCE_NAME_KEY])
	set_weapon_appearance(appearance)
	appearance.from_dictionary(sub_node_states["appearance"])


