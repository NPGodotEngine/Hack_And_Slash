class_name Ammo
extends Attachment

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



# How many rounds per clip
export (int, 1, 5000) var rounds_per_clip = 10

# Duration for reload ammo
export (float, 0.1, 20.0) var reload_duration = 2.0

# The actual bullet scene
##
# To be used to instantiate a new bullet
export (PackedScene) var bullet_scene

# Number of rounds left in a clip
var _round_left: int = 0 setget _set_round_left

# Timer for reload
var _reload_timer: Timer = null



## Getter Setter##


func _set_round_left(value:int) -> void:
    if _round_left == value: return
    _round_left = int(min(max(0, value), rounds_per_clip))
    
    if _round_left > 0:
        emit_signal("ammo_count_changed", _round_left, rounds_per_clip)
    else:
        emit_signal("ammo_depleted", 0, rounds_per_clip)

## Getter Setter##

func _ready() -> void:
    _reload_timer = Timer.new()
    add_child(_reload_timer)
    _reload_timer.one_shot = true
    _reload_timer.connect("timeout", self, "_on_reload_timer_timeout")

func setup() -> void:
    .setup()

    _set_round_left(rounds_per_clip)

# Return a list of bullet instances
##
# `round_per_shot` number of round per this shot
func get_ammo(rounds_per_shot:int = 1) -> Array:
    if _round_left == 0:
        reload_ammo()

    assert(bullet_scene, "bullet scene is missing")
    assert(rounds_per_shot >= 0, 
        "rounds per shot can't be negative value, %d was given" % rounds_per_shot)

    # adjust rounds_per_shot if it is over total rounds left
    # in clip
    rounds_per_shot = int(min(_round_left, rounds_per_shot))

    var ammos: Array = []

    for _shot in rounds_per_shot:
        var bullet = bullet_scene.instance()
        ammos.append(bullet)
    
    _set_round_left(_round_left - rounds_per_shot)

    return ammos

    
# Reload ammo
func reload_ammo() -> void:
    # don't reload if clip is full
    if _round_left == rounds_per_clip: return
    
    # begin reloading process
    _reload_timer.start(reload_duration)
    emit_signal("begin_reloading", 0, rounds_per_clip)

func _on_reload_timer_timeout() -> void:
    # refill clip
    _set_round_left(rounds_per_clip)
    emit_signal("end_reloading", _round_left, rounds_per_clip)


