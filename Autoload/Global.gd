extends Node

# Attachment type
##
# `STOCK` gun stock
# `TRIGGER` gun trigger
# `AMMO` gun ammo
# `BARREL` gun barrel
# `ALT` fun alternative fire
enum AttachmentType {
    STOCK = 1,
    TRIGGER = 2,
    AMMO = 4,
    BARREL = 8,
    ALT = 16
}

# Bullet type
enum BulletType {
    PROJECTILE = 1,
    BEAM = 2
}

# Add object to current scene tree
##
# `object` object to be added to scene tree
# `deferrd` if `true` then object will be added to scene tree next frame
# otherwise `false` add object immediatelly default is `true`
func add_to_scene_tree(object:Node, deferrd:bool = true) -> void:
    if object:
        var scene: Node = get_tree().current_scene
        if deferrd:
            scene.call_deferred("add_child", object)
        else:
            scene.add_child(object)

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