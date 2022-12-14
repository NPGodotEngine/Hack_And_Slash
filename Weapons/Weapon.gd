# A generice class for weapon
# Any weapons must subclass of this class
# and implement execute method then call
# reload method at right time to 
# begin reloading process 
class_name Weapon
extends Component

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT

# Signal for reloading started
signal reloading_started()

# Signal for reloading ended
signal reloading_ended()

# Reloading duration of the weapon
export (float) var reloading_duration := 1.0

# Weapon damage multiplier
# base on its owner's damage
# E.g 1.0 = 100% of its owner's damage
# E.g 0.75 = 75% of its owner's damage
export (float) var damage_multiplier := 1.0

# Reloading timer
var reloading_timer: Timer = null

# Is weapon ready to be used
var is_weapon_ready: bool = true

func _ready() -> void:
	# create a reloading timer
	reloading_timer = Timer.new()
	reloading_timer.name = "ReloadingTimer"
	add_child(reloading_timer)

	
	# setup reloading timer
	reloading_timer.one_shot = true
	reloading_timer.connect("timeout", self, "_on_reloading_timer_timeout")

func _exit_tree() -> void:
	if reloading_timer:
		reloading_timer.disconnect("timeout", self, "_on_reloading_timer_timeout")

# Called when reloading timer timeout
func _on_reloading_timer_timeout() -> void:
	is_weapon_ready = true
	emit_signal("reloading_ended")

# Setup weapon
func setup() -> void:
	.setup()

# Begin weapon reloading process 
func start_reloading() -> void:
	is_weapon_ready = false

	# Don't start timer if during reloading
	if reloading_timer.time_left > 0:
		return

	reloading_timer.start(reloading_duration)

	emit_signal("reloading_started")

# Get total damage output from this weapon
# Scaled from weapon owner's damage 
func get_damage_output() -> int:
	# caculate multiplied damage
	var damage_output = 0
	
	var damage_comp: DamageComp = get_parent().get_manager_owner().get_component_by_name("DamageComp")

	if damage_comp:
		# owner's damage * multiplier
		damage_output = int(damage_comp.damage * damage_multiplier)

	return damage_output

# Get hit damage
func get_hit_damage() -> HitDamage:
	# return hit damage information
	return HitDamage.new().init(
		get_parent().get_manager_owner(),
		self,
		get_damage_output(),
		false,
		0.0,
		Color.white
	)

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