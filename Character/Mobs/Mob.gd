class_name Mob
extends Character

# warning-ignore-all:RETURN_VALUE_DISCARDED
# warning-ignore-all:UNUSED_ARGUMENT


onready var _skin: MobSkin = $MobSkin
onready var _health_comp = $HealthComponent
onready var _hurt_box: HurtBox = $HurtBox

var mob_behavior_ai: BeehaveRoot
var is_dead: bool = false

func _ready() -> void:
	_hurt_box.connect("take_damage", self, "_on_take_damage")

	_health_comp.connect("die", self, "_on_die")

	for child in get_children():
		if child is BeehaveRoot:
			mob_behavior_ai = child
			break

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
	if mob_behavior_ai:
		mob_behavior_ai.disable()
	_skin.play_die()

func queue_free() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
	.queue_free()

