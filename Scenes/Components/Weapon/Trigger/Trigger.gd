@tool
class_name Trigger
extends Node

# warning-ignore-all: RETURN_VALUE_DISCARDED
# warning-ignore-all: UNUSED_SIGNAL



## Emit when trigger pulled successful
signal trigger_pulled()



## Duration before next trigger pull from last trigger pulled
@export_range(0.1, 10.0) var trigger_duration: float = 1.0

## Is trigger ready to be pulled
var _is_trigger_ready: bool = true

## Pull trigger
##
## If trigger is ready and pulled
## then it will emit a signal `trigger_pulled`
## and then wait untile next trigger pull ready
## otherwise nothing happend
func pull_trigger() -> void:
    pass
