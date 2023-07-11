class_name Spawner
extends Sprite

export (Array, PackedScene) var list := []
export (int, 0, 100) var spawn_chance_percent := 50
export (int, 1, 4) var num_spawn := 1

func _ready() -> void:
	texture = null
	randomize()

func spawn() -> void:
	if not list:
		return
		
	var chance = randi() % 100
	if chance >= spawn_chance_percent:
		return
	
	for _i in num_spawn:
		var random_scene_index = randi() % list.size()
		var scene: PackedScene = list[random_scene_index]
		
		if not scene:
			continue
		
		var node: Node2D = scene.instance()
		get_parent().add_child(node)
		node.global_position = global_position
