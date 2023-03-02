class_name FloatHealthBar
extends RemoteTransform2D

export (PackedScene) var healthbar_scene: PackedScene

# Health bar UI
var healthbar:HealthBar

# A position 2d whose global position will 
# be updated by this remote with healthbar 
# ui attached as child
var _pos: Position2D

func _ready() -> void:
	# instance healthbar
	healthbar = healthbar_scene.instance() as HealthBar

	# add to ui
	_pos = Position2D.new()
	GameUI.gui.world_ui.add_child(_pos)
	_pos.add_child(healthbar)

	# center health bar
	healthbar.rect_position.x = -healthbar.health_bar_over.rect_size.x / 2.0

	# set remote path
	remote_path = _pos.get_path()

func queue_free() -> void:
	if _pos.get_parent():
		_pos.get_parent().remove_child(_pos)
		_pos.queue_free()
	.queue_free()


