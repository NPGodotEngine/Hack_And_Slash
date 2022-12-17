tool
extends Trigger

# warning-ignore-all: RETURN_VALUE_DISCARDED


# Number of bursts for each trigger pulled
export (int, 2, 100) var number_of_bursts = 3

# Duration for a burst process
export (float) var burst_duration: float = 1.0

# Duration between last burst process and next burst process
export (float) var wait_to_next_burst: float = 1.0

# Number of bursts left
var _burst_left: int = 0

# Duration between each bursts during
# burst process
var _duration_per_burst: float = 0.0


# Timer for each burst
var _timer_per_burst: Timer = null

# Timer for interval between burst process
var _wait_next_burst_timer: Timer = null

# Is in bursting process
var _is_bursting: bool = false

var _is_wating_for_next_process: bool = false

# Is trigger ready to be pulled
var _is_trigger_ready: bool = true

func _get_configuration_warning() -> String:
    if is_equal_approx(burst_duration, 0):
        return "burst duration can't be %f, increase burst duration" % burst_duration

    return ""

func _ready() -> void:
    if Engine.editor_hint: return

    _timer_per_burst = Timer.new()
    add_child(_timer_per_burst)
    _timer_per_burst.one_shot = true
    _timer_per_burst.connect("timeout", self, "_on_timer_per_burst_timeout")

    _wait_next_burst_timer = Timer.new()
    add_child(_wait_next_burst_timer)
    _wait_next_burst_timer.one_shot = true
    _wait_next_burst_timer.connect("timeout", self, "_on_wait_next_burst_timer_timeout")

func setup() -> void:
    .setup()

    assert(not is_equal_approx(burst_duration, 0), "burst duration can't be 0.0")

    # make sure we have equal amount of burst to setting
    _burst_left = number_of_bursts
    _duration_per_burst = burst_duration / number_of_bursts

func pull_trigger() -> void:
    if not _is_trigger_ready: return

    # Don't pull trigger if still in bursting
    if _is_bursting: return

    if _is_wating_for_next_process: return
    
    # start bursting process
    _is_trigger_ready = false
    # make sure we have equal amount of burst to setting
    _burst_left = number_of_bursts
    # trigger the first burst
    _on_timer_per_burst_timeout()

func _on_timer_per_burst_timeout() -> void:
    # decrease burst count
    _burst_left -= 1

    emit_signal("trigger_pulled")

    if _burst_left == 0:
        # burst process finished
        # wait til next burst process
        _wait_next_burst_timer.start(wait_to_next_burst)
    else:
        # burst process not finished
        _is_bursting = true
        _is_wating_for_next_process = true
        _is_trigger_ready = false
        
        # time until next burst ready 
        _timer_per_burst.start(_duration_per_burst)

func _on_wait_next_burst_timer_timeout() -> void:
    _burst_left = number_of_bursts
    _is_trigger_ready = true
    _is_bursting = false
    _is_wating_for_next_process = false


