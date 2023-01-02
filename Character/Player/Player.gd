# A class for player controlled character
##
# Manage visual, movement, input
class_name Player
extends KinematicBody2D

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_ARGUMENT

# Character's max movement speed
##
# Final scaled speed would be capped to this value
# if it is greater than this value
export (float) var max_movement_speed: float = 400.0

# Character's min movement speed
##
# Final scaled speed would be capped to this value
# if it is lower than this value
export (float) var min_movement_speed: float = 0.0

# How fast can player turn from 
# one direction to another
#
# The higher the value the faster player can turn
# and less the smooth of player motion
export (float, 0.1, 1.0) var drag_factor: float = 0.5

# Character movement speed
##
# Get this value will return a movement speed
# scaled by movement speed multiplier
export (float) var movement_speed: float = 200.0


# Constant value for scaling up 
# character's max health
export (int) var _add_health_per_level = 10

# Constant value for scaling up character's
# additional damage
export (int) var _add_damage_per_level = 10

# Player skin visual
onready var _skin := $CharacterSkin

onready var _health_bar: TextureProgress = $HealthBar

# Weapon manager
onready var weapon_manager: WeaponManager = $WeaponManager

onready var _health_comp: HealthComponent = $HealthComponent
onready var _exp_comp: ExpComponent = $ExpComponent
onready var _hurt_box: HurtBox = $HurtBox

export (PackedScene) var _damage_label_scene = preload("res://Interface/HUD/DamageLabel.tscn")
export (Vector2) var _damage_label_offset = Vector2.ZERO 

# Player current velocity
var velocity := Vector2.ZERO

var is_dead: bool = false

func _ready() -> void:
	_hurt_box.connect("take_damage", self, "_on_take_damage")

	_exp_comp.connect("progress_updated", self, "_on_progress_updated")
	_exp_comp.connect("max_progress_reached", self, "_on_max_progress_reached")
	_exp_comp.connect("xp_updated", self, "_on_xp_updated")
	_exp_comp.connect("xp_required_updated", self, "_on_xp_required_updated")

	_health_comp.connect("health_updated", self, "_on_health_updated")
	_health_comp.connect("max_health_updated", self, "_on_max_health_updated")
	_health_comp.connect("low_health_alert", self, "_on_low_health")
	_health_comp.connect("die", self, "_on_die")

func _physics_process(delta: float) -> void:
	move_character(delta)
	update_skin()
	execute_weapons()

func move_character(delta:float) -> void:
	# Get direction from input
	var direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

	# Smoothing player turing direction
	var desired_velocity := direction * movement_speed
	var steering_velocity = desired_velocity - velocity
	steering_velocity  = steering_velocity * drag_factor
	velocity += steering_velocity

	# Move player
	velocity = move_and_slide(velocity)

func update_skin() -> void:
	# Update skin 
	var global_mouse_position := get_global_mouse_position()

	if global_mouse_position.x < global_position.x:
		_skin.scale.x = -1.0 * _skin.scale.abs().x
	else:
		_skin.scale.x = 1.0 * _skin.scale.abs().x


func execute_weapons() -> void:
	assert(weapon_manager, "weapon manager missing")

	# execute weapon 
	if Input.is_action_pressed("primary"): 
		weapon_manager.execute_weapon()
	elif Input.is_action_just_released("primary"):
		weapon_manager.cancel_weapon_execution()

	if Input.is_action_pressed("secondary"):
		weapon_manager.execute_weapon_alt()
	elif Input.is_action_just_released("secondary"):
		weapon_manager.cancel_weapon_alt_execution()

func update_health_bar() -> void:
	_health_bar.min_value = float(0)
	_health_bar.max_value = float(_health_comp.max_health)
	_health_bar.value = float(_health_comp.health)

func _on_progress_updated(progress_context:ExpComponent.ProgressContext) -> void:
	pass

func _on_max_progress_reached(progress_context:ExpComponent.ProgressContext) -> void:
	pass

func _on_xp_updated(xp_context:ExpComponent.ExpContext) -> void:
	pass

func _on_xp_required_updated(xp_required_context:ExpComponent.ExpRequiredContext) -> void:
	pass

func _on_health_updated(health_context:HealthComponent.HealthContext) -> void:
	_health_bar.value = health_context.updated_health

func _on_max_health_updated(max_health_context:HealthComponent.MaxHealthContext) -> void:
	_health_bar.max_value = max_health_context.updated_max_health


func _on_take_damage(hit_damage:HitDamage) -> void:
	# if character is dead do nothing
	if is_dead: return

	var total_damage = hit_damage._damage

	# if critical hit
	if hit_damage._is_critical:
		total_damage += total_damage * hit_damage._critical_multiplier
	
	# set new health
	_health_comp.damage(total_damage)

	prompt_damage_number(total_damage, hit_damage)

	print("%s take damage:%d, critical:%s critical_multiplier:%f" % [
		self.name, total_damage, 
		hit_damage._is_critical,
		hit_damage._critical_multiplier])

func _on_die() -> void:
	print("player die")

# Prompt damage number
func prompt_damage_number(total_damage:int, hit_damage:HitDamage) -> void:
	# Instance a damage label if any
	if _damage_label_scene:
		var damage_label = _damage_label_scene.instance()
		if damage_label:
			call_deferred("add_child", damage_label)
			damage_label.global_position = global_position + _damage_label_offset
			damage_label.set_damage(
				total_damage,
				hit_damage._is_critical, 
				hit_damage._color_of_damage,
				Color.black,
				"-",
				" (Crit)" if hit_damage._is_critical else ""
			)

# Heal character
func heal(amount:int) -> void:
	if is_dead: return
	
	_health_comp.heal(amount)

# for testing health bar
func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("ui_down"): 
		if not is_dead:
			_exp_comp.increase_xp(randi() % 10 + 1)
		logging()
	
	if event.is_action_pressed("ui_left"):
		var crit = randi()%2
		var hit_damage = HitDamage.new().init(
			null, 
			null, 
			randi()%10+1, 
			crit,
			0.0,
			Color.red if crit else Color.white)
		_on_take_damage(hit_damage)
		logging()

func logging() -> void:
	print("level:%d, max_level:%d exp:%d, next_exp:%d, health:%d, max_health:%d, dead:%s" % 
			[_exp_comp._progress, 
			_exp_comp.max_progress, 
			_exp_comp._xp, 
			_exp_comp._xp_required, 
			_health_comp._health,
			_health_comp.max_health, 
			is_dead])
	print("movement_speed:%f" % [movement_speed])
		
	