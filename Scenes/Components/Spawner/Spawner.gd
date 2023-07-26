class_name Spawner
extends Sprite2D

# warning-ignore-all: UNUSED_ARGUMENT


@export var list :Array[String] = []
@export_range(0, 100) var spawn_chance_percent :int = 100
@export var num_spawn :int = 1
@export var spawn_radius: float = 50.0

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	texture = null
	randomize()

func spawn() -> void:
	if not list:
		return
		
	var chance = randi() % 100
	if chance >= spawn_chance_percent:
		return
	
	for _i in num_spawn:
		var random_name_index = randi() % list.size()
		
		handle_spawn(list[random_name_index])

func handle_spawn(_resource_name:String) -> void:
	pass

## Get a random point as `Vector2` from a circle
func random_point_inside_circle(center:Vector2, min_radius:float, max_radius:float):
	var random_vector = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	random_vector = random_vector.normalized()
	random_vector *= randf_range(min_radius, max_radius)
	return center + random_vector

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PackedVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, 2.0)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_circle_arc(Vector2.ZERO, spawn_radius, 0, 360, Color(1.0, 0.0, 0.0))
