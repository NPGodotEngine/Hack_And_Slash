class_name FlamePool
extends Area2D

# warning-ignore-all:RETURN_VALUE_DISCARDED

# Damage multiplier
##
# For scaling damage from skill
export (float) var _damage_multiplier = 1.0

onready var _flame_particle: Particles2D = $Particles2D

# How long can this pool live
var _life_span: float = 3.0

# The hit damage from skill
var _skill_hit_damage: HitDamage = null

# The body that stand in this area
var _body_contacts: Array = []

# Life span timer
var _life_span_timer: Timer = null

# Damage timer for damage overtime
var _damage_overtime_timer: Timer = null

# Damage interval
var _damage_interval: float = 1.0

func _ready() -> void:
    _life_span_timer = Timer.new()
    add_child(_life_span_timer)
    _life_span_timer.one_shot = true
    _life_span_timer.connect("timeout", self, "queue_free")

    connect("body_entered", self, "_on_body_entered")
    connect("body_exited", self, "_on_body_exited")

    _damage_overtime_timer = Timer.new()
    add_child(_damage_overtime_timer)
    _damage_overtime_timer.one_shot = false
    _damage_overtime_timer.connect("timeout", self, "_on_damage_overtime")

func _exit_tree() -> void:
    if _life_span_timer:
        _life_span_timer.disconnect("timeout", self, "queue_free")
    if _damage_overtime_timer:
        _damage_overtime_timer.disconnect("timeout", self, "_on_damage_overtime")

func setup(hit_dmage:HitDamage, life_span:float, damage_interval:float=1.0) -> void:
    if not is_inside_tree():
        yield(self, "ready")

    _skill_hit_damage = hit_dmage
    _life_span = life_span
    _damage_interval = damage_interval

    _life_span_timer.start(_life_span)
    _damage_overtime_timer.start(_damage_interval)


func _on_body_entered(body:Node) -> void:
    if (not _body_contacts.has(body) and 
        body is Character):
        _body_contacts.append(body)

func _on_body_exited(body:Node) -> void:
    if _body_contacts.has(body):
        _body_contacts.erase(body)

func _on_damage_overtime() -> void:
    if _body_contacts and _body_contacts.size() > 0:
        for body in _body_contacts:
            if is_instance_valid(body):
                var character: Character = body
                character.take_damage(get_scaled_hit_damage())

func  get_scaled_hit_damage() -> HitDamage:
    if _skill_hit_damage:
        return HitDamage.new().init(
            _skill_hit_damage.attacker,
            _skill_hit_damage.skill,
            _skill_hit_damage.damage * _damage_multiplier,
            false,
            Color.white
        )
    return HitDamage.new().init(
        null,
        null, 
        0,
        false, 
        Color.white
    ) 