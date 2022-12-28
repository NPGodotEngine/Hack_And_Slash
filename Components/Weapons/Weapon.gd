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

# Damage component
onready var damage_comp: DamageComp = (get_damage_comp()) setget set_damage_comp, get_damage_comp

# Accuracy component
onready var accuracy_comp: AccuracyComp = (get_accuracy_comp()) setget set_accuracy_comp, get_accuracy_comp

# Critical strike component
onready var critical_strike_comp: CriticalStrikeComp = (get_critical_strike_comp()) setget set_critical_strike_comp, get_critical_strike_comp

# Weapon stock attachment
onready var stock: Stock = (get_stock()) setget set_stock, get_stock

# Weapon trigger attachment
onready var trigger: Trigger = (get_trigger()) setget set_trigger, get_trigger

# Weapon ammo attachment
onready var ammo: Ammo = (get_ammo()) setget set_ammo, get_ammo

# Weapon barrel attachment
onready var barrel: Barrel = (get_barrel()) setget set_barrel, get_barrel

var alt: Attachment = null

# Weapon skin
##
# Skin for weapon visual
onready var weapon_appearance: WeaponSkin = (get_weapon_appearance()) setget set_weapon_appearance, get_weapon_appearance

# List of weapon attachments 
var attachments: Array = [] setget , get_attachments

# Weapon damage
##
# Return weapon's damage * all 
# attachments' damage multiplier(cap between 0.1 ~ 1.0)
##
# The minimum of damage is 10% of weapon's damage
var weapon_damage: int = 0 setget , get_weapon_damage

# Weapon accuracy
##
# Return weapon's accuracy + all 
# attachments' accuracy and then
# cap between 0.0 ~ 1.0
var weapon_accuracy: float = 0.0 setget , get_weapon_accuracy

# Weapon manager manage this weapon
var weapon_manager = null


## Getter Setter ##



# Return weapon's total damage output
# The minimum is 10% of weapon's damage
##
# Weapon's damage * multiplier from all attachments
# Multiplier is capped between 0.1 ~ 1.0
func get_weapon_damage() -> int:
	if damage_comp == null: return 0
	var weapon_base_damage: int = damage_comp.damage
	var multiplier: float = calculate_attachments_dmg_multiplier()
	multiplier = min(max(0.1, multiplier), 1.0)

	if is_equal_approx(multiplier, 0.0):
		return weapon_base_damage
	print("%d, %f" % [weapon_base_damage, multiplier])
	return int(weapon_base_damage * multiplier)

# Return weapon's total accuracy in between
# 0.0 ~ 1.0
func get_weapon_accuracy() -> float:
	if accuracy_comp == null: return 0.0
	var weapon_base_accuracy: float = accuracy_comp.accuracy 
	var att_accuracy: float = calculate_attachments_accuracy_multiplier()
	var acc = weapon_base_accuracy + att_accuracy
	acc = min(max(0.0, acc), 1.0)

	return acc

func get_damage_comp() -> DamageComp:
	for node in get_children():
		if node is DamageComp:
			return node
	var new_dmg = load("res://Components/Damage/DamageComp.tscn").instance()
	add_child(new_dmg)
	new_dmg.owner = self
	return new_dmg

func set_damage_comp(new_damage_comp:DamageComp) -> void:
	if damage_comp:
		damage_comp.remove_from_parent()
	damage_comp = new_damage_comp
	add_child(damage_comp)

func get_accuracy_comp() -> AccuracyComp:
	for node in get_children():
		if node is AccuracyComp:
			return node
	var new_acc = load("res://Components/Accuracy/AccuracyComp.tscn").instance()
	add_child(new_acc)
	new_acc.owner = self
	return new_acc

func set_accuracy_comp(new_accuracy_comp:AccuracyComp) -> void:
	if accuracy_comp:
		accuracy_comp.remove_from_parent()
	accuracy_comp = new_accuracy_comp
	add_child(accuracy_comp)

func get_critical_strike_comp() -> CriticalStrikeComp:
	for node in get_children():
		if node is CriticalStrikeComp:
			return node
	var new_cs = load("res://Components/CriticalStrike/CriticalStrikeComp.tscn").instance()
	add_child(new_cs)
	new_cs.owner = self
	return new_cs

func set_critical_strike_comp(new_critical_strike_comp:CriticalStrikeComp) -> void:
	if critical_strike_comp:
		critical_strike_comp.remove_from_parent()
	critical_strike_comp = new_critical_strike_comp
	add_child(critical_strike_comp)

func get_stock() -> Stock:
	for node in get_children():
		if node is Stock:
			return node
	var new_stock = load("res://Components/Attachments/Stocks/DefaultStock.tscn").instance()
	add_child(new_stock)
	new_stock.owner = self
	return new_stock

func set_stock(new_stock:Stock) -> void:
	if stock:
		stock.remove_from_parent()
	stock = new_stock
	add_child(stock)

func get_trigger() -> Trigger:
	for node in get_children():
		if node is Trigger:
			return node
	var new_trigger = load("res://Components/Attachments/Triggers/DefaultTrigger.tscn").instance()
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
	var new_ammo = load("res://Components/Attachments/Ammos/DefaultAmmo.tscn").instance()
	add_child(new_ammo)
	new_ammo.owner = self
	return new_ammo

func set_ammo(new_ammo:Ammo) -> void:
	if ammo:
		ammo.remove_from_parent()
	ammo = new_ammo
	add_child(new_ammo)

func get_barrel() -> Barrel:
	for node in get_children():
		if node is Barrel:
			return node
	var new_barrel = load("res://Components/Attachments/Barrels/DefaultBarrel.tscn").instance()
	add_child(new_barrel)
	new_barrel.owner = self
	return new_barrel

func set_barrel(new_barrel:Barrel) -> void:
	if barrel:
		barrel.remove_from_parent()
	barrel = new_barrel
	add_child(barrel)

func get_weapon_appearance() -> WeaponSkin:
	for node in get_children():
		if node is WeaponSkin:
			return node
	var new_weapon_skin = load("res://Components/Weapons/WeaponSkin/WeaponSkin.tscn").instance()
	add_child(new_weapon_skin)
	new_weapon_skin.owner = self
	return new_weapon_skin

func set_weapon_appearance(new_weapon_appearance:WeaponSkin) -> void:
	if weapon_appearance:
		weapon_appearance.remove_from_parent()
	weapon_appearance = new_weapon_appearance
	add_child(weapon_appearance)

func get_attachments() -> Array:
	return [
		get_stock(),
		get_trigger(),
		get_ammo(),
		get_barrel()
	]

## Getter Setter ##

## Override ##
func _get_configuration_warning() -> String:
	if get_damage_comp() == null:
		return "Weapon must have a component as child with DamageComp script"
	
	if get_accuracy_comp() == null:
		return "Weapon must have a component as child with name AccuracyComp script"

	if get_critical_strike_comp() == null:
		return "Weapon must have a component as child with name CriticalStrikeComp script"

	if get_weapon_appearance() == null:
		return "Weapon must have a component as child with name WeaponSkin script"

	# for a in _attachments:
	# 	print(a.name)
	# 	print(a.attachment_type)
	if get_attachment_by_type(Global.AttachmentType.STOCK) == null:
		return "Weapon must have 1 stock attachment"
	if get_attachment_by_type(Global.AttachmentType.TRIGGER) == null:
		return "Weapon must have 1 trigger attachemd"
	if get_attachment_by_type(Global.AttachmentType.AMMO) == null:
		return "Weapon must have 1 ammo attachemd"
	if get_attachment_by_type(Global.AttachmentType.BARREL) == null:
		return "Weapon must have 1 barrel attachemd"

	return ""

func setup() -> void:
	.setup()

	assert(weapon_manager, "Weapon %s is not held by a WeaponManager" % name)
	assert(damage_comp, 
		"Weapon required a damage compoent as child with name \"DamageComp\"")
	assert(accuracy_comp, 
		"Weapon required a accuracy compoent as child with name \"DamageComp\"")
	assert(critical_strike_comp, 
	"Weapon required a critical strike compoent as child with name \"CriticalStrikeComp\"")
	assert(weapon_appearance, 
	"Weapon required a weapon skin compoent as child with name \"WeaponSkin\"")

	assert(get_attachment_by_type(Global.AttachmentType.STOCK), 
		"Weapon required a stock attachment as child")
	assert(get_attachment_by_type(Global.AttachmentType.TRIGGER), 
	"Weapon required a trigger attachment as child")
	assert(get_attachment_by_type(Global.AttachmentType.AMMO), 
	"Weapon required a ammo attachment as child")
	assert(get_attachment_by_type(Global.AttachmentType.BARREL), 
	"Weapon required a barrel attachment as child")

	_setup_damage_comp()
	_setup_accuracy_comp()
	_setup_critical_strike_comp()
	_setup_stock()
	_setup_trigger()
	_setup_ammo()
	_setup_barrel()
	_setup_weapon_appearance()

func _setup_stock() -> void:
	stock.setup()

func _setup_trigger() -> void:
	trigger.setup()
	trigger.connect("trigger_pulled", self, "_on_trigger_pulled")

func _setup_ammo() -> void:
	ammo.setup()
	ammo.connect("ammo_depleted", self, "_on_ammo_depleted")
	ammo.connect("ammo_count_changed", self, "_on_ammo_count_changed")
	ammo.connect("begin_reloading", self, "_on_begin_reloading")
	ammo.connect("end_reloading", self, "_on_end_reloading")

func _setup_barrel() -> void:
	barrel.setup()

func _setup_damage_comp() -> void:
	damage_comp.setup()
	damage_comp.connect("damage_changed", self, "_on_damage_changed")

func _setup_accuracy_comp() -> void:
	accuracy_comp.setup()
	accuracy_comp.connect("accuracy_changed", self, "_on_accuracy_changed")

func _setup_critical_strike_comp() -> void:
	critical_strike_comp.setup()
	critical_strike_comp.connect("critical_strike_multiplier_changed", self, "_on_critical_multiplier_changed")
	critical_strike_comp.connect("critical_strike_chance_changed", self, "_on_critical_chance_changed")
	critical_strike_comp.connect("min_critical_strike_chance_changed", self, "_on_min_critical_chance_changed")
	critical_strike_comp.connect("max_critical_strike_chance_changed", self, "_on_max_critical_chance_changed")

func _setup_weapon_appearance() -> void:
	weapon_appearance.setup()
	
## Override ##

# Get attachment by type, return null if not found
##
# `att_type` `AttachmentType` in Global.gd
func get_attachment_by_type(att_type:int) -> Attachment:
	var atts: Array = get_attachments()
	for i in atts.size():
		var att = atts[i] as Attachment
		if att.attachment_type & att_type:
			return att
	return null

# Return damage from combination of all attachments
func calculate_attachments_dmg_multiplier() -> float:
	var dmg_multiplier: float = 0.0
	var atts: Array = get_attachments()

	for i in atts.size():
		var att:Attachment = atts[i]
		if att:
			dmg_multiplier += att.damage_multiplier
	
	return dmg_multiplier

# Return accuracy from combination of all attachments
func calculate_attachments_accuracy_multiplier() -> float:
	var total_acc: float = 0.0
	var atts: Array = get_attachments()

	for i in atts.size():
		var att:Attachment = atts[i]
		if att:
			total_acc += att.accuracy_multiplier
	
	return total_acc

# Get hit damage from weapon
func get_hit_damage() -> HitDamage:
	var damage: int = get_weapon_damage()
	var critical: bool = critical_strike_comp.is_critical()
	var color: Color = (critical_strike_comp.critical_strike_color if critical 
										else damage_comp.damage_color)
	var hit_damage: HitDamage = HitDamage.new().init(
		weapon_manager.get_manager_owner(),
		self,
		damage,
		critical,
		critical_strike_comp.critical_strike_multiplier,
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

func _on_begin_reloading(ammo_count:int, round_per_clip:int) -> void:
	print("begin reloading %d %d" % [ammo_count, round_per_clip])
	pass

func _on_end_reloading(ammo_count:int, round_per_clip:int) -> void:
	print("end reloading %d %d" % [ammo_count, round_per_clip])
	pass

func _on_damage_changed(from, to) -> void:
	pass

func _on_accuracy_changed(from, to) -> void:
	pass

func _on_critical_multiplier_changed(from, to) -> void:
	pass

func _on_critical_chance_changed(from, to) -> void:
	pass

func _on_min_critical_chance_changed(from, to) -> void:
	pass

func _on_max_critical_chance_changed(from, to) -> void:
	pass

func to_dictionary() -> Dictionary:
	var state: Dictionary = .to_dictionary()

	var sub_node_states: Dictionary = {}
	sub_node_states["damage"] = damage_comp.to_dictionary()
	sub_node_states["accuracy"] = accuracy_comp.to_dictionary()
	sub_node_states["critical_strike"] = critical_strike_comp.to_dictionary()
	sub_node_states["stock_att"] = stock.to_dictionary()
	sub_node_states["trigger_att"] = trigger.to_dictionary()
	sub_node_states["ammo_att"] = ammo.to_dictionary()
	sub_node_states["barrel_att"] = barrel.to_dictionary()
	sub_node_states["appearance"] = weapon_appearance.to_dictionary()
	state["sub_node_states"] = sub_node_states

	return state

func from_dictionary(state:Dictionary) -> void:
	.from_dictionary(state)
	
	var sub_node_states: Dictionary = state["sub_node_states"]

	var damage_component: DamageComp = Global.create_instance(sub_node_states["damage"][RESOURCE_NAME_KEY])
	set_damage_comp(damage_component)
	damage_component.from_dictionary(sub_node_states["damage"])

	var accuracy_component: AccuracyComp = Global.create_instance(sub_node_states["accuracy"][RESOURCE_NAME_KEY])
	set_accuracy_comp(accuracy_component)
	accuracy_component.from_dictionary(sub_node_states["accuracy"])

	var critical_component: CriticalStrikeComp = Global.create_instance(sub_node_states["critical_strike"][RESOURCE_NAME_KEY])
	set_critical_strike_comp(critical_component)
	critical_component.from_dictionary(sub_node_states["critical_strike"])

	var stock_att: Stock = Global.create_instance(sub_node_states["stock_att"][RESOURCE_NAME_KEY])
	set_stock(stock_att)
	stock_att.from_dictionary(sub_node_states["stock_att"])

	var trigger_att: Trigger = Global.create_instance(sub_node_states["trigger_att"][RESOURCE_NAME_KEY])
	set_trigger(trigger_att)
	trigger_att.from_dictionary(sub_node_states["trigger_att"])

	var ammo_att: Ammo = Global.create_instance(sub_node_states["ammo_att"][RESOURCE_NAME_KEY])
	set_ammo(ammo_att)
	ammo_att.from_dictionary(sub_node_states["ammo_att"])

	var barrel_att: Barrel = Global.create_instance(sub_node_states["barrel_att"][RESOURCE_NAME_KEY])
	set_barrel(barrel_att)
	barrel_att.from_dictionary(sub_node_states["barrel_att"]) 

	var appearance: WeaponSkin = Global.create_instance(sub_node_states["appearance"][RESOURCE_NAME_KEY])
	set_weapon_appearance(appearance)
	appearance.from_dictionary(sub_node_states["appearance"])


