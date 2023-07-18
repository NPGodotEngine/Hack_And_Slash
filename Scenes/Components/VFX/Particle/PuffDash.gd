extends GPUParticles2D

# warning-ignore-all: RETURN_VALUE_DISCARDED


@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var timer: Timer = $Timer

# for delay main particles emittion
var _delay: float = 0.1

func _ready() -> void:
    super._ready()
    
    timer.connect("timeout", Callable(self, "queue_free"))
    timer.start(lifetime + particles.lifetime + _delay)
    particles.emitting = true
    particles.process_material.direction = process_material.direction
    await get_tree().create_timer(_delay).timeout
    emitting=true