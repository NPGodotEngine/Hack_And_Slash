class_name WeaponModule
extends Component

# Module type
var module_type: int = Global.WeaponModuleType.TRIGGER

# Attachment damage multiplier
export (float, -1.0, 1.0) var damage_multiplier = 0.0

# Attachment accuracy multiplier
export (float, -1.0, 1.0) var accuracy_multiplier = 0.0

# Call to cancel action that attachement's 
#is currently performing 
##
# Usually do noting but for ammo
# like beam this can tell beam ammo
# to stop the beam that is casting
func cancel_action() -> void:
	pass

func to_dictionary() -> Dictionary:
	var state: Dictionary = .to_dictionary()

	var properties: Dictionary = state[PROPERTIES_KEY]
	properties["damage_multiplier"] = damage_multiplier
	properties["accuracy_multiplier"] = accuracy_multiplier

	return state

func from_dictionary(state: Dictionary) -> void:
	.from_dictionary(state)

	var properties: Dictionary = state[PROPERTIES_KEY]
	damage_multiplier = properties["damage_multiplier"]
	accuracy_multiplier = properties["accuracy_multiplier"]

