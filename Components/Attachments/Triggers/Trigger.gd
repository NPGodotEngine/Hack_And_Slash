class_name Trigger
extends Attachment

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_SIGNAL

# Emit when trigger pulled successful
signal trigger_pulled()

# Duration before next trigger pull from last trigger pulled
export (float, 0.1, 10) var pull_duration = 1.0

# Pull trigger
##
# If trigger is ready and pulled
# then it will emit a signal `trigger_pulled`
# and then wait untile next trigger pull ready
# otherwise nothing happend
func pull_trigger() -> void:
    pass
