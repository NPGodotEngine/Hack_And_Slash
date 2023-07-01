class_name Mob
extends Character

# warning-ignore-all:RETURN_VALUE_DISCARDED
# warning-ignore-all:UNUSED_ARGUMENT



onready var _skin: MobSkin = $MobSkin
onready var _health_comp = $HealthComponent
onready var _health_bar_remote: FloatHealthBar = $FloatHealthBar
onready var _hurt_box: HurtBox = $HurtBox

var _target: Player = null

var is_dead: bool = false

func _ready() -> void:
	_hurt_box.connect("take_damage", self, "_on_take_damage")

	_health_comp.connect("health_updated", self, "_on_health_updated")
	_health_comp.connect("max_health_updated", self, "_on_max_health_updated")
	_health_comp.connect("low_health_alert", self, "_on_low_health_alert")
	_health_comp.connect("die", self, "_on_die")

	_health_bar_remote.healthbar.max_health = _health_comp.max_health
	_health_bar_remote.healthbar.health = _health_comp._health



func _on_health_updated(health_context:HealthComponent.HealthContext) -> void:
	_health_bar_remote.healthbar.health = health_context.updated_health

func _on_max_health_updated(max_health_context:HealthComponent.MaxHealthContext) -> void:
	_health_bar_remote.healthbar.max_health = max_health_context.updated_max_health

func _on_low_health_alert(health_context:HealthComponent.HealthContext) -> void:
	pass

func _on_take_damage(hit_damage:HitDamage) -> void:
	# if character is dead do nothing
	if is_dead: return

	var total_damage = hit_damage._damage

	# if critical hit
	if hit_damage._is_critical:
		total_damage += total_damage * hit_damage._critical_multiplier

	_health_comp.damage(total_damage)
	
	emit_signal("on_character_take_damage", hit_damage, total_damage)

	if not is_dead:
		_skin.play_hit()
	

func _on_die() -> void:
	is_dead = true
	_health_bar_remote.healthbar.hide()
	_skin.play_die()

func queue_free() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	.queue_free()

