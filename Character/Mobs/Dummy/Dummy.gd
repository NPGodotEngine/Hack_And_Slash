extends Character

# warning-ignore-all:RETURN_VALUE_DISCARDED

onready var _health_bar := $HealthBar
onready var _animation_player := $AnimationPlayer

func setup() -> void:
	.setup()
	
	connect("health_changed", self, "_on_health_changed")
	connect("max_health_changed", self, "_on_max_health_changed")
	connect("take_damage", self, "_on_take_damage")
	connect("die", self, "_on_die")

	_update_health_bar()

func _update_health_bar() -> void:
	_health_bar.min_value = float(0)
	_health_bar.max_value = float(_max_health)
	_health_bar.value = float(_health)

func _on_health_changed(_from_health:int, _to_health:int) -> void:
	_update_health_bar()

func _on_max_health_changed(_from_max_health:int, _to_max_health:int) -> void:
	_update_health_bar()

func _on_take_damage(_hit_damage:HitDamage, total_damage:int) -> void:
	_animation_player.stop()
	_animation_player.play("hit", -1, 2)

func _on_die(_character:Character) -> void:
    _animation_player.play("die")
    print("dummy die %d / %d" %[_health, _max_health])



