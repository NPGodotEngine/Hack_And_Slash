@tool
class_name MuzzleFlash
extends Sprite2D

# warning-ignore-all: RETURN_VALUE_DISCARDED


enum flash_type {
    SMALL = 1,
    MEDIUM = 2,
    LARGE = 4
}

@export var flash_duration: float = 0.1
@export var flash_small_frames: Array[int] = []
@export var flash_medium_frames: Array[int] = []
@export var flash_large_frames: Array[int] = []

@onready var _flash_duration_timer: Timer = $FlashDurationTimer

func _get_configuration_warnings() -> PackedStringArray:
    if flash_small_frames.size() == 0:
        return ["You must define frame numbers for small flash"]
    if flash_medium_frames.size() == 0:
        return ["You must define frame numbers for medium flash"]
    if flash_large_frames.size() == 0:
        return ["You must define frame numbers for large flash"]
    return []

func _ready() -> void:
    if Engine.is_editor_hint():
        return

    randomize()
    self.hide()
    _flash_duration_timer.connect("timeout", Callable(self, "_on_flash_timer_timeout"))

func _on_flash_timer_timeout() -> void:
    self.hide()

# Puff muzzle flash
##
# `duration`: how long is this muzzle live
# `type`: type of muzzle flash `1`:small, `2`:medium `4`: large
# use bitwise to achieve different muzzle effect combination
func flash(duration:float = flash_duration, type:int=flash_type.SMALL) -> void:
    if _flash_duration_timer.time_left > 0.0:
        _flash_duration_timer.stop()
    

    var frame_range := []
    if bool(type & flash_type.SMALL) == true:
        frame_range += flash_small_frames
    if bool(type & flash_type.MEDIUM) == true:
        frame_range += flash_medium_frames
    if bool(type & flash_type.LARGE) == true:
        frame_range += flash_large_frames
    
    var index: int = randf_range(0, frame_range.size()-1) as int
    self.frame = frame_range[index]

    _flash_duration_timer.start(duration)
    self.show()
    


