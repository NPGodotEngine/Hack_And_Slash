tool
class_name WeaponReceiver
extends Component

# warning-ignore-all: UNUSED_ARGUMENT

# Damage component
onready var damage_comp: DamageComp = (get_damage_comp()) setget set_damage_comp, get_damage_comp

# Accuracy component
onready var accuracy_comp: AccuracyComp = (get_accuracy_comp()) setget set_accuracy_comp, get_accuracy_comp

# Critical strike component
onready var critical_strike_comp: CriticalStrikeComp = (get_critical_strike_comp()) setget set_critical_strike_comp, get_critical_strike_comp



# Return weapon receiver's damage
##
# Setting new value does nothing 
var damage: int = 0 setget no_set, get_damage

# Return weapon receiver's accuracy
##
# Setting new value does nothing 
var accuracy: float = 0.0 setget no_set, get_accuracy

# Return damage color
##
# Setting new value does nothing 
var damage_color: Color = Color.white setget no_set, get_damage_color

# Is receiver critical strike
##
# Call this to generate a critical strike
##
# Setting new value does nothing 
var is_critical: bool = false setget no_set, get_is_critical

# Return critical strike multiplier
##
# Setting new value does nothing 
var critical_multiplier: float = 0.0 setget no_set, get_critical_multiplier

# Return critical strike color
##
# Setting new value does nothing 
var critical_color: Color = Color.white setget no_set, get_critical_color

func setup() -> void:
	.setup()
	damage_comp.setup()
	accuracy_comp.setup()
	critical_strike_comp.setup()

## Gtter Setter ##
func no_set(value):
	push_warning("no set for property")

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

func get_damage() -> int:
	if damage_comp == null:
		return 0
	return damage_comp.damage

func get_accuracy() -> float:
	if accuracy_comp == null:
		return 0.0
	return accuracy_comp.accuracy

func get_damage_color() -> Color:
	if damage_comp == null:
		return Color.white
	return damage_comp.damage_color

func get_is_critical() -> bool:
    if critical_strike_comp == null:
        return false
    return critical_strike_comp.is_critical()

func get_critical_multiplier() -> float:
	if critical_strike_comp == null:
		return 0.0
	return critical_strike_comp.critical_strike_multiplier

func get_critical_color() -> Color:
	if critical_strike_comp == null:
		return Color.white
	return critical_strike_comp.critical_strike_color
## Gtter Setter ##

func get_spread_range(face_dir: Vector2, accuracy_scaler: float = 1) -> Vector2:
	if accuracy_comp == null:
		return Vector2.ZERO
	return accuracy_comp.get_random_spread(face_dir, accuracy_scaler)

func to_dictionary() -> Dictionary:
	var state: Dictionary = .to_dictionary()

	var sub_node_states: Dictionary = state[SUB_NODE_STATE_KEY]
	sub_node_states["damage_comp"] = damage_comp.to_dictionary()
	sub_node_states["accuracy_comp"] = accuracy_comp.to_dictionary()
	sub_node_states["critical_comp"] = critical_strike_comp.to_dictionary()

	return state

func from_dictionary(state: Dictionary) -> void:
	.from_dictionary(state)

	var sub_node_states: Dictionary = state[SUB_NODE_STATE_KEY]

	var damage_node: DamageComp = Global.create_instance(sub_node_states["damage_comp"][RESOURCE_NAME_KEY])
	set_damage_comp(damage_node)
	damage_node.from_dictionary(sub_node_states["damage_comp"])

	var accuracy_node: AccuracyComp = Global.create_instance(sub_node_states["accuracy_comp"][RESOURCE_NAME_KEY])
	set_accuracy_comp(accuracy_node)
	accuracy_node.from_dictionary(sub_node_states["accuracy_comp"])

	var critical_node: CriticalStrikeComp = Global.create_instance(sub_node_states["critical_comp"][RESOURCE_NAME_KEY])
	set_critical_strike_comp(critical_node)
	critical_node.from_dictionary(sub_node_states["critical_comp"])