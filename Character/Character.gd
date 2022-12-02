# A generic class extended KinematicBody2D 
# and must be extended from object such as
# Player, Monster, NPC anything that is alive
##
# Class manage damge, health and die
class_name Character
extends KinematicBody2D

# Emit when health changed
signal health_changed(from_health, to_health)

# Emit when max health changed
signal max_health_changed(from_max_health, to_meax_health)

# Emit when taking damage
signal take_damage(amount)

# Emit when character die
signal die(character)

# Health
export (int) var health := 100 setget _set_health

# Set character health
func _set_health(value:int) -> void:
    # make sure health is between 0 ~ max health
    var new_health = int(min(max(0, value), max_health))
    var old_health = health
    health = new_health
    emit_signal("health_changed", old_health, new_health)

# Max health
export (int) var max_health := 100 setget _set_max_health

func _set_max_health(value:int) -> void:
    var old_max_health = max_health
    max_health = value
    emit_signal("max_health_changed", old_max_health, max_health)

# Damage
export (int) var damage := 10

# Is character dead
var is_dead: bool = false

func _ready() -> void:
    self.max_health = max_health
    self.health = max_health

# Character take damage
func take_damge(amount:int) -> void:
    # if character is dead do nothing
    if is_dead: return

    # set new health
    self.health = health - amount
    emit_signal("take_damage", amount)

    if health <= 0:
        die()

# Character die
func die() -> void:
    is_dead = true
    emit_signal("die", self)