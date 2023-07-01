class_name FloatHealthBar
extends Position2D

export (PackedScene) var healthbar_scene: PackedScene

# Health bar UI
var healthbar:HealthBar

# A position 2d whose global position will 
# be updated by this component with healthbar 
# ui attached as child
var _pos: Position2D

func _ready() -> void:
	# instance healthbar
	healthbar = healthbar_scene.instance() as HealthBar

	# add to ui
	_pos = Position2D.new()
	_pos.add_child(healthbar)
	UIEvents.emit_signal("add_float_health_bar_ui", _pos)
	# GameUI.gui.world_ui.add_child(_pos)

	# center health bar
	healthbar.rect_position.x = -healthbar.health_bar_over.rect_size.x / 2.0

	


func _process(_delta: float) -> void:
	_pos.global_position = get_global_transform_with_canvas().origin

func queue_free() -> void:
	if _pos.get_parent():
		_pos.get_parent().remove_child(_pos)
		_pos.queue_free()
	.queue_free()


