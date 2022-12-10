class_name FreezePool
extends Area2D

# warning-ignore-all:RETURN_VALUE_DISCARDED 

# How much factor to slow down contacted characters
export (float, 0.0, 1.0) var speed_reduction = 0.20

# The body that stand in this area
var _body_contacts: Array = []

# How long can this pool live
var _life_span: float = 3.0

# Life span timer
var _life_span_timer: Timer


func _ready() -> void:
    connect("body_entered", self, "_on_body_entered")
    connect("body_exited", self, "_on_body_exited")

    _life_span_timer = Timer.new()
    add_child(_life_span_timer)
    _life_span_timer.one_shot = true
    _life_span_timer.connect("timeout", self, "_on_life_span_timeout")

    setup(_life_span, speed_reduction)

func _exit_tree() -> void:
    if _life_span_timer:
        _life_span_timer.disconnect("timeout", self, "_on_life_span_timeout")

func setup(life_span:float, reduction:float) -> void:
    if not is_inside_tree():
        yield(self, "ready")

    _life_span = life_span
    speed_reduction = reduction

    _life_span_timer.start(_life_span)

func _on_body_entered(body:Node) -> void:
    if (not _body_contacts.has(body) and 
        body is Character):
        _body_contacts.append(body)
        var character: Character = body as Character
        character.add_movement_speed_reduction(speed_reduction)

func _on_body_exited(body:Node) -> void:
    if _body_contacts.has(body):
        _body_contacts.erase(body)
        if is_instance_valid(body):
            var character: Character = body as Character
            character.remove_movement_speed_reduction(speed_reduction)

func _on_life_span_timeout() -> void:
    for body in _body_contacts:
        if is_instance_valid(body):
            var character: Character = body as Character
            character.remove_movement_speed_reduction(speed_reduction)

    queue_free()