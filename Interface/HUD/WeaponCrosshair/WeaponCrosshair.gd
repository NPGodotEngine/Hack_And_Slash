extends Node

export (NodePath) var ammo: NodePath
export (PackedScene) var crosshair_scene: PackedScene

onready var _ammo:Ammo = get_node(ammo) as Ammo

var _crosshiar: Node2D


func _ready() -> void:
    _crosshiar = crosshair_scene.instance() as Node2D
    GameUI.gui.hud.add_child(_crosshiar)

    _ammo.connect("begin_reloading", self, "_on_begin_reloading")
    _ammo.connect("end_reloading", self, "_on_end_reloading")

func _on_begin_reloading(ammo_context) -> void:
    _crosshiar.hide()

func _on_end_reloading(ammo_context) -> void:
    _crosshiar.show()

func _process(delta: float) -> void:
    if _crosshiar:
        _crosshiar.global_position = _crosshiar.get_global_mouse_position()

func queue_free() -> void:
    if _crosshiar:
        _crosshiar.get_parent().remove_child(_crosshiar)
        _crosshiar.queue_free()
    
    .queue_free()

