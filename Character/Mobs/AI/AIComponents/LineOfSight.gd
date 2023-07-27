extends RayCast2D

## Enable debug draw 
@export var debug_draw: bool = false

## Line width of debug line
@export_range(1.0, 10.0) var line_width: float = 1.0

## Color of debug line
@export_color_no_alpha var color: Color = Color.RED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if debug_draw:
		queue_redraw()

func _draw():
	if debug_draw:
		var final_position: Vector2 = target_position
		if is_colliding():
			final_position = to_local(get_collision_point())
		draw_line(Vector2.ZERO, final_position, color, line_width)
