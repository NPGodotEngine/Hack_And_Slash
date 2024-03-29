class_name ExpComponent
extends Node

class ProgressContext extends Resource:
    var previous_progress: float = 0.0
    var updated_progress: float = 0.0
    var max_progress: float = 0.0

class ExpContext extends Resource:
    var previous_xp: float = 0.0
    var updated_xp: float = 0.0
    var xp_required: float = 0.0

class ExpRequiredContext extends Resource:
    var previous_xp_required: float = 0.0
    var updated_xp_required: float = 0.0
    

# Emit when progress changed
##
# `progress_context`: class `ProgressContext`
signal progress_updated(progress_context)

# Emit when xp changed
##
# `xp_context`: class `ExpContext`
signal xp_updated(xp_context)

# Emit when xp to next progression changed
##
# `exp_requried_context`: class `ExpRequiredContext`
signal xp_required_updated(exp_requried_context)

# Emit when max progression reached
##
# `progress_context`: class `ProgressContext`
signal max_progress_reached(progress_context)



# Design exp curve in inspector
export (CurveTexture) var exp_curve: CurveTexture

# Max progression aka max level
export (float) var max_progress: float = 100.0

# Base xp
export (float) var base_exp: float = 1000.0

# Print leve to xp requirement at start
export (bool) var log_level_xp: bool = false

# Current progression aka current
# level
var _progress: float = 1.0 setget set_progress

# Current xp
var _xp: float = 0.0 setget set_xp

# Exp required to progress
var _xp_required: float = 0.0 setget set_xp_required, get_xp_required



## Getter Setter ##


func _ready() -> void:
    _xp_required = calculate_xp_required(_progress)

    if log_level_xp:
        for level in range(_progress, max_progress+1):
            print("level: %f -> xp required: %f" % [level, calculate_xp_required(level)])



func set_progress(value:float) -> void:
    if is_equal_approx(value, _progress):
        return
    
    var prev_progress: float = _progress
    _progress = min(max(floor(value), 1.0), max_progress)
    
    var progress_context: ProgressContext = ProgressContext.new()
    progress_context.previous_progress = prev_progress
    progress_context.updated_progress = _progress
    progress_context.max_progress = max_progress

    emit_signal("progress_updated", progress_context)
    
    # if reach max progress
    if is_equal_approx(_progress, max_progress):
        emit_signal("max_progress_reached", progress_context)

func set_xp(value:float) -> void:
    if sign(value) < 0.0:
        return

    if is_equal_approx(value, _xp):
        return
    
    var prev_xp: float = _xp
    _xp = round(value)

    var xp_context: ExpContext = ExpContext.new()
    xp_context.previous_xp = prev_xp
    xp_context.updated_xp = _xp
    xp_context.xp_required = get_xp_required()

    emit_signal("xp_updated", xp_context)


func set_xp_required(value:float) -> void:
    if sign(value) < 0.0:
        return

    if is_equal_approx(value, _xp_required):
        return
    
    var prev_xp_required = _xp_required
    _xp_required = round(value)

    var xp_required_context: ExpRequiredContext = ExpRequiredContext.new()
    xp_required_context.previous_xp_required = prev_xp_required
    xp_required_context.updated_xp_required = _xp_required

    emit_signal("xp_required_updated", xp_required_context)

func get_xp_required() -> float:
    var progress_scale: float = _progress / max_progress
    var xp_requried: float = exp_curve.curve.interpolate(progress_scale) * base_exp
    return round(xp_requried)
## Getter Setter ##

# Calculate xp requirement to progress next level
# base on given progress
##
# `progress`: current progress
func calculate_xp_required(progress:float) -> float:
    var progress_scale: float = progress / max_progress
    var new_xp_requried: float = exp_curve.curve.interpolate(progress_scale) * base_exp
    return round(new_xp_requried)


# Increase xp by amount
func increase_xp(xp_amount:float) -> void:
    xp_amount = round(xp_amount)
    print("increase xp by %f" % xp_amount)
    # do nothing if value is negative or 0.0
    if (xp_amount < 0.0 or sign(xp_amount) < 0.0 or
        is_equal_approx(xp_amount, 0.0)):
        return
    
    # do nothing if reach max progress 
    if (is_equal_approx(_progress, max_progress) or 
        _progress > max_progress):
        return 

    var total_xp: float = _xp + xp_amount
    var xp_required: float = get_xp_required()
    
    while (is_equal_approx(xp_required, total_xp) or
        total_xp > xp_required):

        total_xp -= xp_required
        var new_progress: float = _progress + 1.0

        # update current xp to xp required
        set_xp(xp_required)

        # update xp required
        var new_xp_requried: float = calculate_xp_required(new_progress)
        xp_required = new_xp_requried
        set_xp_required(new_xp_requried)

        # increase 1 progress
        set_progress(new_progress)

        if is_equal_approx(_progress, max_progress):
            set_xp(xp_required)
            return

    set_xp(total_xp)

    
    
