class_name Trail
extends Line2D

export (float) var wildness := 3.0
export (float) var wild_range := 2.0
export (int, 5, 600) var max_points = 50
export (Vector2) var gravity := Vector2.ZERO
export (float) var frame_per_seconds = 30.0

var _ticks := 0.0

func _ready():
	clear_points()
	set_as_toplevel(true)

func _process(delta):
	if _ticks >=  1 / frame_per_seconds:
		add_point(global_position if not get_parent() else get_parent().global_position)
		if points.size() > max_points:
			remove_point(0)
			_ticks = 0.0
	
	_ticks += delta
		
		
	for p in range(get_point_count()):
		var rand_vector := Vector2( rand_range(-wild_range, wild_range), rand_range(-wild_range, wild_range) )
		set_point_position(p, points[p] +(gravity + ( rand_vector * wildness)) * delta)
