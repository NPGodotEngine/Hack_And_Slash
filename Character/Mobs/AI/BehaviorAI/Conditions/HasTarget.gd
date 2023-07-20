extends ConditionLeaf

@export var target_detector_ref: NodePath
@export var target_follower_ref: NodePath

@onready var _target_dector: TargetDetector = get_node(target_detector_ref) as TargetDetector

var detected_target

func _ready() -> void:
	await get_tree().root.ready

	_target_dector.connect("target_detected", Callable(self, "_on_target_detected"))
	_target_dector.connect("target_lost", Callable(self, "_on_target_lost"))



func tick(actor:Node, blackboard:Blackboard):
	super(actor, blackboard)

	if detected_target != null:
		blackboard.set_value("detected_target", detected_target)
		# print("Target detected")
		return SUCCESS
	else:
		blackboard.erase_value("detected_target")
		# print("Detecting target")
		return FAILED

func _on_target_detected(detected_context:TargetDetector.DetectedContext) -> void:
	detected_target = detected_context.detected_target

func _on_target_lost(_target_lost_context:TargetDetector.TargetLostContext) -> void:
	detected_target = null
	

