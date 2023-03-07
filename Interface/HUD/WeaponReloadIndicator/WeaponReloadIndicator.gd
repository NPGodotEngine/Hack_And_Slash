extends Node

export (NodePath) var ammo: NodePath
export (PackedScene) var reloadbar_scene: PackedScene

onready var _ammo:Ammo = get_node(ammo) as Ammo

var _reloadbar: Node2D

func _ready() -> void:
    _reloadbar = reloadbar_scene.instance() as Node2D
    GameUI.gui.hud.add_child(_reloadbar)
    _reloadbar.hide()
    var circular_bar:CircularFillBar = _reloadbar.get_child(0) as CircularFillBar
    circular_bar.rect_position = -circular_bar.texture_progress.get_size() / 2.0 

    _ammo.connect("begin_reloading", self, "_on_begin_reloading")
    _ammo.connect("end_reloading", self, "_on_end_reloading")

    

func _on_begin_reloading(ammo_context) -> void:
    _reloadbar.show()

func _on_end_reloading(ammo_context) -> void:
    var circular_bar:CircularFillBar = _reloadbar.get_child(0) as CircularFillBar
    circular_bar.update_progress(1.0, 1.0)
    _reloadbar.hide()

func _process(delta: float) -> void:
    if _reloadbar:
        _reloadbar.global_position = _reloadbar.get_global_mouse_position()

    if _ammo._is_reloading:
        var progress: Ammo.AmmoReloadProgress = _ammo.progress
        var circular_bar:CircularFillBar = _reloadbar.get_child(0) as CircularFillBar
        circular_bar.update_progress(progress.progress, progress.max_progress)

func queue_free() -> void:
    if _reloadbar:
        _reloadbar.get_parent().remove_child(_reloadbar)
        _reloadbar.queue_free()
    
    .queue_free()