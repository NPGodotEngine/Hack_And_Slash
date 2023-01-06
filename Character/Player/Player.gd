# A class for player controlled character
##
# Manage visual, movement, input
class_name Player
extends KinematicBody2D

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT


# Player skin visual
onready var _skin := $PlayerSkin

onready var _health_bar: HealthBar = $HealthBar

# Weapon manager
onready var _weapon_manager = null

onready var _health_comp: HealthComponent = $HealthComponent
onready var _exp_comp: ExpComponent = $ExpComponent
onready var _movement_comp: MovementComponent = $MovementComponent
onready var _hurt_box: HurtBox = $HurtBox



var is_dead: bool = false

func _ready() -> void:
	_health_bar.health = _health_comp._health
	_health_bar.max_health = _health_comp.max_health
	
	_hurt_box.connect("take_damage", self, "_on_take_damage")

	_exp_comp.connect("progress_updated", self, "_on_progress_updated")
	_exp_comp.connect("max_progress_reached", self, "_on_max_progress_reached")
	_exp_comp.connect("xp_updated", self, "_on_xp_updated")
	_exp_comp.connect("xp_required_updated", self, "_on_xp_required_updated")

	_health_comp.connect("health_updated", self, "_on_health_updated")
	_health_comp.connect("max_health_updated", self, "_on_max_health_updated")
	_health_comp.connect("low_health_alert", self, "_on_low_health")
	_health_comp.connect("die", self, "_on_die")

	_health_bar.max_health = _health_comp.max_health
	_health_bar.health = _health_comp._health
	

func _on_progress_updated(progress_context:ExpComponent.ProgressContext) -> void:
	print("level up %f -> %f / %f" % [progress_context.previous_progress, 
								progress_context.updated_progress,
								progress_context.max_progress])
	pass

func _on_max_progress_reached(progress_context:ExpComponent.ProgressContext) -> void:
	print("max level reached %f / %f" % [progress_context.updated_progress, 
									progress_context.max_progress])
	pass

func _on_xp_updated(xp_context:ExpComponent.ExpContext) -> void:
	print("xp updated %f -> %f / %f" % [xp_context.previous_xp, 
							xp_context.updated_xp,
							xp_context.xp_required])
	pass

func _on_xp_required_updated(xp_required_context:ExpComponent.ExpRequiredContext) -> void:
	print("xp required increase %f -> %f" % [xp_required_context.previous_xp_required, 
								xp_required_context.updated_xp_required])
	pass

func _on_health_updated(health_context:HealthComponent.HealthContext) -> void:
	_health_bar.health = health_context.updated_health
	print("health %f -> %f" % [health_context.previous_health, health_context.updated_health])

func _on_max_health_updated(max_health_context:HealthComponent.MaxHealthContext) -> void:
	_health_bar.max_health = max_health_context.updated_max_health
	print("max health %f -> %f" % [max_health_context.previous_max_health, max_health_context.updated_max_health])

func _on_low_health(health_context:HealthComponent.HealthContext) -> void:
	print("low health alert %f / %f" % [health_context.updated_health, health_context.max_health])


func _on_take_damage(hit_damage:HitDamage) -> void:
	# if character is dead do nothing
	if is_dead: return

	var total_damage = hit_damage._damage

	# if critical hit
	if hit_damage._is_critical:
		total_damage += total_damage * hit_damage._critical_multiplier
	
	# set new health
	_health_comp.damage(total_damage)

	# Show damage text
	Events.emit_signal("present_damage_text", hit_damage, global_position)

	print("%s take damage:%d, critical:%s critical_multiplier:%f" % [
		self.name, total_damage, 
		hit_damage._is_critical,
		hit_damage._critical_multiplier])

func _on_die() -> void:
	print("player die")

# Heal character
func heal(amount:int) -> void:
	if is_dead: return
	
	_health_comp.heal(amount)

# for testing health bar
func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("ui_down"): 
		if not is_dead:
			# var added_xp = rand_range(100.0, 440.0)
			var added_xp = 1000000.0
			print("added xp %f" % added_xp)
			_exp_comp.increase_xp(added_xp)
	
	if event.is_action_pressed("ui_left"):
		var crit = randi()%2
		var hit_damage = HitDamage.new().init(
			null, 
			null, 
			rand_range(1.0, 10.0), 
			crit,
			0.0,
			Color.red if crit else Color.white)
		_on_take_damage(hit_damage)
		
	
