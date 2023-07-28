@tool
class_name FlankingComponent
extends Node2D

## Start direction to cast ray
@export_enum("Up", "Right", "Down", "Left") var start_direction: String = "Up"

## Number of line to cast
@export var line_count: int = 20

## Distance of each casted line
@export var distance: float = 200.0

## Angle range to cast line in degree
@export var angle_degree: float = 360.0

## Mask that rays will collide with
## @
## E.g Wall, Enemy, Car
@export_flags_2d_physics var collision_mask: int = 1

@export_group("Debug")

## Enabled debug for visualization
@export var debug_enabled: bool = false

## Color for line that is invalid position
@export_color_no_alpha var invalid_line_color: Color = Color.RED

## Color for line that is valid position
@export_color_no_alpha var valid_line_color: Color = Color.GREEN

## Width for each line
@export var line_width: float = 1.0

func _get_configuration_warnings() -> PackedStringArray:
	if not get_parent() is CharacterBody2D:
		return ["This node must be a child of CharacterBody2D node"]
	
	return []

func _ready() -> void:
	if Engine.is_editor_hint():
		connect("property_list_changed", Callable(self,"_redraw_raycast_debug_line"))

func _redraw_raycast_debug_line() -> void:
	queue_redraw()

func _process(_delta):
	if debug_enabled:
		queue_redraw()

func _draw():
	if debug_enabled:
		var valid_points: PackedVector2Array = find_flanking_positions()
		var invalid_points: PackedVector2Array = find_flanking_positions(false)

		for i in range(valid_points.size()):
			var point: Vector2 = valid_points[i]
			draw_line(Vector2.ZERO, to_local(point), valid_line_color, line_width)
		
		for i in range(invalid_points.size()):
			var point: Vector2 = invalid_points[i]
			draw_line(Vector2.ZERO, to_local(point), invalid_line_color, line_width)

func get_raycast_points() -> PackedVector2Array:
	if line_count <= 0:
		line_count = 1
	var inverval_angle_deg: float = angle_degree / line_count
	var total_line_count = line_count
	var points: PackedVector2Array = PackedVector2Array()
	var start_dir: Vector2 = get_start_direction(start_direction)
	for i in range(total_line_count):
		var current_dir = start_dir.rotated(deg_to_rad(inverval_angle_deg * i))
		points.append(current_dir * distance)

	return points

func get_start_direction(dir:String) -> Vector2:
	if dir == "Up":
		return Vector2.UP
	elif dir == "Right":
		return Vector2.RIGHT
	elif dir == "Down":
		return Vector2.DOWN
	elif  dir == "Left":
		return Vector2.LEFT
	else:
		return Vector2.UP


## Return an array of global positions around this Node
## @
## It will casting rays in a range of degree by number of lines
## and start from either one of 4 directions counter-clockwise
## @
## `valid_only`: `true` will only return valid positions
## otherwise it will only return invalid positions 
func find_flanking_positions(valid_only:bool=true) -> PackedVector2Array:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	
	var points: PackedVector2Array = get_raycast_points()
	var valid_points: PackedVector2Array = PackedVector2Array()
	var invalid_points: PackedVector2Array = PackedVector2Array()

	for point in points:
		var query = PhysicsRayQueryParameters2D.create(global_position, to_global(point),
												 		collision_mask)
		var result = space_state.intersect_ray(query)
		if result.is_empty():
			valid_points.append(to_global(point))
		else:
			invalid_points.append(result["position"])
	
	if valid_only:
		return valid_points
	else:
		return invalid_points


