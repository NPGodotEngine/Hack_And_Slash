# A generice class for weapon
# Any weapons must subclass of this class
# and implement execute method then call
# reload method at right time to 
# begin reloading process 
class_name Weapon
extends Component

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT

# Damage component
onready var _damage_comp: DamageComp = $DamageComp

# Accuracy component
onready var _accuracy_comp: AccuracyComp = $AccuracyComp

# List of weapon attachments 
var _attachments: Array = []

# Weapon damage
##
# Return weapon's damage * all 
# attachments' damage multiplier(cap between 0.1 ~ 1.0)
##
# The minimum of damage is 10% of weapon's damage
var weapon_damage: int setget , get_weapon_damage

# Weapon accuracy
##
# Return weapon's accuracy + all 
# attachments' accuracy and then
# cap between 0.0 ~ 1.0
var weapon_accuracy: float setget , get_weapon_accuracy


## Getter Setter ##


# Return weapon's total damage output
# The minimum is 10% of weapon's damage
func get_weapon_damage() -> int:
	var weapon_base_damage: int = _damage_comp.damage
	var multiplier: float = calculate_attachments_dmg_multiplier()
	multiplier = min(max(0.1, multiplier), 1.0)

	if is_equal_approx(multiplier, 0.0):
		return weapon_base_damage
	return int(weapon_base_damage * multiplier)

# Return weapon's total accuracy in between
# 0.0 ~ 1.0
func get_weapon_accuracy() -> float:
	var weapon_base_accuracy: float = _accuracy_comp.accuracy 
	var att_accuracy: float = calculate_attachments_accuracy()
	var acc = weapon_base_accuracy + att_accuracy
	acc = min(max(0.0, acc), 1.0)

	return acc
## Getter Setter ##

# Setup weapon
func setup() -> void:
	.setup()

	assert(_damage_comp, 
		"Weapon required a damage compoent as child with name \"DamageComp\"")
	assert(_accuracy_comp, 
		"Weapon required a accuracy compoent as child with name \"DamageComp\"")

	collection_attachments()

	assert(get_attachment_by_type(Global.AttachmentType.STOCK), 
		"Weapon required a stock attachment as child")
	assert(get_attachment_by_type(Global.AttachmentType.TRIGGER), 
	"Weapon required a trigger attachment as child")
	assert(get_attachment_by_type(Global.AttachmentType.AMMO), 
	"Weapon required a ammo attachment as child")
	assert(get_attachment_by_type(Global.AttachmentType.BARREL), 
	"Weapon required a barrel attachment as child")

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

# Return damage from all attachments
func calculate_attachments_dmg_multiplier() -> float:
	var dmg_multiplier: float = 0.0

	for i in _attachments.size():
		var att:Attachment = _attachments[i]
		if att:
			dmg_multiplier += att.damage_multiplier
	
	return dmg_multiplier

func calculate_attachments_accuracy() -> float:
	var total_acc: float = 0.0

	for i in _attachments.size():
		var att:Attachment = _attachments[i]
		if att:
			total_acc += att.accuracy
	
	return total_acc

# Execute weapon
##
# `position` global position for weapon to shoot from 
# `direction` for weapon's projectile to travel
func execute(position:Vector2, direction:Vector2) -> void:
	pass

# Cancel weapon execution
##
# Specific to weapon that need to warm up
func cancel_execution() -> void:
	pass

# Execute weapon's alternative fire
##
# `position` global position for weapon to shoot from 
# `direction` for weapon's projectile to travel
func execute_alt(position:Vector2, direction:Vector2) -> void:
	pass

# Cancel weapon's alternative fire execution
##
# Specific to weapon that need to warm up
func cancel_alt_execution() -> void:
	pass