extends Particles2D

# warning-ignore-all: RETURN_VALUE_DISCARDED


onready var particles: Particles2D = $Particles2D
onready var timer: Timer = $Timer

# for delay main particles emittion
var _delay: float = 0.1

func _ready() -> void:
    timer.connect("timeout", self, "queue_free")
    timer.start(lifetime + particles.lifetime + _delay)
    particles.emitting = true
    particles.process_material.direction = process_material.direction
    yield(get_tree().create_timer(_delay), "timeout")
    emitting=true