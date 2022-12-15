extends Trigger

# warning-ignore-all: RETURN_VALUE_DISCARDED


# Number of bursts for each trigger pulled
export (int, 2, 10) var number_of_bursts = 3

# Number of bursts left
var _burst_left: int = 0

# Duration between each bursts
var _burst_duration: float = 0

# Burst timer
var _burst_timer: Timer = null

# Is in bursting process
var _is_bursting: bool = false

# Is trigger ready to be pulled
var _is_trigger_ready: bool = true

func _ready() -> void:
    _burst_timer = Timer.new()
    add_child(_burst_timer)
    _burst_timer.one_shot = true
    _burst_timer.connect("timeout", self, "_on_burst_timer_timeout")

func setup() -> void:
    setup()

    # make sure we have equal amount of burst to setting
    _burst_left = number_of_bursts

    # Evenly spread burst duration in trigger pull duration
    _burst_duration = pull_duration / number_of_bursts

func pull_trigger() -> void:
    if not _is_trigger_ready: return

    # Don't pull trigger if still in bursting
    if _is_bursting: return
    
    # start bursting process
    _is_trigger_ready = false
    # make sure we have equal amount of burst to setting
    _burst_left = number_of_bursts
    # trigger the first burst
    _on_burst_timer_timeout()

func _on_burst_timer_timeout() -> void:
    # decrease burst count
    _burst_left -= 1

    emit_signal("trigger_pulled")

    if _burst_left == 0:
        # burst process finished
        _burst_left = number_of_bursts
        _is_trigger_ready = true
        _is_bursting = false
    else:
        # burst process not finished
        _is_bursting = true
        _is_trigger_ready = false
        
        # time until next burst ready 
        _burst_timer.start(_burst_duration)

