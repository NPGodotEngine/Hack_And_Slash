extends Node2D

signal target_found(target)

@export_range(0.2, 10.0) var seeking_freq: float = 1.0

func _ready():
	locate_target()

func locate_target() -> void:
	await get_tree().create_timer(seeking_freq).timeout
	var target = null
	for p in get_tree().get_nodes_in_group("Player"):
		target = p
		break
	emit_signal("target_found", target)
	locate_target()
