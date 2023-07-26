class_name EnemyBlackboard
extends Blackboard

## To get value of dead status from blackboard
const IS_DEAD = "IsDead"

## To get value of target position from blackboard
## target position might be null value 
const TARGET_POSITION = "target_position"

const PLAYER_TARGET = "player_target"

@onready var _health_comp: HealthComponent = get_node_or_null("%HealthComponent")

func _ready():
	_health_comp.connect("die", Callable(self, "_on_die"))

	set_value(IS_DEAD, false)
	set_value(TARGET_POSITION, null)

func _on_die() -> void:
	set_value(IS_DEAD, true)
