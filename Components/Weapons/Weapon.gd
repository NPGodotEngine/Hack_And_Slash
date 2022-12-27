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
onready var _damage_comp: DamageComp = $DamageComp

# Accuracy component
onready var _accuracy_comp: AccuracyComp = $AccuracyComp

# Critical strike component
onready var _critical_strike_comp: CriticalStrikeComp = $CriticalStrikeComp

# Weapon skin
##
# Skin for weapon visual
onready var weapon_appearance: WeaponSkin = $WeaponSkin

# List of weapon attachments 
var _attachments: Array = []

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

var stock: Attachment = null
var trigger: Trigger = null
var ammo: Ammo = null
var barrel: Attachment = null
var alt: Attachment = null

# Weapon manager manage this weapon
var weapon_manager = null


## Getter Setter ##



# Return weapon's total damage output
# The minimum is 10% of weapon's damage
##
# Weapon's damage * multiplier from all attachments
# Multiplier is capped between 0.1 ~ 1.0
func get_weapon_damage() -> int:
	if _damage_comp == null: return 0
	var weapon_base_damage: int = _damage_comp.damage
	var multiplier: float = calculate_attachments_dmg_multiplier()
	multiplier = min(max(0.1, multiplier), 1.0)

	if is_equal_approx(multiplier, 0.0):
		return weapon_base_damage
	print("%d, %f" % [weapon_base_damage, multiplier])
	return int(weapon_base_damage * multiplier)

# Return weapon's total accuracy in between
# 0.0 ~ 1.0
func get_weapon_accuracy() -> float:
	if _accuracy_comp == null: return 0.0
	var weapon_base_accuracy: float = _accuracy_comp.accuracy 
	var att_accuracy: float = calculate_attachments_accuracy_multiplier()
	var acc = weapon_base_accuracy + att_accuracy
	acc = min(max(0.0, acc), 1.0)

	return acc

## Getter Setter ##

## Override ##
func _get_configuration_warning() -> String:
	var dmg_comp = get_node("DamageComp") as DamageComp
	if dmg_comp == null:
		return "Weapon must have a damage component with name DamageComp"
	
	var acc_comp = get_node("AccuracyComp") as AccuracyComp
	if acc_comp == null:
		return "Weapon must have a accuracy component with name AccuracyComp"

	var critical_comp = get_node("CriticalStrikeComp") as CriticalStrikeComp
	if critical_comp == null:
		return "Weapon must have a critical strike component with name CriticalStrikeComp"

	var weapon_skin = get_node("WeaponSkin") as WeaponSkin
	if weapon_skin == null:
		return "Weapon must have a weapon skin component with name WeaponSkin"

	collection_attachments()
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
	assert(_damage_comp, 
		"Weapon required a damage compoent as child with name \"DamageComp\"")
	assert(_accuracy_comp, 
		"Weapon required a accuracy compoent as child with name \"DamageComp\"")
	assert(_critical_strike_comp, 
	"Weapon required a critical strike compoent as child with name \"CriticalStrikeComp\"")
	assert(weapon_appearance, 
	"Weapon required a weapon skin compoent as child with name \"WeaponSkin\"")

	collection_attachments()

	assert(get_attachment_by_type(Global.AttachmentType.STOCK), 
		"Weapon required a stock attachment as child")
	assert(get_attachment_by_type(Global.AttachmentType.TRIGGER), 
	"Weapon required a trigger attachment as child")
	assert(get_attachment_by_type(Global.AttachmentType.AMMO), 
	"Weapon required a ammo attachment as child")
	assert(get_attachment_by_type(Global.AttachmentType.BARREL), 
	"Weapon required a barrel attachment as child")

	# setup all attachements
	for att in _attachments:
		(att as Attachment).setup()

	# setup all components
	_damage_comp = $DamageComp
	_damage_comp.setup()
	_accuracy_comp = $AccuracyComp
	_accuracy_comp.setup()
	_critical_strike_comp = $CriticalStrikeComp
	_critical_strike_comp.setup()
	
	stock = get_attachment_by_type(Global.AttachmentType.STOCK)

	trigger = get_attachment_by_type(Global.AttachmentType.TRIGGER)
	trigger.connect("trigger_pulled", self, "_on_trigger_pulled")

	ammo = get_attachment_by_type(Global.AttachmentType.AMMO)
	ammo.connect("ammo_depleted", self, "_on_ammo_depleted")
	ammo.connect("ammo_count_changed", self, "_on_ammo_count_changed")
	ammo.connect("begin_reloading", self, "_on_begin_reloading")
	ammo.connect("end_reloading", self, "_on_end_reloading")

	barrel = get_attachment_by_type(Global.AttachmentType.BARREL)

	_damage_comp.connect("damage_changed", self, "_on_damage_changed")
	_accuracy_comp.connect("accuracy_changed", self, "_on_accuracy_changed")
	
## Override ##

# Find all attachments and
# store in attachment list
func collection_attachments() -> void:
	_attachments.clear()

	for child in get_children():
		if child is Attachment:
			_attachments.append(child)	

# Get attachment by type, return null if not found
##
# `att_type` `AttachmentType` in Global.gd
func get_attachment_by_type(att_type:int) -> Attachment:
	for i in _attachments.size():
		var att = _attachments[i] as Attachment
		if att.attachment_type & att_type:
			return att
	return null

# Return damage from combination of all attachments
func calculate_attachments_dmg_multiplier() -> float:
	var dmg_multiplier: float = 0.0

	for i in _attachments.size():
		var att:Attachment = _attachments[i]
		if att:
			dmg_multiplier += att.damage_multiplier
	
	return dmg_multiplier

# Return accuracy from combination of all attachments
func calculate_attachments_accuracy_multiplier() -> float:
	var total_acc: float = 0.0

	for i in _attachments.size():
		var att:Attachment = _attachments[i]
		if att:
			total_acc += att.accuracy_multiplier
	
	return total_acc

# Get hit damage from weapon
func get_hit_damage() -> HitDamage:
	var damage: int = get_weapon_damage()
	var critical: bool = _critical_strike_comp.is_critical()
	var color: Color = (_critical_strike_comp.critical_strike_color if critical 
										else _damage_comp.damage_color)
	var hit_damage: HitDamage = HitDamage.new().init(
		weapon_manager.get_manager_owner(),
		self,
		damage,
		critical,
		_critical_strike_comp.critical_strike_multiplier,
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

