tool
class_name Trigger
extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_SIGNAL



# Emit when trigger pulled successful
signal trigger_pulled()



# Pull trigger
##
# If trigger is ready and pulled
# then it will emit a signal `trigger_pulled`
# and then wait untile next trigger pull ready
# otherwise nothing happend
func pull_trigger() -> void:
    pass