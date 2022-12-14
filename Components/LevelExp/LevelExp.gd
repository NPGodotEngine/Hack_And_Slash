class_name LevelExpComp
extends Component

# Emit when level changed
signal level_up(from_level, to_level)

# Emit when max level reached
signal max_level_reached(current_level, max_level)

# Emit when experience changed
signal current_exp_changed(from_exp, to_exp)

# Emit when experience required to next level changed
signal next_level_exp_required_changed(from_exp_required, to_exp_required)



# Max level
export (int) var  _max_level = 10

# Start level
export (int) var  _start_level = 1

# Current level
var _level: int = _start_level setget _set_level


# Constant experience
##
# Constant for scaling up next level exp requirement
export (int) var _constant_exp = 10

# Next experience required to level up
var _next_level_exp_requried: int = 0 setget _set_next_level_exp_required

# Current experience
var _current_exp: int = 0 setget _set_current_exp




## Getter Setter ##


# Set level
##
# Cap value if it is not between min and max
# Emit signal `level_changed`
func _set_level(value:int) -> void:
	if value == _level: return

	var old_level = _level
	_level = int(max(_start_level, min(value, _max_level)))
	emit_signal("level_up", old_level, _level)
	if _level == _max_level:
		emit_signal("max_level_reached", _level, _max_level)

# Set current experience
##
# Cap value if it is < 0
# Emit signal `current_exp_changed`
func _set_current_exp(value:int) -> void:
	if value == _current_exp: return

	var old_exp = _current_exp
	_current_exp = int(max(0, value))
	emit_signal("current_exp_changed", old_exp, _current_exp)

## Getter Setter ##


## Override ##

func setup() -> void:
    .setup()

    # set exp required to next level
    _set_next_level_exp_required(get_next_level_exp_required(_level))

## Override ##


# Set next level exp requried
##
# Cap value if it is < 0.0
# Emit signal `next_level_exp_required_changed`
func _set_next_level_exp_required(value:int) -> void:
	if value == _next_level_exp_requried: return 

	var old_exp_required = _next_level_exp_requried
	_next_level_exp_requried = int(max(0, value))
	emit_signal("next_level_exp_required_changed", old_exp_required, _next_level_exp_requried)

# Get next level exp requried by current level
func get_next_level_exp_required(current_level:int) -> int:
	return (current_level - 1 + current_level) * _constant_exp

# If character is at max level
func is_max_level_reached() -> bool:
	return _level == _max_level

# Add exp to character
func add_exp(amount:int) -> void:
	if is_max_level_reached(): return
	
	# level up
	var total_exp = _current_exp + amount
	while (total_exp >= _next_level_exp_requried and 
			not is_max_level_reached()):
		level_up()
		_set_next_level_exp_required(get_next_level_exp_required(_level))
	
	# set current exp
	if is_max_level_reached():
		_set_current_exp(_next_level_exp_requried)
	else:
		_set_current_exp(total_exp)

# Increase level
func level_up(amount:int = 1) -> void:
	_set_level(_level + amount)
