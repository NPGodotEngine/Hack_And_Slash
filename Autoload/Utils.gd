extends Node

# RNG check value is in a range
##
# Roll a randomized value between from_range and to_range
# and then return `true` if the randomized value is under 
# and equal to `threshold` otherwise false
##  
# `from_range`, `to_range` are inclusived
func is_in_threshold(threshold, from_range, to_range) -> bool:
    # RNG
    randomize()
    var rolled_chance = rand_range(from_range, to_range)
    if (rolled_chance < threshold or 
        is_equal_approx(rolled_chance, threshold)):
        return true
    return false