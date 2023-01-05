class_name AccuracyComponent
extends Node


class AccuracyContext extends Resource:
    var previous_accuracy: float = 0.0
    var updated_accuracy: float = 0.0

# Emit when accuracy changed
##
# `accuracy_context`: class `AccuracyContext`
signal accuracy_updated(accuracy_context)



# Accuracy
##
# value between 0.0 ~ 1.0
export (float, 0.0, 1.0) var accuracy = 0.5 setget set_accuracy


## Getter Setter ##


func set_accuracy(value:float) -> void:
    var prev_accuracy: float = accuracy
    accuracy = min(max(0.0, value), 1.0)

    var accuracy_context: AccuracyContext = AccuracyContext.new()
    accuracy_context.previous_accuracy = prev_accuracy
    accuracy_context.updated_accuracy = accuracy

    emit_signal("accuracy_updated", accuracy_context)
## Getter Setter ##