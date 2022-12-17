tool
extends Weapon

# warning-ignore-all: UNUSED_ARGUMENT

var _from_pos: Vector2 = Vector2.ZERO
var _to_pos: Vector2 = Vector2.ZERO
var _direction: Vector2 = Vector2.ZERO

func execute(from_position:Vector2, to_position:Vector2, direction:Vector2) -> void:
    .execute(from_position, to_position, direction)
    _from_pos = from_position
    _to_pos = to_position
    _direction = direction

    if trigger:
        trigger.pull_trigger()


func cancel_execution() -> void:
    .cancel_execution()

func execute_alt(from_position:Vector2, to_position:Vector2, direction:Vector2) -> void:
	.execute_alt(from_position, to_position, direction)

func cancel_alt_execution() -> void:
	.cancel_alt_execution()

func active() -> void:
	.active()

func inactive() -> void:
	.inactive()

func _on_trigger_pulled() -> void:
    ._on_trigger_pulled()

    var hit_damage: HitDamage = get_hit_damage()
    var spread_direction: Vector2 = _accuracy_comp.get_random_spread(_direction, get_weapon_accuracy())
    var to_new_pos: Vector2 =  spread_direction * _from_pos.distance_to(_to_pos) + _from_pos

    if ammo:
        ammo.shoot_ammo(_from_pos, to_new_pos, hit_damage)

func _on_ammo_depleted(ammo_count:int, round_per_clip:int) -> void:
    ._on_ammo_depleted(ammo_count, round_per_clip)

    if ammo:
        ammo.reload_ammo()

func _on_ammo_count_changed(ammo_count:int, round_per_clip:int) -> void:
    ._on_ammo_count_changed(ammo_count, round_per_clip)

func _on_begin_reloading(ammo_count:int, round_per_clip:int) -> void:
    ._on_begin_reloading(ammo_count, round_per_clip)

func _on_end_reloading(ammo_count:int, round_per_clip:int) -> void:
    ._on_end_reloading(ammo_count, round_per_clip)

func _on_damage_changed(from, to) -> void:
    ._on_damage_changed(from, to)

func _on_accuracy_changed(from, to) -> void:
    ._on_accuracy_changed(from, to)


# Get hit damage from weapon
func get_hit_damage() -> HitDamage:
    var damage: int = get_weapon_damage()
    var critical: bool = _critical_strike_comp.is_critical()
    var color: Color = (_critical_strike_comp.critical_strike_color if critical 
                                        else _damage_comp.damage_color)
    var hit_damage: HitDamage = HitDamage.new().init(
        weapon_manager.get_manager_owner(),
        self,
        damage,
        critical,
        _critical_strike_comp.critical_strike_multiplier,
        color
    )

    return hit_damage
    

