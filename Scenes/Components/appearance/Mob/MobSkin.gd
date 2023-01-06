class_name MobSkin
extends Node2D

onready var _animation_player := $AnimationPlayer

func play_hit() -> void:
    _animation_player.stop()
    _animation_player.play("hit", -1, 2)

func play_die() -> void:
    _animation_player.stop()
    _animation_player.play("dead")