extends ConditionLeaf

## `true` NavigationAgent2D's velocity will be set to (0.0, 0.0)
@export var stop_navigation_agent: bool = false

@onready var nav_agent: NavigationAgent2D = get_node_or_null("%NavigationAgent2D")
@onready var vision_area: Area2D = get_node_or_null("%Vision/VisionConeArea")


func tick(_actor:Node, blackboard:Blackboard) -> int:
	var target: Player = blackboard.get_value(EnemyBlackboard.PLAYER_TARGET)

	for b in vision_area.get_overlapping_bodies():
		if b == target:
			return SUCCESS
	
	if stop_navigation_agent:
		nav_agent.set_velocity(Vector2.ZERO)
	return FAILURE