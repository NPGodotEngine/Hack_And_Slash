tool
extends Weapon

# warning-ignore-all: RETURN_VALUE_DISCARDED

export(NodePath) var accuracy: NodePath
export(NodePath) var angle_spread: NodePath
export(NodePath) var trigger: NodePath
export(NodePath) var projectile_ammo: NodePath
export(Array, NodePath) var fire_points: Array
export(NodePath) var appearance: NodePath

onready var _accuracy: AccuracyComponent = get_node(accuracy)
onready var _angle_spread: AngleSpreadComponent = get_node(angle_spread)
onready var _trigger: Trigger = get_node(trigger)
onready var _projectile_ammo: ProjectileAmmo = get_node(projectile_ammo)
onready var _fire_points: Array = get_fire_points()
onready var _appearance: Node2D = get_node(appearance)


func _get_configuration_warning() -> String:
    var warning =  ._get_configuration_warning()
    if warning != "":
        return warning
    
    if accuracy.is_empty():
        return "accuracy node path is missing"
    if not get_node(accuracy) is AccuracyComponent:
        return "accuracy must be a AccuracyComponent node"
    if angle_spread.is_empty():
        return "angle_spread node path is missing"
    if not get_node(angle_spread) is AngleSpreadComponent:
        return "angle_spread must be a AngleSpreadComponent node"
    if trigger.is_empty():
        return "trigger node path is missing"
    if not get_node(trigger) is Trigger:
        return "trigger must be a Trigger node"
    if projectile_ammo.is_empty():
        return "projectile_ammo node path is missing"
    if not get_node(projectile_ammo) is ProjectileAmmo:
        return "projectile_ammo must be a ProjectileAmmo node"
    if fire_points.size() == 0:
        return "at least 1 node path in fire_points"
    for point in get_fire_points():
        if not point is Position2D:
            return "fire_points must contain Position2D node"
    if appearance.is_empty():
        return "appearance node path is missing"
    if not get_node(appearance) is Node2D:
        return "appearance must be a Node2D node"
    return ""

func _ready() -> void:
    _trigger.connect("trigger_pulled", self, "_on_trigger_pulled")

func _on_trigger_pulled() -> void:
    for point in _fire_points:
        if _projectile_ammo._is_reloading:
            return
        var position = (point as Position2D).global_position
        var global_mouse_position = get_global_mouse_position()
        var distance: float = position.distance_to(global_mouse_position)
        var end_position = _angle_spread.get_random_spread(global_mouse_position - self.global_position, 
                                                _accuracy.accuracy) * distance + position
        var hit_damage: HitDamage = get_hit_damage()
        var bullet: Projectile = _projectile_ammo.consume_ammo(position, 
                                            end_position, hit_damage)
        Global.add_to_scene_tree(bullet)
        print(hit_damage._damage)

func update_weapon_skin() -> void:
    if Engine.editor_hint:
        return 
    # Update weapon skin facing direction
    var global_mouse_position := get_global_mouse_position()

    if global_mouse_position.x < global_position.x:
        _appearance.scale.y = -1.0 * _appearance.scale.abs().y
    else:
        _appearance.scale.y = 1.0 * _appearance.scale.abs().y

    var point_dir: Vector2 = global_mouse_position - self.global_position
    self.rotation = point_dir.angle()

func get_fire_points() -> Array:
    var points: Array = []
    for node_path in fire_points:
        points.append(get_node(node_path))
    return points

func execute() -> void:
    _trigger.pull_trigger()

func cancel_execution() -> void:
	pass

func execute_alt() -> void:
	pass

func cancel_alt_execution() -> void:
	pass

func active() -> void:
    .active()
    _appearance.show()

func inactive() -> void:
    .inactive()
    _appearance.hide()