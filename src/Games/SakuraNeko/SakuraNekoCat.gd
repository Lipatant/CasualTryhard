extends Area2D
class_name SakuraNekoCat

# EXPORT #

@export var speed : float = 100.0
@export var collision_shape : CollisionShape2D
@export var sprite : Sprite2D

# OTHER VARIABLES #

var target : Vector2

# READY #

func _ready() -> void:
	target = global_position

# PROCESS #

func _physics_process(delta: float) -> void:
	if global_position.y == target.y:
		return
	var difference : float = target.y - global_position.y
	var velocity : float = 0.0
	if abs(difference) < speed * delta:
		velocity = difference
	else:
		velocity = (1.0 if difference > 0 else -1.0) * speed * delta
	position.y += velocity
