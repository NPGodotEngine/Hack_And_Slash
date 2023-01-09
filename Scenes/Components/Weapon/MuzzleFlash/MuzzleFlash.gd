class_name MuzzleFlash
extends Node2D

# warning-ignore-all: RETURN_VALUE_DISCARDED

onready var _particle2d: Particles2D = $Flash
onready var _flash_timer: Timer = $FlashTimer

func _ready() -> void:
    _flash_timer.connect("timeout", self, "_on_flash_timer_timeout")
    _particle2d.emitting = false

func _on_flash_timer_timeout() -> void:
    _particle2d.emitting = false

func flash(flash_duration:float) -> void:
    if _flash_timer.time_left > 0.0:
        _flash_timer.stop()

    _flash_timer.start(flash_duration)
    _particle2d.emitting = true
    _particle2d.restart()


