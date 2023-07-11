class_name Spawner
extends Sprite

export (Array, String) var list := []
export (int, 0, 100) var spawn_chance_percent := 100
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
		var random_name_index = randi() % list.size()
		
		handle_spawn(list[random_name_index])

func handle_spawn(resource_name:String) -> void:
	pass
