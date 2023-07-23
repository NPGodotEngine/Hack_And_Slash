class_name WeaponAttributes
extends Resource



## Max damage
@export var max_damage: float = 1000.0

## Min damage
@export var min_damage: float = 1.0

## Critical chance
@export_range(0.0, 1.0) var critical_chance: float = 0.0

## Critical_multiplier
@export var critical_multiplier: float = 1.0

## Accuracy
@export_range(0.0, 1.0) var accuracy: float = 0.5

## Spread radius
@export_range(0.0, 100.0) var spread_radius: float = 10.0

## Trigger duration
@export var trigger_duration: float = 1.0

## Reload duration
@export var reload_duration: float = 1.0

## Round per clip
@export var round_per_clip: int = 30