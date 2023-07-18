class_name Spawner
extends Sprite2D

# warning-ignore-all: UNUSED_ARGUMENT


@export var list :Array[String] = []
@export_range(0, 100) var spawn_chance_percent :int = 100
@export var num_spawn :int = 1

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	texture = null
	randomize()

	super._ready()

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
