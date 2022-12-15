extends Trigger

# warning-ignore-all: RETURN_VALUE_DISCARDED

# Trigger timer
var _trigger_timer: Timer = null

# Is trigger ready to be pulled
var _is_trigger_ready: bool = true

func _ready() -> void:
    _trigger_timer = Timer.new()
    add_child(_trigger_timer)
    _trigger_timer.one_shot = true
    _trigger_timer.connect("timeout", self, "_on_trigger_timer_timeout")

func pull_trigger() -> void:
    if not _is_trigger_ready:
        return
    
    # set trigger not ready
    _is_trigger_ready = false

    # time until next pull ready
    _trigger_timer.start(pull_duration)
    emit_signal("trigger_pulled")

func _on_trigger_timer_timeout() -> void:
    _is_trigger_ready = true
    