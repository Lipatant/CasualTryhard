extends Sprite2D
class_name SamuraiManiaEnemy

@export var timer : Timer

var _target_old : Vector2
var _target : Vector2
var type : SamuraiManiaSamurai.Frame

func _ready() -> void:
	_target_old = position
	frame_coords.x = type

func _process(_delta: float) -> void:
	if timer and !timer.is_stopped() and timer.wait_time > 0:
		position = _target_old + (_target - _target_old) * (1.0 - timer.time_left / timer.wait_time)
	else:
		position = _target

func set_target(target: Vector2) -> void:
	_target_old = _target
	_target = target
	if timer: timer.start()

func get_target() -> Vector2:
	return _target
