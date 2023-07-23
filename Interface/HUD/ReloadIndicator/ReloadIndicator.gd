class_name ReloadIndicator
extends Control

@onready var progressbar: TextureProgressBar = $ProgressBar
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():
	anim_player.connect("animation_finished", Callable(self, "_on_anim_finished"))

func _on_anim_finished(anim_name:StringName) -> void:
	if anim_name == "shrink":
		hide()

## Update reload progress
## between 0.0 ~ 1.0
## `progress`: current progress
## `max_progress`: max progress
func update_reload_progress(progress:float, max_progress:float) -> void:
	progressbar.value = progress / max_progress

func animate_show() -> void:
	show()
	anim_player.play("pop")

func animate_hide() -> void:
	show()
	anim_player.play("shrink")

func _process(_delta):
	global_position = get_global_mouse_position()
