@tool
class_name Trail
extends Line2D

# Trail direction
##
# Default is `Vector2.LEFT`
@export var trail_render_direction: Vector2 = Vector2.LEFT

# How far is it between each points
@export var point_distance: float = 10.0

@export var is_wildness: bool = true

# Wildness of each points
@export var wildness: float = 3.0

# Random wild range 
@export var wild_range: float = 0.5

# Max points can this trail has
@export_range(2, 600) var max_points: int = 6

# Gravity of each points
@export var gravity: Vector2 = Vector2.ZERO

# How fast can trail update
## 
# Used for add or remove points
# Not for update points' position
@export var frame_per_seconds: float = 30.0

var _ticks := 0.0

func _ready():
	super._ready()

	clear_points()

func _process(delta):
	super._process(delta)
	if _ticks >=  1 / frame_per_seconds:
		# add a new point
		var point: Vector2 = Vector2.ZERO
		if not get_point_count() == 0:
			point = points[get_point_count() - 1] + trail_render_direction.normalized() * point_distance
		add_point(point)

		# remove a point if size of points exceed max
		if points.size() > max_points:
			remove_point(0)
			_ticks = 0.0
	
	_ticks += delta
			
	# update each points' position	
	for p in range(get_point_count()):
		var point_position: Vector2 = trail_render_direction.normalized() * point_distance * p
		if is_wildness:
			var rand_vector := Vector2( randf_range(-wild_range, wild_range), randf_range(-wild_range, wild_range) )
			point_position += (gravity + (rand_vector * wildness))
		set_point_position(p, point_position)
	
