class_name Ammo
extends WeaponModule

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT


# Emit when ammo depleted
signal ammo_depleted(ammo_count, round_per_clip)

# Emit when ammo count has changed
signal ammo_count_changed(ammo_count, round_per_clip)

# Emit when begin reloading
signal begin_reloading(ammo_count, round_per_clip)

# Emit when reloading end
signal end_reloading(ammo_count, round_per_clip)


# Fill ammo when ammo component start
export (bool) var fill_ammo_when_start: bool = true

# How many rounds per clip
export (int, 1, 5000) var rounds_per_clip: int = 10

# Duration for reload ammo
export (float, 0.1, 20.0) var reload_duration: float = 2.0

# Number of rounds left in a clip
var _round_left: int = 0 setget _set_round_left

# Timer for reload
var _reload_timer: Timer = null

# is ammo reloading
var _is_reloading: bool = false



## Getter Setter##


func _set_round_left(value:int) -> void:
	if _round_left == value: return
	_round_left = int(min(max(0, value), rounds_per_clip))
	
	if _round_left > 0:
		emit_signal("ammo_count_changed", _round_left, rounds_per_clip)
	else:
		emit_signal("ammo_depleted", 0, rounds_per_clip)

## Getter Setter##

## Override ##

func _on_component_ready() -> void:
	._on_component_ready()
	
	module_type = Global.WeaponModuleType.AMMO
		 
	_reload_timer = Timer.new()
	add_child(_reload_timer)
	_reload_timer.one_shot = true
	_reload_timer.connect("timeout", self, "_on_reload_timer_timeout")

## Override ##

func setup() -> void:
	.setup()

	if fill_ammo_when_start:
		_set_round_left(rounds_per_clip)

# Shoot ammo
##
# `hit_damage` `HitDamage` apply to bullet
# `rounds_per_shot` number of rounds to shoot at once, usually is one
func shoot_ammo(from_position:Vector2, to_position:Vector2, 
	hit_damage:HitDamage, rounds_per_shot:int = 1) -> void:
	assert(rounds_per_shot >= 0, 
		"rounds per shot can't be negative value, %d was given" % rounds_per_shot)

	# adjust rounds_per_shot if it is over total rounds left
	# in clip
	rounds_per_shot = int(min(_round_left, rounds_per_shot))
	
# Reload ammo
func reload_ammo() -> void:
	# if is reloading
	if _is_reloading: return
		
	# don't reload if clip is full
	if _round_left == rounds_per_clip: return
	
	# begin reloading process
	_is_reloading = true
	_reload_timer.start(reload_duration)
	emit_signal("begin_reloading", 0, rounds_per_clip)

func cancel_action() -> void:
	pass

func _on_reload_timer_timeout() -> void:
	# refill clip
	_set_round_left(rounds_per_clip)
	_is_reloading = false
	emit_signal("end_reloading", _round_left, rounds_per_clip)


