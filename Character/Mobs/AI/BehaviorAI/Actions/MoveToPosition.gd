extends ActionLeaf

## `true` will intrrupt moving when vision cone
## detected player
@export var alert: bool = true

@onready var nav_agent: NavigationAgent2D = get_node_or_null("%PathFinder")
@onready var vision_area: Area2D = get_node_or_null("%Vision/VisionConeArea")


func tick(actor:Node, blackboard:Blackboard) -> int:
	var is_dead: bool = blackboard.get_value(EnemyBlackboard.IS_DEAD)
	var player: Player = blackboard.get_value(EnemyBlackboard.PLAYER_TARGET)

	if is_dead:
		nav_agent.target_position = actor.global_position
		return FAILURE
	
	if nav_agent.is_navigation_finished():
		return SUCCESS

	if alert and target_in_vision(player):
		nav_agent.target_position = actor.global_position
		return FAILURE
	
	return RUNNING

func target_in_vision(target: Player) -> bool:
	if target == null:
		return false

	for b in vision_area.get_overlapping_bodies():
		if b == target:
			return true
	return false