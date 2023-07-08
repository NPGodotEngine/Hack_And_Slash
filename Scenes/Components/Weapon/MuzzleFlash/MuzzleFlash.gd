class_name MuzzleFlash
extends Sprite

# warning-ignore-all: RETURN_VALUE_DISCARDED

const FLASH_SMALL = [0,1,2]
const FLASH_MEDIUM = [3,4,5]
const FLASH_LARGE = [6,7,8]

enum flash_type {
    SMALL = 1,
    MEDIUM = 2,
    LARGE = 4
}

export (float) var flash_duration: float = 0.1

onready var _flash_duration_timer: Timer = $FlashDurationTimer

func _ready() -> void:
    self.hide()
    _flash_duration_timer.connect("timeout", self, "_on_flash_timer_timeout")

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
    if bool(type & flash_type.MEDIUM) == true:
        frame_range += FLASH_MEDIUM
    if bool(type & flash_type.LARGE) == true:
        frame_range += FLASH_LARGE
    if bool(type & flash_type.SMALL) == true:
        frame_range += FLASH_SMALL
    
    randomize()
    var index: int = rand_range(0, frame_range.size()-1) as int
    self.frame = frame_range[index]

    _flash_duration_timer.start(duration)
    self.show()
    


