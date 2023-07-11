# A class for player controlled character
##
# Manage visual, movement, input
class_name Player
extends Character

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT


# Player skin visual
onready var _skin: PlayerSkin = $PlayerSkin

# Weapon manager
onready var _weapon_manager: WeaponManager = $WeaponManager

onready var _health_comp: HealthComponent = $HealthComponent
onready var _exp_comp: ExpComponent = $ExpComponent
onready var _movement_comp: MovementComponent = $MovementComponent
onready var _hurt_box: HurtBox = $HurtBox
onready var _dodge_comp: DodgeComponent = $DodgeComponent



var is_dead: bool = false

func _ready() -> void:
	_hurt_box.connect("take_damage", self, "_on_take_damage")

	_exp_comp.connect("progress_updated", self, "_on_progress_updated")
	_exp_comp.connect("max_progress_reached", self, "_on_max_progress_reached")
	_exp_comp.connect("xp_updated", self, "_on_xp_updated")
	_exp_comp.connect("xp_required_updated", self, "_on_xp_required_updated")

	_health_comp.connect("die", self, "_on_die")
	
	_dodge_comp.connect("dodge_begin", self, "_on_dodge_begin")
	_dodge_comp.connect("dodge_finished", self, "_on_dodge_finished")

func _on_dodge_begin() -> void:
	_weapon_manager.disable_weapon_manager()

func _on_dodge_finished() -> void:
	_weapon_manager.enable_weapon_manager()

func _on_display_dodge_effect(dodge_effect:DodgeComponent.DodgeVisualEffect) -> void:
	dodge_effect.effect.global_position = global_position
	var visual = _skin.duplicate_visual()
	dodge_effect.effect.add_child(visual)
	Global.add_to_scene_tree(dodge_effect.effect)

func _on_display_dodge_particles(particles_effect:DodgeComponent.DodgeParticlesEffect) -> void:
	particles_effect.particles.global_position = global_position
	Global.add_to_scene_tree(particles_effect.particles)

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

func _on_take_damage(hit_damage:HitDamage) -> void:
	# if character is dead do nothing
	if is_dead: return

	var total_damage = hit_damage._damage

	# if critical hit
	if hit_damage._is_critical:
		total_damage += total_damage * hit_damage._critical_multiplier
	
	# set new health
	_health_comp.damage(total_damage)

	emit_signal("on_character_take_damage", hit_damage, total_damage)

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
		
	
