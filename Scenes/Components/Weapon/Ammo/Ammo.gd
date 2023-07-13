tool
class_name Ammo
extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT


class AmmoContext extends Resource:
	var previous_ammo_count: int = 0
	var updated_ammo_count: int = 0
	var round_per_clip: int = 0

class AmmoReloadProgress:
	var progress: float = 1.0
	var max_progress: float = 1.0

# Emit when ammo depleted
signal ammo_depleted(ammo_context)

# Emit when ammo count has changed
signal ammo_count_updated(ammo_context)

# Emit when begin reloading
signal begin_reloading(ammo_context)

# Emit when reloading end
signal end_reloading(ammo_context)

export(float) var bullet_speed = 200.0
export(float) var bullet_life_span = 3.0
export(float) var bullet_penetration_chance = 0.0

# The actual bullet scene
##
# To be used to instantiate a new bullet
export(PackedScene) var bullet_scene: PackedScene = null

# Infinite ammo
export (bool) var infinite_ammo: bool = false

# Fill ammo when ammo component start
export (bool) var fill_ammo_when_start: bool = true

# How many rounds per clip
export (int, 1, 5000) var rounds_per_clip: int = 10 setget _set_round_per_clip

# Duration for reload ammo
export (float, 0.1, 20.0) var reload_duration: float = 2.0

var progress: AmmoReloadProgress setget no_set, get_progress

# Number of rounds left in a clip
var _round_left: int = 0 setget _set_round_left

# Timer for reload
var _reload_timer: Timer = null

# is ammo reloading
var _is_reloading: bool = false



## Getter Setter##


func no_set(value):
	pass

func get_progress() -> AmmoReloadProgress:
	var reload_progress: AmmoReloadProgress = AmmoReloadProgress.new()

	if _is_reloading:	
		reload_progress.progress = _reload_timer.wait_time - _reload_timer.time_left
		reload_progress.max_progress = _reload_timer.wait_time

	return reload_progress 

func _set_round_per_clip(value:int) -> void:
	rounds_per_clip = value
	_round_left = int(min(max(0, value), rounds_per_clip))

func _set_round_left(value:int) -> void:
	if _round_left == value: 
		return
	
	var prev_round_left: int = _round_left
	_round_left = int(min(max(0, value), rounds_per_clip))
	
	var ammo_context: AmmoContext = AmmoContext.new()
	ammo_context.previous_ammo_count = prev_round_left
	ammo_context.updated_ammo_count = _round_left
	ammo_context.round_per_clip = rounds_per_clip

	if _round_left > 0:
		emit_signal("ammo_count_updated", ammo_context)
	else:
		emit_signal("ammo_depleted", ammo_context)

## Getter Setter##

## Override ##

func _get_configuration_warning() -> String:
    if bullet_scene == null:
        return "bullet_scene is missing"
    return ""

func _ready() -> void:
	if Engine.editor_hint:
		return
		
	if fill_ammo_when_start:
		_set_round_left(rounds_per_clip)

	if _reload_timer:
		_reload_timer.queue_free()

	_reload_timer = Timer.new()
	_reload_timer.name = "ReloadTimer"
	add_child(_reload_timer)
	_reload_timer.one_shot = true
	_reload_timer.connect("timeout", self, "_on_reload_timer_timeout")

## Override ##
	
	
# Reload ammo
func reload_ammo() -> void:
	# if is reloading
	if _is_reloading: return
		
	# don't reload if clip is full
	if _round_left == rounds_per_clip: return
	
	# begin reloading process
	_is_reloading = true
	_reload_timer.start(reload_duration)
	
	var ammo_context: AmmoContext = AmmoContext.new()
	ammo_context.previous_ammo_count = _round_left
	ammo_context.updated_ammo_count = _round_left
	ammo_context.round_per_clip = rounds_per_clip

	emit_signal("begin_reloading", ammo_context)

func _on_reload_timer_timeout() -> void:
	# refill clip
	_set_round_left(rounds_per_clip)
	_is_reloading = false

	var ammo_context: AmmoContext = AmmoContext.new()
	ammo_context.previous_ammo_count = _round_left
	ammo_context.updated_ammo_count = _round_left
	ammo_context.round_per_clip = rounds_per_clip

	emit_signal("end_reloading", ammo_context)


