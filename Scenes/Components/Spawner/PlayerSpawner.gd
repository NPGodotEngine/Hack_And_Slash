tool
extends Spawner

# warning-ignore-all: UNUSED_ARGUMENT


export (float) var spawn_radius: float = 50.0

func handle_spawn(resource_name) -> void:
    var player: Player = ResourceLibrary.player_characters[resource_name].instance()
    Global.add_to_scene_tree(player)

    if not player.is_inside_tree():
        yield(player, "ready")
        configure_player(player)
    else:
        configure_player(player)

func configure_player(player:Player) -> void:
    player.global_position = random_point_inside_circle(global_position, 0.0, spawn_radius)

func random_point_inside_circle(center:Vector2, min_radius:float, max_radius:float):
    var random_vector = Vector2(rand_range(-1, 1), rand_range(-1, 1))
    random_vector = random_vector.normalized()
    random_vector *= rand_range(min_radius, max_radius)
    return center + random_vector

func draw_circle_arc(center, radius, angle_from, angle_to, color):
    var nb_points = 32
    var points_arc = PoolVector2Array()

    for i in range(nb_points + 1):
        var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

    for index_point in range(nb_points):
        draw_line(points_arc[index_point], points_arc[index_point + 1], color, 2.0)

func _process(delta: float) -> void:
    if Engine.editor_hint:
        update()

func _draw() -> void:
    if Engine.editor_hint:
        draw_circle_arc(Vector2.ZERO, spawn_radius, 0, 360, Color(1.0, 0.0, 0.0))
