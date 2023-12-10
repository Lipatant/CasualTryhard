extends Area2D
class_name FishdertaleRod

# EXPORTS #

@export var collision_shape : CollisionShape2D
@export var sprite : Sprite2D
@export var timer : Timer

# OTHERVARIABLES #

var fixed_rotation : float

# PROCESS #

func _ready() -> void:
	_physics_process(0.0)

func _physics_process(_delta: float) -> void:
	if timer and timer.wait_time > 0 and sprite:
		var position_scale : float = ((timer.time_left / timer.wait_time) * 2 - 1.0) if (timer.time_left > timer.wait_time / 2) else (1.0 - (timer.time_left / timer.wait_time) * 2)
		position = Vector2(-1024.0 * 1.5 * (position_scale * 2 - 0.5), 0.0).rotated(fixed_rotation)
		set_rotation(fixed_rotation)

# SIGNALS #

func _on_timer_timeout():
	queue_free()
