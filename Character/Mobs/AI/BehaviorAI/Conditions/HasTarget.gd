extends ConditionLeaf

export (NodePath) var target_detector: NodePath
export (NodePath) var target_follower: NodePath

onready var _target_dector: TargetDetector = get_node(target_detector) as TargetDetector

var detected_target

func _ready() -> void:
	yield(get_tree().root, "ready")

	_target_dector.connect("target_detected", self, "_on_target_detected")
	_target_dector.connect("target_lost", self, "_on_target_lost")


func tick(actor, blackboard):
	if detected_target != null:
		blackboard.set("detected_target", detected_target)
		# print("Target detected")
		return SUCCESS
	else:
		blackboard.erase("detected_target")
		# print("Detecting target")
		return FAILED

func _on_target_detected(detected_context:TargetDetector.DetectedContext) -> void:
	detected_target = detected_context.detected_target

func _on_target_lost(target_lost_context:TargetDetector.TargetLostContext) -> void:
	detected_target = null
	

