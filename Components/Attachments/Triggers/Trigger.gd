tool
class_name Trigger
extends Attachment

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_SIGNAL

# Emit when trigger pulled successful
signal trigger_pulled()

func _on_component_ready() -> void:
    ._on_component_ready()

    attachment_type = Global.AttachmentType.TRIGGER

# Pull trigger
##
# If trigger is ready and pulled
# then it will emit a signal `trigger_pulled`
# and then wait untile next trigger pull ready
# otherwise nothing happend
func pull_trigger() -> void:
    pass
